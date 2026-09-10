<?php

declare(strict_types=1);

namespace App\Models;

use Carbon\CarbonImmutable;

/**
 * @property string $normalized_email_hash
 * @property string $portal
 * @property string $action
 * @property string $platform
 * @property bool $delivery_allowed
 * @property CarbonImmutable $expires_at
 * @property CarbonImmutable|null $verified_at
 * @property CarbonImmutable|null $proof_expires_at
 * @property CarbonImmutable|null $consumed_at
 * @property CarbonImmutable|null $invalidated_at
 */
final class BotRiskChallenge extends UuidModel
{
    protected function casts(): array
    {
        return [
            'delivery_allowed' => 'boolean',
            'expires_at' => 'immutable_datetime',
            'verified_at' => 'immutable_datetime',
            'proof_expires_at' => 'immutable_datetime',
            'consumed_at' => 'immutable_datetime',
            'invalidated_at' => 'immutable_datetime',
        ];
    }
}
