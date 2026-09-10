<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\TokenSessionService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\RefreshRequest;
use Illuminate\Http\JsonResponse;

final class RefreshController extends Controller
{
    public function __invoke(RefreshRequest $request, TokenSessionService $sessions, AuthCookieFactory $cookies): JsonResponse
    {
        $transport = AuthTransport::fromRequest($request);
        $refresh = $transport === AuthTransport::MOBILE
            ? (string) $request->validated('refresh_token')
            : (string) $request->cookie('mp_refresh');

        $tokens = $sessions->rotate($refresh, $request->ip(), $request->userAgent());
        if ($transport === AuthTransport::MOBILE) {
            return ApiResponse::success([
                'access_token' => $tokens->accessToken,
                'refresh_token' => $tokens->refreshToken,
                'session_id' => $tokens->sessionId,
                'access_expires_in' => $tokens->accessExpiresIn,
                'refresh_expires_in' => $tokens->refreshExpiresIn,
            ]);
        }

        return ApiResponse::success([
            'session_id' => $tokens->sessionId,
            'access_expires_in' => $tokens->accessExpiresIn,
        ])->withCookie($cookies->access($tokens))->withCookie($cookies->refresh($tokens));
    }
}
