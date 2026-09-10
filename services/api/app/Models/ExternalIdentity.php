<?php

declare(strict_types=1);

namespace App\Models;

/**
 * @property string $user_id
 */
final class ExternalIdentity extends UuidModel
{
    protected function casts(): array
    {
        return ['linked_at' => 'immutable_datetime'];
    }
}
