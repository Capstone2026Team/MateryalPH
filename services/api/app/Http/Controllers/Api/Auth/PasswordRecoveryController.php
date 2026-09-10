<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\BotProtectionService;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Identity\ResetPassword;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\PasswordRecoveryRequest;
use App\Http\Requests\Auth\PasswordResetRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;

final class PasswordRecoveryController extends Controller
{
    public function request(
        PasswordRecoveryRequest $request,
        EmailOtpService $otps,
        BotProtectionService $botProtection,
        AuthCookieFactory $cookies,
        AuditRecorder $audit,
    ): JsonResponse {
        $validated = $request->validated();
        $email = mb_strtolower(trim((string) $validated['email']));
        $transport = AuthTransport::fromRequest($request);
        $portal = $transport === AuthTransport::MOBILE ? 'BUYER' : (string) $validated['portal'];
        $user = User::query()
            ->whereRaw('LOWER(email) = ?', [$email])
            ->where('account_type', $portal)
            ->first();

        $usedProof = false;
        if (in_array($portal, ['BUYER', 'VENDOR'], true)) {
            $usedProof = $botProtection->guard(
                $request,
                $email,
                $portal,
                'PASSWORD_RECOVERY',
                $validated['bot_protection'] ?? null,
                $validated['risk_proof_token'] ?? null,
                $user !== null,
                $user,
            );
        }

        if ($user !== null) {
            $otps->issue($user->email, 'PASSWORD_RESET', $user);
        }

        $audit->record($request, 'PASSWORD_RECOVERY_REQUESTED', true, $user, [
            'email' => $email,
            'portal' => $portal,
        ]);

        $response = ApiResponse::success(['message' => 'If the account exists, a recovery code is being delivered.']);

        return $usedProof && $transport === AuthTransport::WEB
            ? $response->withCookie($cookies->forgetBotProof())
            : $response;
    }

    public function reset(PasswordResetRequest $request, ResetPassword $reset): JsonResponse
    {
        $transport = AuthTransport::fromRequest($request);
        $reset->handle(
            (string) $request->validated('email'),
            (string) $request->validated('code'),
            (string) $request->validated('password'),
            $transport === AuthTransport::MOBILE ? ['BUYER'] : ['VENDOR', 'ADMIN'],
        );

        return ApiResponse::success(['password_reset' => true, 'next' => 'SIGN_IN']);
    }
}
