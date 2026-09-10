<?php

namespace App\Models;

use App\Models\Concerns\HasUuidV7;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\Contracts\OAuthenticatable;
use Laravel\Passport\HasApiTokens;

/**
 * @property string $public_id
 * @property string $name
 * @property string $email
 * @property string $account_type
 * @property string $account_status
 */
class User extends Authenticatable implements OAuthenticatable
{
    use HasApiTokens, HasUuidV7, Notifiable;

    /** @use HasFactory<UserFactory> */
    use HasFactory;

    public const UPDATED_AT = 'updated_at';

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'public_id',
        'account_type',
        'account_status',
        'last_authenticated_at',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'last_authenticated_at' => 'immutable_datetime',
        ];
    }
}
