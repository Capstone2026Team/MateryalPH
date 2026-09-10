<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\TokenSessionService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Models\AuthSession;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Laravel\Passport\AccessToken;

final class LogoutController extends Controller
{
    public function __invoke(Request $request, TokenSessionService $sessions, AuthCookieFactory $cookies, AuditRecorder $audit): JsonResponse
    {
        $token = $request->user()?->currentAccessToken();
        $tokenId = $token instanceof AccessToken ? $token->oauth_access_token_id : null;
        $session = AuthSession::query()->where('oauth_access_token_id', $tokenId)->first();
        if ($session !== null) {
            $sessions->revoke($session);
        } elseif ($token instanceof AccessToken) {
            $token->revoke();
        }
        $audit->record($request, 'LOGOUT', true, $request->user());

        $response = ApiResponse::success(['logged_out' => true]);
        if (AuthTransport::fromRequest($request) === AuthTransport::MOBILE) {
            return $response;
        }

        return $response->withCookie($cookies->forget('mp_access'))
            ->withCookie($cookies->forget('mp_refresh', '/api/v1/auth'));
    }
}
