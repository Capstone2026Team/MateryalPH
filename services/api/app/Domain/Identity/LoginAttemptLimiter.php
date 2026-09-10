<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;

final class LoginAttemptLimiter
{
    private const MAX_ATTEMPTS = 5;

    private const DECAY_SECONDS = 900;

    public function ensureAllowed(Request $request, string $email): void
    {
        $key = $this->key($request, $email);
        if (! RateLimiter::tooManyAttempts($key, self::MAX_ATTEMPTS)) {
            return;
        }

        throw new AuthenticationException(
            'LOGIN_THROTTLED',
            'Too many failed sign-in attempts. Try again later.',
            429,
            ['retry_after_seconds' => RateLimiter::availableIn($key)],
        );
    }

    public function recordFailure(Request $request, string $email): void
    {
        RateLimiter::hit($this->key($request, $email), self::DECAY_SECONDS);
    }

    public function clear(Request $request, string $email): void
    {
        RateLimiter::clear($this->key($request, $email));
    }

    private function key(Request $request, string $email): string
    {
        $normalized = mb_strtolower(trim($email));
        $emailHash = hash_hmac('sha256', $normalized, (string) config('app.key'));

        return 'login|'.($request->ip() ?? 'unknown').'|'.$emailHash;
    }
}
