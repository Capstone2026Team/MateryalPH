<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\MfaChallengeService;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TotpService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthSessionResponder;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\MfaCodeRequest;
use App\Http\Requests\Auth\MfaRecoveryRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class MfaController extends Controller
{
    public function status(Request $request, MfaChallengeService $challenges, TotpService $totp): JsonResponse
    {
        $pending = $challenges->resolve($this->challengeToken($request));

        return ApiResponse::success([
            'mfa_required' => true,
            'mfa_enrollment_required' => ! $totp->hasConfirmedFactor($pending->user),
        ]);
    }

    public function enroll(Request $request, MfaChallengeService $challenges, TotpService $totp, AuditRecorder $audit): JsonResponse
    {
        $pending = $challenges->resolve($this->challengeToken($request));
        $enrollment = $totp->startEnrollment($pending->user);
        $audit->record($request, 'MFA_ENROLLMENT_STARTED', true, $pending->user);

        return ApiResponse::success($enrollment);
    }

    public function confirm(
        MfaCodeRequest $request,
        MfaChallengeService $challenges,
        TotpService $totp,
        TokenSessionService $sessions,
        AuthCookieFactory $cookies,
        AuthSessionResponder $responder,
        AuditRecorder $audit,
    ): JsonResponse {
        $token = $this->challengeToken($request);
        $pending = $challenges->resolve($token);
        try {
            $recoveryCodes = $totp->confirm($pending->user, (string) $request->validated('code'));
        } catch (AuthenticationException $exception) {
            if ($exception->errorCode === 'MFA_CODE_INVALID') {
                $challenges->fail($token);
            }

            throw $exception;
        }

        $challenges->consume($token);
        $tokens = $sessions->start($pending->user, $pending->clientKind, $pending->deviceId, $request->ip(), $request->userAgent());
        $audit->record($request, 'MFA_ENROLLMENT_CONFIRMED', true, $pending->user);

        return $responder->respond(
            $pending->user,
            $tokens,
            $pending->clientKind,
            $cookies,
            ['recovery_codes' => $recoveryCodes],
        )->withCookie($cookies->forgetMfaChallenge());
    }

    public function challenge(
        MfaCodeRequest $request,
        MfaChallengeService $challenges,
        TotpService $totp,
        TokenSessionService $sessions,
        AuthCookieFactory $cookies,
        AuthSessionResponder $responder,
        AuditRecorder $audit,
    ): JsonResponse {
        $token = $this->challengeToken($request);
        $pending = $challenges->resolve($token);
        if (! $totp->verify($pending->user, (string) $request->validated('code'))) {
            $audit->record($request, 'MFA_CHALLENGE_FAILED', false, $pending->user);
            $challenges->fail($token);
        }

        $challenges->consume($token);
        $tokens = $sessions->start($pending->user, $pending->clientKind, $pending->deviceId, $request->ip(), $request->userAgent());
        $audit->record($request, 'MFA_CHALLENGE_SUCCEEDED', true, $pending->user);

        return $responder->respond($pending->user, $tokens, $pending->clientKind, $cookies)
            ->withCookie($cookies->forgetMfaChallenge());
    }

    public function recover(
        MfaRecoveryRequest $request,
        MfaChallengeService $challenges,
        TotpService $totp,
        TokenSessionService $sessions,
        AuthCookieFactory $cookies,
        AuthSessionResponder $responder,
        AuditRecorder $audit,
    ): JsonResponse {
        $token = $this->challengeToken($request);
        $pending = $challenges->resolve($token);
        $replacementCodes = $totp->consumeRecoveryCode($pending->user, (string) $request->validated('recovery_code'));
        if ($replacementCodes === null) {
            $audit->record($request, 'MFA_RECOVERY_FAILED', false, $pending->user);
            $challenges->fail($token);
        }

        $challenges->consume($token);
        $tokens = $sessions->start($pending->user, $pending->clientKind, $pending->deviceId, $request->ip(), $request->userAgent());
        $audit->record($request, 'MFA_RECOVERY_SUCCEEDED', true, $pending->user);

        return $responder->respond(
            $pending->user,
            $tokens,
            $pending->clientKind,
            $cookies,
            ['recovery_codes' => $replacementCodes],
        )->withCookie($cookies->forgetMfaChallenge());
    }

    private function challengeToken(Request $request): string
    {
        $token = $request->cookie('mp_mfa_challenge');
        if (! is_string($token) || $token === '') {
            throw new AuthenticationException('MFA_CHALLENGE_INVALID', 'The verification request expired. Sign in again.', 401);
        }

        return $token;
    }
}
