<?php

declare(strict_types=1);

namespace App\Domain\Identity;

final readonly class BotProofResult
{
    public function __construct(
        public string $token,
        public int $expiresIn,
        public string $platform,
    ) {}
}
