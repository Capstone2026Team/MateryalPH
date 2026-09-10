<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\BotProtectionService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\ResendBotChallengeRequest;
use App\Http\Requests\Auth\VerifyBotChallengeRequest;
use Illuminate\Http\JsonResponse;

final class BotChallengeController extends Controller
{
    public function verify(
        VerifyBotChallengeRequest $request,
        string $challengeId,
        BotProtectionService $botProtection,
        AuthCookieFactory $cookies,
    ): JsonResponse {
        $transport = AuthTransport::fromRequest($request);
        $proof = $botProtection->verifyChallenge(
            $request,
            $challengeId,
            (string) $request->validated('email'),
            (string) $request->validated('code'),
            $transport === AuthTransport::MOBILE ? 'BUYER' : 'VENDOR',
        );
        $data = [
            'verified' => true,
            'expires_in' => $proof->expiresIn,
        ];

        if ($transport === AuthTransport::WEB) {
            return ApiResponse::success($data)->withCookie($cookies->botProof($proof));
        }

        return ApiResponse::success($data + ['step_up_token' => $proof->token]);
    }

    public function resend(
        ResendBotChallengeRequest $request,
        string $challengeId,
        BotProtectionService $botProtection,
    ): JsonResponse {
        $transport = AuthTransport::fromRequest($request);
        $botProtection->resendChallenge(
            $request,
            $challengeId,
            (string) $request->validated('email'),
            $transport === AuthTransport::MOBILE ? 'BUYER' : 'VENDOR',
        );

        return ApiResponse::success(['message' => 'If eligible, a new verification code is being delivered.']);
    }
}
