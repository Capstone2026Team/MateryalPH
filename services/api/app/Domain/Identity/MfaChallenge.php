<?php

declare(strict_types=1);

namespace App\Domain\Identity;

final readonly class MfaChallenge
{
    public function __construct(
        public string $token,
        public bool $enrollmentRequired,
        public int $expiresIn,
    ) {}
}
