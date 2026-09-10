<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;

interface AccessTokenIssuer
{
    public function issue(User $user, string $clientKind): IssuedAccessToken;

    public function revoke(?string $identifier): void;
}
