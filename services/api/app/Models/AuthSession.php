<?php

declare(strict_types=1);

namespace App\Models;

use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property string $family_id
 * @property string $refresh_token_hash
 * @property string|null $oauth_access_token_id
 * @property string $client_kind
 * @property CarbonImmutable $expires_at
 * @property CarbonImmutable|null $revoked_at
 * @property-read User $user
 */
final class AuthSession extends UuidModel
{
    protected $hidden = ['refresh_token_hash', 'previous_refresh_token_hash'];

    protected function casts(): array
    {
        return [
            'last_used_at' => 'immutable_datetime',
            'expires_at' => 'immutable_datetime',
            'revoked_at' => 'immutable_datetime',
        ];
    }

    /** @return BelongsTo<User, $this> */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
