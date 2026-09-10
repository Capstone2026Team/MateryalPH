<?php

declare(strict_types=1);

namespace App\Models;

use Carbon\CarbonImmutable;

/**
 * @property string $user_id
 * @property string $encrypted_secret
 * @property CarbonImmutable|null $confirmed_at
 * @property CarbonImmutable|null $revoked_at
 * @property int|null $last_used_counter
 */
final class TotpFactor extends UuidModel
{
    protected function casts(): array
    {
        return [
            'confirmed_at' => 'immutable_datetime',
            'last_used_at' => 'immutable_datetime',
            'revoked_at' => 'immutable_datetime',
            'last_used_counter' => 'integer',
        ];
    }
}
