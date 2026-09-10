<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Operations\OutboxPublisher;
use App\Models\EmailOtp;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class EmailOtpService
{
    public function __construct(
        private readonly OtpCodeGenerator $codes,
        private readonly OutboxPublisher $outbox,
    ) {}

    public function issue(
        string $email,
        string $purpose,
        ?User $user,
        ?int $ttlMinutes = null,
        ?string $botRiskChallengeId = null,
    ): EmailOtp {
        $normalizedEmail = $this->normalize($email);

        return DB::transaction(function () use ($normalizedEmail, $purpose, $user, $ttlMinutes, $botRiskChallengeId): EmailOtp {
            $latest = EmailOtp::query()
                ->where('normalized_email', $normalizedEmail)
                ->where('purpose', $purpose)
                ->latest('created_at')
                ->lockForUpdate()
                ->first();

            $resendSeconds = (int) config('materyalph.auth.otp_resend_seconds', 60);
            if ($latest !== null && $latest->created_at->addSeconds($resendSeconds)->isFuture()) {
                throw new AuthenticationException('OTP_RESEND_THROTTLED', 'Please wait before requesting another code.', 429);
            }

            $code = $this->codes->sixDigits();
            $ttl = $ttlMinutes ?? (int) config('materyalph.auth.otp_ttl_minutes', 10);
            EmailOtp::query()
                ->where('normalized_email', $normalizedEmail)
                ->where('purpose', $purpose)
                ->whereNull('consumed_at')
                ->whereNull('invalidated_at')
                ->update(['invalidated_at' => now()]);

            $otp = EmailOtp::query()->create([
                'user_id' => $user?->getKey(),
                'bot_risk_challenge_id' => $botRiskChallengeId,
                'normalized_email' => $normalizedEmail,
                'purpose' => $purpose,
                'code_hash' => $this->hash($normalizedEmail, $purpose, $code),
                'attempts' => 0,
                'max_attempts' => (int) config('materyalph.auth.otp_max_attempts', 5),
                'expires_at' => now()->addMinutes($ttl),
            ]);

            $this->outbox->publish('AUTH_EMAIL_OTP_REQUESTED', 'EMAIL_OTP', (string) $otp->getKey(), [
                'recipient' => $normalizedEmail,
                'code' => $code,
                'purpose' => $purpose,
                'ttl_minutes' => $ttl,
            ]);

            return $otp;
        });
    }

    public function verify(string $email, string $purpose, string $code): EmailOtp
    {
        return $this->verifyMatching($email, $purpose, $code, null);
    }

    public function verifyForBotRiskChallenge(string $email, string $code, string $challengeId): EmailOtp
    {
        return $this->verifyMatching($email, 'BOT_RISK_STEP_UP', $code, $challengeId);
    }

    private function verifyMatching(string $email, string $purpose, string $code, ?string $challengeId): EmailOtp
    {
        $normalizedEmail = $this->normalize($email);

        $result = DB::transaction(function () use ($normalizedEmail, $purpose, $code, $challengeId): EmailOtp|string {
            $query = EmailOtp::query()
                ->where('normalized_email', $normalizedEmail)
                ->where('purpose', $purpose)
                ->whereNull('consumed_at')
                ->whereNull('invalidated_at');
            if ($challengeId !== null) {
                $query->where('bot_risk_challenge_id', $challengeId);
            }
            $otp = $query
                ->latest('created_at')
                ->lockForUpdate()
                ->first();

            if ($otp === null || $otp->expires_at->isPast()) {
                return 'OTP_INVALID_OR_EXPIRED';
            }

            if ($otp->attempts >= $otp->max_attempts) {
                $otp->update(['invalidated_at' => now()]);

                return 'OTP_ATTEMPTS_EXHAUSTED';
            }

            if (! hash_equals($otp->code_hash, $this->hash($normalizedEmail, $purpose, $code))) {
                $attempts = $otp->attempts + 1;
                $otp->update([
                    'attempts' => $attempts,
                    'invalidated_at' => $attempts >= $otp->max_attempts ? now() : null,
                ]);

                return $attempts >= $otp->max_attempts
                    ? 'OTP_ATTEMPTS_EXHAUSTED'
                    : 'OTP_INVALID_OR_EXPIRED';
            }

            $otp->update(['consumed_at' => now()]);

            return $otp->refresh();
        });

        if ($result === 'OTP_ATTEMPTS_EXHAUSTED') {
            throw new AuthenticationException('OTP_ATTEMPTS_EXHAUSTED', 'Request a new verification code.', 429);
        }
        if ($result === 'OTP_INVALID_OR_EXPIRED') {
            throw new AuthenticationException('OTP_INVALID_OR_EXPIRED', 'The code is invalid or expired.');
        }

        return $result;
    }

    private function hash(string $email, string $purpose, string $code): string
    {
        return hash_hmac('sha256', $email.'|'.$purpose.'|'.$code, (string) config('app.key'));
    }

    private function normalize(string $email): string
    {
        return mb_strtolower(trim($email));
    }
}
