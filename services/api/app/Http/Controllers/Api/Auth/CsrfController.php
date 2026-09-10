<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

final class CsrfController extends Controller
{
    public function __invoke(AuthCookieFactory $cookies): JsonResponse
    {
        $token = rtrim(strtr(base64_encode(random_bytes(32)), '+/', '-_'), '=');

        return ApiResponse::success(['csrf_token' => $token])->withCookie($cookies->csrf($token));
    }
}
