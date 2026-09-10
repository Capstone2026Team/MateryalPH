<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\AuthSession;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

final class ResetPassword
{
    public function __construct(private readonly EmailOtpService $otps, private readonly AccessTokenIssuer $accessTokens) {}

    /** @param list<string> $allowedAccountTypes */
    public function handle(string $email, string $code, string $password, array $allowedAccountTypes): void
    {
        DB::transaction(function () use ($email, $code, $password, $allowedAccountTypes): void {
            $this->otps->verify($email, 'PASSWORD_RESET', $code);
            $user = User::query()->whereRaw('LOWER(email) = ?', [mb_strtolower(trim($email))])->first();
            if ($user === null || ! in_array($user->account_type, $allowedAccountTypes, true)) {
                throw new AuthenticationException('OTP_INVALID_OR_EXPIRED', 'The code is invalid or expired.');
            }
            $user->forceFill(['password' => Hash::make($password)])->save();
            AuthSession::query()->where('user_id', $user->getKey())->whereNull('revoked_at')->each(function (AuthSession $session): void {
                $this->accessTokens->revoke($session->oauth_access_token_id);
                $session->update(['revoked_at' => now(), 'revoke_reason' => 'PASSWORD_RESET']);
            });
        });
    }
}
