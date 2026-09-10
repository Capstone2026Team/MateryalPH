<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Laravel\Passport\Token;

final class PassportAccessTokenIssuer implements AccessTokenIssuer
{
    public function issue(User $user, string $clientKind): IssuedAccessToken
    {
        $result = $user->createToken('materyalph-'.$clientKind, [$user->account_type]);

        return new IssuedAccessToken($result->accessToken, (string) $result->accessTokenId);
    }

    public function revoke(?string $identifier): void
    {
        if ($identifier !== null) {
            Token::query()->whereKey($identifier)->first()?->revoke();
        }
    }
}
