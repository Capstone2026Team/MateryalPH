<?php

declare(strict_types=1);

namespace App\Domain\Identity;

final readonly class IssuedAccessToken
{
    public function __construct(public string $plainText, public string $identifier) {}
}
