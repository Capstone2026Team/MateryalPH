<?php

declare(strict_types=1);

namespace App\Http;

use App\Domain\Identity\AuthTokenPair;
use App\Models\User;
use Illuminate\Http\JsonResponse;

final class AuthSessionResponder
{
    /** @param array<string, mixed> $extra */
    public function respond(
        User $user,
        AuthTokenPair $tokens,
        string $clientKind,
        AuthCookieFactory $cookies,
        array $extra = [],
    ): JsonResponse {
        $data = array_merge([
            'user' => [
                'id' => $user->public_id,
                'name' => $user->name,
                'email' => $user->email,
                'account_type' => $user->account_type,
            ],
            'session_id' => $tokens->sessionId,
            'access_expires_in' => $tokens->accessExpiresIn,
            'mfa_setup_required' => false,
        ], $extra);

        if ($clientKind === 'MOBILE') {
            $data['access_token'] = $tokens->accessToken;
            $data['refresh_token'] = $tokens->refreshToken;
            $data['refresh_expires_in'] = $tokens->refreshExpiresIn;

            return ApiResponse::success($data);
        }

        return ApiResponse::success($data)
            ->withCookie($cookies->access($tokens))
            ->withCookie($cookies->refresh($tokens));
    }
}
