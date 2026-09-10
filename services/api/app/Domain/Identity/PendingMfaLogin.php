<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;

final readonly class PendingMfaLogin
{
    public function __construct(
        public User $user,
        public string $clientKind,
        public ?string $deviceId,
    ) {}
}
