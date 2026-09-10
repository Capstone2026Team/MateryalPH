<?php

declare(strict_types=1);

namespace App\Models;

/**
 * @property string $auth_session_id
 */
final class AuthRefreshTokenHistory extends UuidModel
{
    protected $table = 'auth_refresh_token_history';

    protected $hidden = ['token_hash'];

    protected function casts(): array
    {
        return [
            'rotated_at' => 'immutable_datetime',
            'reuse_detected_at' => 'immutable_datetime',
        ];
    }
}
