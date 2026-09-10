<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TotpService;
use App\Models\RecoveryCode;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

final class TotpRecoveryTest extends TestCase
{
    use RefreshDatabase;

    public function test_repeated_enrollment_start_reuses_only_the_unconfirmed_factor(): void
    {
        $vendor = User::factory()->create(['account_type' => 'VENDOR']);
        $service = app(TotpService::class);

        $first = $service->startEnrollment($vendor);
        $second = $service->startEnrollment($vendor);

        self::assertSame($first, $second);
        $this->assertDatabaseCount('totp_factors', 1);
        self::assertFalse(
            $service->verify($vendor, $this->totpCode($first['secret'], intdiv(time(), 30))),
            'An unconfirmed authenticator must not satisfy a normal TOTP challenge.',
        );

        $service->confirm($vendor, $this->totpCode($first['secret'], intdiv(time(), 30)));

        try {
            $service->startEnrollment($vendor);
            self::fail('A confirmed authenticator secret must never be returned as a pending enrollment.');
        } catch (AuthenticationException $exception) {
            self::assertSame('MFA_ALREADY_ENROLLED', $exception->errorCode);
        }
    }

    public function test_totp_replay_is_rejected_and_recovery_codes_rotate_after_use(): void
    {
        $admin = User::factory()->create(['account_type' => 'ADMIN']);
        $service = app(TotpService::class);
        $enrollment = $service->startEnrollment($admin);
        $currentCounter = intdiv(time(), 30);

        $initialRecoveryCodes = $service->confirm(
            $admin,
            $this->totpCode($enrollment['secret'], $currentCounter),
        );

        self::assertCount(8, $initialRecoveryCodes);
        self::assertMatchesRegularExpression('/^[A-Z2-7]{4}-[A-Z2-7]{4}-[A-Z2-7]{4}$/', $initialRecoveryCodes[0]);
        $this->assertDatabaseCount('recovery_codes', 8);
        self::assertFalse(RecoveryCode::query()->pluck('code_hash')->contains($initialRecoveryCodes[0]));
        self::assertFalse($service->verify($admin, '000000'), 'An invalid TOTP must not authenticate.');

        $nextCode = $this->totpCode($enrollment['secret'], $currentCounter + 1);
        self::assertTrue($service->verify($admin, $nextCode));
        self::assertFalse($service->verify($admin, $nextCode), 'A TOTP counter must not be accepted twice.');

        $replacementCodes = $service->consumeRecoveryCode($admin, $initialRecoveryCodes[0]);
        self::assertIsArray($replacementCodes);
        self::assertCount(8, $replacementCodes);
        self::assertNotSame($initialRecoveryCodes, $replacementCodes);
        self::assertNull($service->consumeRecoveryCode($admin, $initialRecoveryCodes[0]));
        self::assertSame(8, RecoveryCode::query()->whereNull('used_at')->count());
    }

    private function totpCode(string $secret, int $counter): string
    {
        $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        $buffer = 0;
        $bits = 0;
        $decoded = '';
        foreach (str_split($secret) as $character) {
            $position = strpos($alphabet, $character);
            self::assertNotFalse($position);
            $buffer = ($buffer << 5) | $position;
            $bits += 5;
            if ($bits >= 8) {
                $bits -= 8;
                $decoded .= chr(($buffer >> $bits) & 0xFF);
            }
        }

        $hash = hash_hmac('sha1', pack('N2', 0, $counter), $decoded, true);
        $offset = ord($hash[19]) & 0x0F;
        $value = ((ord($hash[$offset]) & 0x7F) << 24)
            | ((ord($hash[$offset + 1]) & 0xFF) << 16)
            | ((ord($hash[$offset + 2]) & 0xFF) << 8)
            | (ord($hash[$offset + 3]) & 0xFF);

        return str_pad((string) ($value % 1_000_000), 6, '0', STR_PAD_LEFT);
    }
}
