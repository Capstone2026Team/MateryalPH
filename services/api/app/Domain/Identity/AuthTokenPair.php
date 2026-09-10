<?php

declare(strict_types=1);

namespace App\Domain\Identity;

final readonly class AuthTokenPair
{
    public function __construct(
        public string $accessToken,
        public string $refreshToken,
        public string $sessionId,
        public int $accessExpiresIn,
        public int $refreshExpiresIn,
    ) {}
}
