<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticateAccount;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\BotProtectionService;
use App\Domain\Identity\LoginAttemptLimiter;
use App\Domain\Identity\MfaChallengeService;
use App\Domain\Identity\TokenSessionService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthSessionResponder;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\JsonResponse;

final class LoginController extends Controller
{
    public function __invoke(
        LoginRequest $request,
        AuthenticateAccount $authenticate,
        LoginAttemptLimiter $attempts,
        BotProtectionService $botProtection,
        TokenSessionService $sessions,
        MfaChallengeService $mfa,
        AuthCookieFactory $cookies,
        AuthSessionResponder $responder,
        AuditRecorder $audit,
    ): JsonResponse {
        $input = $request->validated();
        $email = (string) $input['email'];
        $transport = AuthTransport::fromRequest($request);
        $portal = $transport === AuthTransport::MOBILE ? 'BUYER' : (string) $input['portal'];
        $clientKind = $transport->value;
        try {
            $attempts->ensureAllowed($request, $email);
            $user = $authenticate->handle($email, (string) $input['password'], $portal);
        } catch (AuthenticationException $exception) {
            if ($exception->errorCode === 'INVALID_CREDENTIALS') {
                $attempts->recordFailure($request, $email);
            }
            $audit->record($request, $exception->errorCode === 'LOGIN_THROTTLED' ? 'LOGIN_THROTTLED' : 'LOGIN_FAILED', false, safeContext: [
                'email' => $email,
                'portal' => $portal,
            ]);
            throw $exception;
        }

        $usedProof = $botProtection->guard(
            $request,
            $email,
            $portal,
            'LOGIN',
            $input['bot_protection'] ?? null,
            $input['risk_proof_token'] ?? null,
            true,
            $user,
        );
        $attempts->clear($request, $email);
        $authenticate->markAuthenticated($user);
        if ($mfa->requiredFor($user)) {
            $challenge = $mfa->begin($user, $clientKind, $input['device_id'] ?? null);
            $audit->record($request, 'MFA_CHALLENGE_REQUIRED', true, $user, ['client_kind' => $clientKind]);

            $response = ApiResponse::success([
                'mfa_required' => true,
                'mfa_enrollment_required' => $challenge->enrollmentRequired,
                'challenge_expires_in' => $challenge->expiresIn,
            ])->withCookie($cookies->mfaChallenge($challenge));

            return $usedProof && $transport === AuthTransport::WEB
                ? $response->withCookie($cookies->forgetBotProof())
                : $response;
        }

        $tokens = $sessions->start($user, $clientKind, $input['device_id'] ?? null, $request->ip(), $request->userAgent());
        $audit->record($request, 'LOGIN_SUCCEEDED', true, $user, ['client_kind' => $clientKind]);

        $response = $responder->respond($user, $tokens, $clientKind, $cookies);

        return $usedProof && $transport === AuthTransport::WEB
            ? $response->withCookie($cookies->forgetBotProof())
            : $response;
    }
}
