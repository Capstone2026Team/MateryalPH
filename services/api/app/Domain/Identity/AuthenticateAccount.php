<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Illuminate\Support\Facades\Hash;

final class AuthenticateAccount
{
    public function handle(string $email, string $password, string $requestedPortal): User
    {
        $user = User::query()->whereRaw('LOWER(email) = ?', [mb_strtolower(trim($email))])->first();

        if ($user === null || ! Hash::check($password, $user->password)) {
            throw new AuthenticationException('INVALID_CREDENTIALS', 'The email or password is incorrect.', 401);
        }
        if ($user->account_status !== 'ACTIVE') {
            throw new AuthenticationException('ACCOUNT_NOT_ACTIVE', 'Verify your account or contact support before signing in.', 403);
        }
        if ($user->account_type !== $requestedPortal) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot sign in to the selected portal.', 403);
        }

        return $user;
    }

    public function markAuthenticated(User $user): void
    {
        $user->forceFill(['last_authenticated_at' => now()])->save();
    }
}
