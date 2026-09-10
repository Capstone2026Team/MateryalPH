<?php

declare(strict_types=1);

namespace App\Models;

final class LoginEvent extends UuidModel
{
    protected function casts(): array
    {
        return ['safe_context' => 'array', 'succeeded' => 'boolean'];
    }
}
