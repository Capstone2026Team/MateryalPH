<?php

declare(strict_types=1);

namespace App\Http;

use App\Domain\Identity\AuthTokenPair;
use App\Domain\Identity\BotProofResult;
use App\Domain\Identity\MfaChallenge;
use Symfony\Component\HttpFoundation\Cookie;

final class AuthCookieFactory
{
    public function access(AuthTokenPair $tokens): Cookie
    {
        return $this->make('mp_access', $tokens->accessToken, $tokens->accessExpiresIn, true);
    }

    public function refresh(AuthTokenPair $tokens): Cookie
    {
        return $this->make('mp_refresh', $tokens->refreshToken, $tokens->refreshExpiresIn, true, '/api/v1/auth');
    }

    public function csrf(string $token): Cookie
    {
        return $this->make('mp_csrf', $token, 7200, false);
    }

    public function mfaChallenge(MfaChallenge $challenge): Cookie
    {
        return $this->make('mp_mfa_challenge', $challenge->token, $challenge->expiresIn, true, '/api/v1/auth/mfa');
    }

    public function forgetMfaChallenge(): Cookie
    {
        return $this->forget('mp_mfa_challenge', '/api/v1/auth/mfa');
    }

    public function botProof(BotProofResult $proof): Cookie
    {
        return $this->make('mp_bot_proof', $proof->token, $proof->expiresIn, true, '/api/v1/auth');
    }

    public function forgetBotProof(): Cookie
    {
        return $this->forget('mp_bot_proof', '/api/v1/auth');
    }

    public function forget(string $name, string $path = '/'): Cookie
    {
        return Cookie::create($name, '', 1, $path, config('materyalph.auth.cookie_domain'), $this->secure(), true, false, $this->sameSite());
    }

    private function make(string $name, string $value, int $seconds, bool $httpOnly, string $path = '/'): Cookie
    {
        return Cookie::create(
            $name,
            $value,
            time() + $seconds,
            $path,
            config('materyalph.auth.cookie_domain'),
            $this->secure(),
            $httpOnly,
            false,
            $this->sameSite(),
        );
    }

    private function secure(): bool
    {
        return (bool) config('materyalph.auth.cookie_secure', true);
    }

    private function sameSite(): string
    {
        return (string) config('materyalph.auth.cookie_same_site', 'lax');
    }
}
