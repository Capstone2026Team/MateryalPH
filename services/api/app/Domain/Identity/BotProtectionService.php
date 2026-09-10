<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\BotRiskChallenge;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class BotProtectionService
{
    public function __construct(
        private readonly RecaptchaAssessmentGateway $assessments,
        private readonly EmailOtpService $otps,
        private readonly AuditRecorder $audit,
    ) {}

    /** @param array<string, mixed>|null $vendorEvidence */
    public function guard(
        Request $request,
        string $email,
        string $portal,
        string $operation,
        ?array $vendorEvidence,
        ?string $riskProofToken,
        bool $deliveryAllowed,
        ?User $user = null,
    ): bool {
        if ($portal === 'ADMIN') {
            return false;
        }

        $action = $this->action($portal, $operation);
        if ($portal === 'BUYER') {
            if (! is_string($riskProofToken) || $riskProofToken === '') {
                return false;
            }

            $this->consumeProof($request, $riskProofToken, $email, $portal, $action);

            return true;
        }
        if ($portal !== 'VENDOR') {
            throw new AuthenticationException('BOT_CLIENT_INVALID', 'This client cannot complete the requested authentication action.', 422);
        }
        if (! (bool) config('materyalph.bot_protection.enabled', false)) {
            return false;
        }

        $vendorEvidence ??= [];
        $platform = 'WEB';
        [$siteKey, $allowedIdentity] = $this->providerConfiguration();

        if (($vendorEvidence['request_email_step_up'] ?? false) === true) {
            $this->requireEmailStepUp($request, $email, $portal, $action, $platform, 'ACCESSIBLE_FALLBACK', $deliveryAllowed, $user);
        }

        $token = $vendorEvidence['recaptcha_token'] ?? null;
        if (! is_string($token) || $token === '') {
            $proof = $this->proofFrom($request);
            if ($proof !== null) {
                $this->consumeProof($request, $proof, $email, $portal, $action, $platform);

                return true;
            }
            $this->requireEmailStepUp($request, $email, $portal, $action, $platform, 'TOKEN_MISSING', $deliveryAllowed, $user);
        }

        try {
            $assessment = $this->assessments->assess($token, $siteKey, $action);
        } catch (RecaptchaProviderUnavailable) {
            $this->requireEmailStepUp($request, $email, $portal, $action, $platform, 'PROVIDER_UNAVAILABLE', $deliveryAllowed, $user);
        }

        $identityMatches = in_array(mb_strtolower((string) $assessment->hostname), $allowedIdentity, true);
        $passes = $assessment->valid
            && hash_equals($action, (string) $assessment->action)
            && $identityMatches;

        if (! $passes) {
            $this->requireEmailStepUp($request, $email, $portal, $action, $platform, 'ASSESSMENT_REJECTED', $deliveryAllowed, $user);
        }

        return false;
    }

    public function verifyChallenge(Request $request, string $challengeId, string $email, string $code, string $expectedPortal): BotProofResult
    {
        $normalized = $this->normalize($email);

        $result = DB::transaction(function () use ($request, $challengeId, $normalized, $code, $expectedPortal): BotProofResult|AuthenticationException {
            /** @var BotRiskChallenge|null $challenge */
            $challenge = BotRiskChallenge::query()->lockForUpdate()->find($challengeId);
            $this->assertChallengeOpen($request, $challenge, $normalized, $expectedPortal);
            try {
                $this->otps->verifyForBotRiskChallenge($normalized, $code, $challenge->getKey());
            } catch (AuthenticationException $exception) {
                // Commit failed-attempt accounting while retaining the challenge lock.
                return $exception;
            }

            $token = $this->newToken();
            $expiresIn = (int) config('materyalph.bot_protection.step_up_ttl_minutes', 5) * 60;
            $challenge->forceFill([
                'proof_hash' => $this->hashProof($token),
                'verified_at' => now(),
                'proof_expires_at' => now()->addSeconds($expiresIn),
            ])->save();
            $this->audit->record($request, 'BOT_RISK_CHALLENGE_VERIFIED', true, safeContext: [
                'portal' => $challenge->portal,
                'action' => $challenge->action,
                'platform' => $challenge->platform,
            ]);

            return new BotProofResult($token, $expiresIn, (string) $challenge->platform);
        });
        if ($result instanceof AuthenticationException) {
            throw $result;
        }

        return $result;
    }

    public function resendChallenge(Request $request, string $challengeId, string $email, string $expectedPortal): void
    {
        $normalized = $this->normalize($email);

        DB::transaction(function () use ($request, $challengeId, $normalized, $expectedPortal): void {
            /** @var BotRiskChallenge|null $challenge */
            $challenge = BotRiskChallenge::query()->lockForUpdate()->find($challengeId);
            $this->assertChallengeOpen($request, $challenge, $normalized, $expectedPortal);
            if ($challenge->verified_at !== null) {
                throw new AuthenticationException('BOT_STEP_UP_INVALID', 'This verification request is no longer active.', 422);
            }

            if ($challenge->delivery_allowed) {
                $user = User::query()->whereRaw('LOWER(email) = ?', [$normalized])->first();
                $this->otps->issue(
                    $normalized,
                    'BOT_RISK_STEP_UP',
                    $user,
                    (int) config('materyalph.bot_protection.step_up_ttl_minutes', 5),
                    $challenge->getKey(),
                );
            }
            $this->audit->record($request, 'BOT_RISK_CHALLENGE_RESENT', true, safeContext: [
                'portal' => $challenge->portal,
                'action' => $challenge->action,
                'platform' => $challenge->platform,
            ]);
        });
    }

    private function proofFrom(Request $request): ?string
    {
        $cookie = $request->cookie('mp_bot_proof');

        return is_string($cookie) && $cookie !== '' ? $cookie : null;
    }

    private function consumeProof(Request $request, string $proof, string $email, string $portal, string $action, ?string $platform = null): void
    {
        DB::transaction(function () use ($request, $proof, $email, $portal, $action, $platform): void {
            /** @var BotRiskChallenge|null $challenge */
            $challenge = BotRiskChallenge::query()
                ->where('proof_hash', $this->hashProof($proof))
                ->lockForUpdate()
                ->first();

            if ($challenge === null
                || $challenge->consumed_at !== null
                || $challenge->invalidated_at !== null
                || $challenge->proof_expires_at === null
                || $challenge->proof_expires_at->isPast()
                || ! hash_equals($challenge->normalized_email_hash, $this->hashEmail($email))
                || $challenge->portal !== $portal
                || $challenge->action !== $action
                || ($platform !== null && $challenge->platform !== $platform)) {
                throw new AuthenticationException('BOT_STEP_UP_INVALID', 'Verify this request again before continuing.', 422);
            }

            $challenge->forceFill(['consumed_at' => now()])->save();
            $this->audit->record($request, 'BOT_RISK_PROOF_CONSUMED', true, safeContext: [
                'portal' => $portal,
                'action' => $action,
                'platform' => $challenge->platform,
            ]);
        });
    }

    private function requireEmailStepUp(
        Request $request,
        string $email,
        string $portal,
        string $action,
        string $platform,
        string $outcome,
        bool $deliveryAllowed,
        ?User $user,
    ): never {
        $normalized = $this->normalize($email);
        $challenge = DB::transaction(function () use ($normalized, $portal, $action, $platform, $outcome, $deliveryAllowed, $user): BotRiskChallenge {
            BotRiskChallenge::query()
                ->where('normalized_email_hash', $this->hashEmail($normalized))
                ->where('action', $action)
                ->where('platform', $platform)
                ->whereNull('consumed_at')
                ->whereNull('invalidated_at')
                ->update(['invalidated_at' => now()]);

            /** @var BotRiskChallenge $challenge */
            $challenge = BotRiskChallenge::query()->create([
                'normalized_email_hash' => $this->hashEmail($normalized),
                'portal' => $portal,
                'action' => $action,
                'platform' => $platform,
                'outcome' => $outcome,
                'delivery_allowed' => $deliveryAllowed,
                'expires_at' => now()->addMinutes((int) config('materyalph.bot_protection.step_up_ttl_minutes', 5)),
            ]);

            if ($deliveryAllowed) {
                $this->otps->issue(
                    $normalized,
                    'BOT_RISK_STEP_UP',
                    $user,
                    (int) config('materyalph.bot_protection.step_up_ttl_minutes', 5),
                    $challenge->getKey(),
                );
            }

            return $challenge;
        });

        $this->audit->record($request, 'BOT_RISK_CHALLENGE_ISSUED', true, $user, [
            'portal' => $portal,
            'action' => $action,
            'platform' => $platform,
            'outcome' => $outcome,
        ]);
        throw new AuthenticationException(
            'BOT_STEP_UP_REQUIRED',
            'Verify this request with the code sent to your email.',
            403,
            [
                'challenge_id' => $challenge->getKey(),
                'expires_at' => $challenge->expires_at->toIso8601String(),
                'resend_after_seconds' => (int) config('materyalph.auth.otp_resend_seconds', 60),
            ],
        );
    }

    private function assertChallengeOpen(Request $request, ?BotRiskChallenge $challenge, string $normalizedEmail, ?string $expectedPortal = null): void
    {
        if ($challenge !== null && $challenge->expires_at->isPast()) {
            $this->audit->record($request, 'BOT_RISK_CHALLENGE_EXPIRED', false, safeContext: [
                'portal' => $challenge->portal,
                'action' => $challenge->action,
                'platform' => $challenge->platform,
            ]);
        }

        if ($challenge === null
            || ! hash_equals((string) $challenge->normalized_email_hash, $this->hashEmail($normalizedEmail))
            || ($expectedPortal !== null && $challenge->portal !== $expectedPortal)
            || $challenge->invalidated_at !== null
            || $challenge->consumed_at !== null
            || $challenge->expires_at->isPast()) {
            throw new AuthenticationException('BOT_STEP_UP_INVALID', 'This verification request is invalid or expired.', 422);
        }
    }

    /** @return array{string, list<string>} */
    private function providerConfiguration(): array
    {
        $projectId = trim((string) config('services.recaptcha.project_id'));
        $apiKey = trim((string) config('services.recaptcha.api_key'));
        $siteKey = trim((string) config('materyalph.bot_protection.site_keys.WEB'));
        $identity = array_values(array_filter(array_map(
            static fn (mixed $value): string => trim((string) $value),
            (array) config('materyalph.bot_protection.allowed_identities.WEB', []),
        )));
        if ($projectId === '' || $apiKey === '' || $siteKey === '' || $identity === []) {
            throw new AuthenticationException('BOT_PROTECTION_NOT_CONFIGURED', 'Bot protection is not configured for this client.', 503);
        }

        return [$siteKey, array_map('mb_strtolower', $identity)];
    }

    private function action(string $portal, string $operation): string
    {
        $key = $portal.'_'.$operation;

        return match ($key) {
            'BUYER_REGISTER' => 'buyer_register',
            'BUYER_LOGIN' => 'buyer_login',
            'BUYER_PASSWORD_RECOVERY' => 'buyer_password_recovery',
            'VENDOR_REGISTER' => 'vendor_register',
            'VENDOR_LOGIN' => 'vendor_login',
            'VENDOR_PASSWORD_RECOVERY' => 'vendor_password_recovery',
            default => throw new AuthenticationException('BOT_ACTION_INVALID', 'This action cannot use bot protection.', 422),
        };
    }

    private function normalize(string $email): string
    {
        return mb_strtolower(trim($email));
    }

    private function hashEmail(string $email): string
    {
        return hash_hmac('sha256', $this->normalize($email), (string) config('app.key'));
    }

    private function hashProof(string $token): string
    {
        return hash_hmac('sha256', $token, (string) config('app.key'));
    }

    private function newToken(): string
    {
        return rtrim(strtr(base64_encode(random_bytes(32)), '+/', '-_'), '=');
    }
}
