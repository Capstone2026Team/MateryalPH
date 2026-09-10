<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use App\Http\AuthTransport;
use Closure;
use Illuminate\Http\Request;
use LogicException;
use Symfony\Component\HttpFoundation\Response;

final class SetAuthTransport
{
    public function handle(Request $request, Closure $next, string $transport): Response
    {
        $resolved = AuthTransport::tryFrom(strtoupper($transport));
        if ($resolved === null) {
            throw new LogicException('The configured authentication transport is invalid.');
        }

        $request->attributes->set(AuthTransport::ATTRIBUTE, $resolved);

        return $next($request);
    }
}
