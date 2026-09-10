<?php

declare(strict_types=1);

namespace App\Models;

use Carbon\CarbonImmutable;

/**
 * @property string $user_id
 * @property string $code_hash
 * @property CarbonImmutable|null $used_at
 */
final class RecoveryCode extends UuidModel
{
    protected $hidden = ['code_hash'];

    protected function casts(): array
    {
        return ['used_at' => 'immutable_datetime'];
    }
}
