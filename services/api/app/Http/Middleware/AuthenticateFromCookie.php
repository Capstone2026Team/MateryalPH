<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

final class AuthenticateFromCookie
{
    public function handle(Request $request, Closure $next): Response
    {
        if (! $request->headers->has('Authorization') && $request->cookies->has('mp_access')) {
            $request->headers->set('Authorization', 'Bearer '.$request->cookie('mp_access'));
        }

        return $next($request);
    }
}
