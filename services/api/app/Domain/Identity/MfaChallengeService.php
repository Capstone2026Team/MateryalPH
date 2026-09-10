<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\TotpFactor;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

final class MfaChallengeService
{
    public function requiredFor(User $user): bool
    {
        if ($user->account_type === 'ADMIN') {
            return true;
        }

        return $user->account_type === 'VENDOR' && DB::table('vendor_memberships')
            ->where('user_id', $user->getKey())
            ->where('status', 'ACTIVE')
            ->whereIn('role', ['OWNER', 'STORE_MANAGER'])
            ->exists();
    }

    public function begin(User $user, string $clientKind, ?string $deviceId): MfaChallenge
    {
        $token = $this->randomToken();
        $expiresIn = (int) config('materyalph.auth.mfa_challenge_ttl_minutes', 5) * 60;
        Cache::put($this->key($token), [
            'user_id' => $user->getKey(),
            'client_kind' => $clientKind,
            'device_id' => $deviceId,
            'attempts' => 0,
            'expires_at' => now()->addSeconds($expiresIn)->getTimestamp(),
        ], now()->addSeconds($expiresIn));

        return new MfaChallenge(
            $token,
            ! TotpFactor::query()
                ->where('user_id', $user->getKey())
                ->whereNotNull('confirmed_at')
                ->whereNull('revoked_at')
                ->exists(),
            $expiresIn,
        );
    }

    public function resolve(string $token): PendingMfaLogin
    {
        $flow = Cache::get($this->key($token));
        if (! is_array($flow) || (int) ($flow['expires_at'] ?? 0) < now()->getTimestamp()) {
            throw new AuthenticationException('MFA_CHALLENGE_INVALID', 'The verification request expired. Sign in again.', 401);
        }
        if ((int) ($flow['attempts'] ?? 0) >= (int) config('materyalph.auth.mfa_challenge_max_attempts', 5)) {
            Cache::forget($this->key($token));
            throw new AuthenticationException('MFA_CHALLENGE_LOCKED', 'Too many verification attempts. Sign in again.', 429);
        }

        $user = User::query()->whereKey($flow['user_id'] ?? null)->first();
        if ($user === null || $user->account_status !== 'ACTIVE' || ! $this->requiredFor($user)) {
            Cache::forget($this->key($token));
            throw new AuthenticationException('MFA_CHALLENGE_INVALID', 'The verification request is no longer valid.', 401);
        }

        return new PendingMfaLogin(
            $user,
            (string) ($flow['client_kind'] ?? 'WEB'),
            is_string($flow['device_id'] ?? null) ? $flow['device_id'] : null,
        );
    }

    public function fail(string $token): never
    {
        $key = $this->key($token);
        $flow = Cache::get($key);
        if (! is_array($flow)) {
            throw new AuthenticationException('MFA_CHALLENGE_INVALID', 'The verification request expired. Sign in again.', 401);
        }

        $flow['attempts'] = (int) ($flow['attempts'] ?? 0) + 1;
        $remaining = max(1, (int) ($flow['expires_at'] ?? 0) - now()->getTimestamp());
        Cache::put($key, $flow, now()->addSeconds($remaining));

        throw new AuthenticationException('MFA_CODE_INVALID', 'The verification code is incorrect.', 401);
    }

    public function consume(string $token): PendingMfaLogin
    {
        $pending = $this->resolve($token);
        Cache::forget($this->key($token));

        return $pending;
    }

    private function key(string $token): string
    {
        return 'mfa-challenge:'.hash_hmac('sha256', $token, (string) config('app.key'));
    }

    private function randomToken(): string
    {
        return rtrim(strtr(base64_encode(random_bytes(32)), '+/', '-_'), '=');
    }
}
