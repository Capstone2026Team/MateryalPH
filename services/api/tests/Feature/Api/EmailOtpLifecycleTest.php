<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Operations\OutboxPublisher;
use App\Models\EmailOtp;
use App\Models\User;
use Illuminate\Database\QueryException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

final class EmailOtpLifecycleTest extends TestCase
{
    use RefreshDatabase;

    public function test_otp_is_hashed_single_use_and_attempt_limited(): void
    {
        $generator = new class implements OtpCodeGenerator
        {
            public function sixDigits(): string
            {
                return '123456';
            }
        };
        $service = new EmailOtpService($generator, $this->app->make(OutboxPublisher::class));
        $user = User::factory()->create();

        $service->issue($user->email, 'EMAIL_VERIFICATION', $user);
        $stored = EmailOtp::query()->sole();
        self::assertNotSame('123456', $stored->code_hash);
        self::assertMatchesRegularExpression('/^[a-f0-9]{64}$/', $stored->code_hash);

        $event = DB::table('outbox_events')->where('aggregate_id', $stored->getKey())->sole();
        $storedEnvelope = (string) $event->payload;
        self::assertStringNotContainsString($user->email, $storedEnvelope);
        self::assertStringNotContainsString('123456', $storedEnvelope);
        /** @var array{sealed_payload: string} $envelope */
        $envelope = json_decode($storedEnvelope, true, flags: JSON_THROW_ON_ERROR);
        /** @var array{recipient: string, code: string, purpose: string, ttl_minutes: int} $payload */
        $payload = json_decode(Crypt::decryptString($envelope['sealed_payload']), true, flags: JSON_THROW_ON_ERROR);
        self::assertSame($user->email, $payload['recipient']);
        self::assertSame('123456', $payload['code']);
        self::assertSame('EMAIL_VERIFICATION', $payload['purpose']);

        $verified = $service->verify($user->email, 'EMAIL_VERIFICATION', '123456');
        self::assertNotNull($verified->consumed_at);

        $this->expectException(AuthenticationException::class);
        $service->verify($user->email, 'EMAIL_VERIFICATION', '123456');
    }

    public function test_failed_attempts_persist_and_the_fifth_failure_invalidates_the_code(): void
    {
        $service = new EmailOtpService(new class implements OtpCodeGenerator
        {
            public function sixDigits(): string
            {
                return '654321';
            }
        }, $this->app->make(OutboxPublisher::class));
        $user = User::factory()->create();
        $service->issue($user->email, 'PASSWORD_RESET', $user);

        for ($attempt = 1; $attempt <= 5; $attempt++) {
            try {
                $service->verify($user->email, 'PASSWORD_RESET', '000000');
                self::fail('An incorrect OTP must never verify.');
            } catch (AuthenticationException $exception) {
                $expected = $attempt === 5 ? 'OTP_ATTEMPTS_EXHAUSTED' : 'OTP_INVALID_OR_EXPIRED';
                self::assertSame($expected, $exception->errorCode);
            }
        }

        $stored = EmailOtp::query()->sole();
        self::assertSame(5, $stored->attempts);
        self::assertNotNull($stored->invalidated_at);
    }

    public function test_expired_and_replaced_codes_cannot_be_used(): void
    {
        $codes = new class implements OtpCodeGenerator
        {
            private int $sequence = 0;

            public function sixDigits(): string
            {
                $this->sequence++;

                return $this->sequence === 1 ? '111111' : '222222';
            }
        };
        $service = new EmailOtpService($codes, $this->app->make(OutboxPublisher::class));
        $user = User::factory()->create();

        $service->issue($user->email, 'PASSWORD_RESET', $user, 1);
        $this->travel(61)->seconds();

        try {
            $service->verify($user->email, 'PASSWORD_RESET', '111111');
            self::fail('An expired OTP must not verify.');
        } catch (AuthenticationException $exception) {
            self::assertSame('OTP_INVALID_OR_EXPIRED', $exception->errorCode);
        }

        $service->issue($user->email, 'PASSWORD_RESET', $user);
        self::assertSame(1, EmailOtp::query()->whereNotNull('invalidated_at')->count());

        try {
            $service->verify($user->email, 'PASSWORD_RESET', '111111');
            self::fail('A replaced OTP must not verify.');
        } catch (AuthenticationException $exception) {
            self::assertSame('OTP_INVALID_OR_EXPIRED', $exception->errorCode);
        }

        self::assertNotNull($service->verify($user->email, 'PASSWORD_RESET', '222222')->consumed_at);
        $this->travelBack();
    }

    public function test_otp_changes_roll_back_when_outbox_publication_fails(): void
    {
        $service = new EmailOtpService(new class implements OtpCodeGenerator
        {
            public function sixDigits(): string
            {
                return '246810';
            }
        }, $this->app->make(OutboxPublisher::class));
        $user = User::factory()->create();
        $service->issue($user->email, 'EMAIL_VERIFICATION', $user);
        $original = EmailOtp::query()->sole();
        $this->travel(61)->seconds();
        Schema::rename('outbox_events', 'outbox_events_unavailable');

        try {
            $service->issue($user->email, 'EMAIL_VERIFICATION', $user);
            self::fail('OTP creation must fail when its outbox event cannot be persisted.');
        } catch (QueryException) {
            self::assertSame(1, EmailOtp::query()->count());
            self::assertNull($original->refresh()->invalidated_at);
        } finally {
            Schema::rename('outbox_events_unavailable', 'outbox_events');
            $this->travelBack();
        }
    }
}
