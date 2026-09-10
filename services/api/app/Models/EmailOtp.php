<?php

declare(strict_types=1);

namespace App\Models;

use Carbon\CarbonImmutable;

/**
 * @property string $user_id
 * @property string $code_hash
 * @property int $attempts
 * @property int $max_attempts
 * @property CarbonImmutable $expires_at
 * @property CarbonImmutable $created_at
 */
final class EmailOtp extends UuidModel
{
    protected function casts(): array
    {
        return [
            'expires_at' => 'immutable_datetime',
            'consumed_at' => 'immutable_datetime',
            'invalidated_at' => 'immutable_datetime',
        ];
    }
}
