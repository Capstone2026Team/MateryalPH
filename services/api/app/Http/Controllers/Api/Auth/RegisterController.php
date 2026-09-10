<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\BotProtectionService;
use App\Domain\Identity\RegisterAccount;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\RegisterRequest;
use Illuminate\Http\JsonResponse;

final class RegisterController extends Controller
{
    public function __invoke(
        RegisterRequest $request,
        RegisterAccount $register,
        BotProtectionService $botProtection,
        AuthCookieFactory $cookies,
        AuditRecorder $audit,
    ): JsonResponse {
        $input = $request->validated();
        $transport = AuthTransport::fromRequest($request);
        $portal = $transport === AuthTransport::MOBILE ? 'BUYER' : 'VENDOR';
        $input['account_type'] = $portal;
        $register->assertEmailAvailable((string) $input['email']);
        $usedProof = $botProtection->guard(
            $request,
            (string) $input['email'],
            $portal,
            'REGISTER',
            $input['bot_protection'] ?? null,
            $input['risk_proof_token'] ?? null,
            true,
        );
        $user = $register->handle($input);
        $audit->record($request, 'ACCOUNT_REGISTERED', true, $user);

        $response = ApiResponse::success([
            'user_id' => $user->public_id,
            'email' => $user->email,
            'account_type' => $user->account_type,
            'verification_required' => true,
        ], status: 201);

        return $usedProof && $transport === AuthTransport::WEB
            ? $response->withCookie($cookies->forgetBotProof())
            : $response;
    }
}
