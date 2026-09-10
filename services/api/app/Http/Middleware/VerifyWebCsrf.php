<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use App\Http\ApiResponse;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

final class VerifyWebCsrf
{
    public function handle(Request $request, Closure $next): Response
    {
        $cookie = $request->cookie('mp_csrf');
        $header = $request->header('X-CSRF-Token');
        if (! is_string($cookie) || ! is_string($header) || ! hash_equals($cookie, $header)) {
            return ApiResponse::error('CSRF_TOKEN_MISMATCH', 'Refresh the page and try again.', 419);
        }

        return $next($request);
    }
}
