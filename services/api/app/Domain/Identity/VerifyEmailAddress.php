<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use Illuminate\Support\Facades\DB;

final class VerifyEmailAddress
{
    public function __construct(private readonly EmailOtpService $otps) {}

    /** @param list<string> $allowedAccountTypes */
    public function handle(string $email, string $code, array $allowedAccountTypes): User
    {
        return DB::transaction(function () use ($email, $code, $allowedAccountTypes): User {
            $otp = $this->otps->verify($email, 'EMAIL_VERIFICATION', $code);
            $user = User::query()->findOrFail($otp->user_id);
            if (! in_array($user->account_type, $allowedAccountTypes, true)) {
                throw new AuthenticationException('OTP_INVALID_OR_EXPIRED', 'The code is invalid or expired.');
            }
            $user->forceFill([
                'email_verified_at' => now(),
                'account_status' => 'ACTIVE',
            ])->save();

            return $user;
        });
    }
}
