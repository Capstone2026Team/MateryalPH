<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\RecoveryCode;
use App\Models\TotpFactor;
use App\Models\User;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

final class TotpService
{
    private const ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

    public function hasConfirmedFactor(User $user): bool
    {
        return TotpFactor::query()
            ->where('user_id', $user->getKey())
            ->whereNotNull('confirmed_at')
            ->whereNull('revoked_at')
            ->exists();
    }

    /** @return array{secret: string, provisioning_uri: string} */
    public function startEnrollment(User $user): array
    {
        return DB::transaction(function () use ($user): array {
            User::query()->whereKey($user->getKey())->lockForUpdate()->firstOrFail();

            $factor = TotpFactor::query()
                ->where('user_id', $user->getKey())
                ->first();
            if ($factor?->confirmed_at !== null && $factor->revoked_at === null) {
                throw new AuthenticationException('MFA_ALREADY_ENROLLED', 'An authenticator is already enrolled.', 409);
            }

            if ($factor !== null && $factor->confirmed_at === null && $factor->revoked_at === null) {
                return $this->enrollmentPayload($user, Crypt::decryptString($factor->encrypted_secret));
            }

            $secret = $this->base32Encode(random_bytes(20));
            TotpFactor::query()->updateOrCreate(
                ['user_id' => $user->getKey()],
                [
                    'encrypted_secret' => Crypt::encryptString($secret),
                    'confirmed_at' => null,
                    'last_used_at' => null,
                    'last_used_counter' => null,
                    'revoked_at' => null,
                ],
            );

            return $this->enrollmentPayload($user, $secret);
        });
    }

    /** @return array{secret: string, provisioning_uri: string} */
    private function enrollmentPayload(User $user, string $secret): array
    {
        $label = rawurlencode('MateryalPH:'.$user->email);
        $issuer = rawurlencode('MateryalPH');

        return [
            'secret' => $secret,
            'provisioning_uri' => "otpauth://totp/{$label}?secret={$secret}&issuer={$issuer}&algorithm=SHA1&digits=6&period=30",
        ];
    }

    /** @return list<string> */
    public function confirm(User $user, string $code): array
    {
        return DB::transaction(function () use ($user, $code): array {
            $factor = TotpFactor::query()
                ->where('user_id', $user->getKey())
                ->whereNull('confirmed_at')
                ->whereNull('revoked_at')
                ->lockForUpdate()
                ->first();
            if ($factor === null) {
                throw new AuthenticationException('MFA_ENROLLMENT_NOT_STARTED', 'Start authenticator enrollment again.', 409);
            }

            $counter = $this->matchingCounter(Crypt::decryptString($factor->encrypted_secret), $code);
            if ($counter === null) {
                throw new AuthenticationException('MFA_CODE_INVALID', 'The verification code is incorrect.', 401);
            }
            $factor->update([
                'confirmed_at' => now(),
                'last_used_at' => now(),
                'last_used_counter' => $counter,
            ]);

            return $this->replaceRecoveryCodes($user);
        });
    }

    public function verify(User $user, string $code): bool
    {
        return DB::transaction(function () use ($user, $code): bool {
            $factor = TotpFactor::query()
                ->where('user_id', $user->getKey())
                ->whereNotNull('confirmed_at')
                ->whereNull('revoked_at')
                ->lockForUpdate()
                ->first();
            if ($factor === null) {
                return false;
            }

            $counter = $this->matchingCounter(Crypt::decryptString($factor->encrypted_secret), $code);
            if ($counter === null || ($factor->last_used_counter !== null && $counter <= $factor->last_used_counter)) {
                return false;
            }

            $factor->update(['last_used_at' => now(), 'last_used_counter' => $counter]);

            return true;
        });
    }

    /** @return list<string>|null */
    public function consumeRecoveryCode(User $user, string $plainCode): ?array
    {
        return DB::transaction(function () use ($user, $plainCode): ?array {
            $hash = $this->recoveryHash($plainCode);
            $record = RecoveryCode::query()
                ->where('user_id', $user->getKey())
                ->where('code_hash', $hash)
                ->whereNull('used_at')
                ->lockForUpdate()
                ->first();
            if ($record === null) {
                return null;
            }

            RecoveryCode::query()
                ->where('user_id', $user->getKey())
                ->whereNull('used_at')
                ->update(['used_at' => now(), 'updated_at' => now()]);

            return $this->replaceRecoveryCodes($user);
        });
    }

    /** @return list<string> */
    private function replaceRecoveryCodes(User $user): array
    {
        RecoveryCode::query()
            ->where('user_id', $user->getKey())
            ->whereNull('used_at')
            ->update(['used_at' => now(), 'updated_at' => now()]);

        $plainCodes = [];
        for ($index = 0; $index < 8; $index++) {
            $raw = substr($this->base32Encode(random_bytes(8)), 0, 12);
            $plain = implode('-', str_split($raw, 4));
            RecoveryCode::query()->create([
                'user_id' => $user->getKey(),
                'code_hash' => $this->recoveryHash($plain),
            ]);
            $plainCodes[] = $plain;
        }

        return $plainCodes;
    }

    private function matchingCounter(string $secret, string $code): ?int
    {
        if (! preg_match('/^\d{6}$/', $code)) {
            return null;
        }

        $current = intdiv(time(), 30);
        foreach ([-1, 0, 1] as $offset) {
            $counter = $current + $offset;
            if (hash_equals($this->codeAt($secret, $counter), $code)) {
                return $counter;
            }
        }

        return null;
    }

    private function codeAt(string $secret, int $counter): string
    {
        $binarySecret = $this->base32Decode($secret);
        $hash = hash_hmac('sha1', pack('N2', 0, $counter), $binarySecret, true);
        $offset = ord($hash[19]) & 0x0F;
        $value = ((ord($hash[$offset]) & 0x7F) << 24)
            | ((ord($hash[$offset + 1]) & 0xFF) << 16)
            | ((ord($hash[$offset + 2]) & 0xFF) << 8)
            | (ord($hash[$offset + 3]) & 0xFF);

        return str_pad((string) ($value % 1_000_000), 6, '0', STR_PAD_LEFT);
    }

    private function recoveryHash(string $plain): string
    {
        $normalized = strtoupper(str_replace(['-', ' '], '', trim($plain)));

        return hash_hmac('sha256', $normalized, (string) config('app.key'));
    }

    private function base32Encode(string $value): string
    {
        $buffer = 0;
        $bits = 0;
        $encoded = '';
        foreach (unpack('C*', $value) ?: [] as $byte) {
            $buffer = ($buffer << 8) | $byte;
            $bits += 8;
            while ($bits >= 5) {
                $bits -= 5;
                $encoded .= self::ALPHABET[($buffer >> $bits) & 31];
            }
        }
        if ($bits > 0) {
            $encoded .= self::ALPHABET[($buffer << (5 - $bits)) & 31];
        }

        return $encoded;
    }

    private function base32Decode(string $value): string
    {
        $buffer = 0;
        $bits = 0;
        $decoded = '';
        foreach (str_split(strtoupper(rtrim($value, '='))) as $character) {
            $position = strpos(self::ALPHABET, $character);
            if ($position === false) {
                throw new AuthenticationException('MFA_SECRET_INVALID', 'The authenticator factor is invalid.', 500);
            }
            $buffer = ($buffer << 5) | $position;
            $bits += 5;
            if ($bits >= 8) {
                $bits -= 8;
                $decoded .= chr(($buffer >> $bits) & 0xFF);
            }
        }

        return $decoded;
    }
}
