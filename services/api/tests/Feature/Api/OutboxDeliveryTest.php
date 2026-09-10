<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Operations\OutboxProcessor;
use App\Domain\Operations\OutboxPublisher;
use App\Jobs\ProcessOutboxEvent;
use App\Mail\AdminInvitationMail;
use App\Mail\EmailOtpMail;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Str;
use RuntimeException;
use Tests\TestCase;

final class OutboxDeliveryTest extends TestCase
{
    use RefreshDatabase;

    public function test_email_otp_event_is_delivered_once_when_a_job_is_processed_more_than_once(): void
    {
        Mail::fake();
        $eventId = $this->publisher()->publish(
            'AUTH_EMAIL_OTP_REQUESTED',
            'EMAIL_OTP',
            (string) Str::uuid7(),
            [
                'recipient' => 'buyer@example.test',
                'code' => '987654',
                'purpose' => 'EMAIL_VERIFICATION',
                'ttl_minutes' => 10,
            ],
        );

        $processor = $this->app->make(OutboxProcessor::class);
        $processor->process($eventId);
        $processor->process($eventId);

        Mail::assertSent(EmailOtpMail::class, function (EmailOtpMail $mail): bool {
            return $mail->hasTo('buyer@example.test')
                && $mail->code === '987654'
                && $mail->purpose === 'EMAIL_VERIFICATION'
                && $mail->expiresInMinutes === 10;
        });
        Mail::assertSentCount(1);
        self::assertNotNull(DB::table('outbox_events')->where('id', $eventId)->value('processed_at'));
    }

    public function test_admin_invitation_event_delivers_the_sealed_invitation_url(): void
    {
        Mail::fake();
        $invitationUrl = 'https://admin.example.test/accept-invite?token=single-use-token';
        $eventId = $this->publisher()->publish(
            'ADMIN_BOOTSTRAP_INVITATION_REQUESTED',
            'ADMIN_INVITATION',
            (string) Str::uuid7(),
            ['recipient' => 'admin@example.test', 'invitation_url' => $invitationUrl],
        );

        $storedPayload = (string) DB::table('outbox_events')->where('id', $eventId)->value('payload');
        self::assertStringNotContainsString('admin@example.test', $storedPayload);
        self::assertStringNotContainsString('single-use-token', $storedPayload);

        $this->app->make(OutboxProcessor::class)->process($eventId);

        Mail::assertSent(AdminInvitationMail::class, function (AdminInvitationMail $mail) use ($invitationUrl): bool {
            return $mail->hasTo('admin@example.test') && $mail->acceptUrl === $invitationUrl;
        });
        Mail::assertSentCount(1);
    }

    public function test_admin_bootstrap_command_queues_a_sealed_invitation(): void
    {
        $this->artisan('materyalph:bootstrap-admin', ['email' => 'first.admin@example.test'])
            ->expectsOutputToContain('queued for delivery')
            ->assertSuccessful();

        self::assertTrue(DB::table('admin_invitations')->where('normalized_email', 'first.admin@example.test')->exists());
        $storedPayload = (string) DB::table('outbox_events')
            ->where('event_type', 'ADMIN_BOOTSTRAP_INVITATION_REQUESTED')
            ->sole()
            ->payload;
        self::assertStringNotContainsString('first.admin@example.test', $storedPayload);
        self::assertStringNotContainsString('accept-invite?token=', $storedPayload);
    }

    public function test_failed_delivery_increments_retry_accounting(): void
    {
        // Isolate one worker attempt from the publisher's after-commit dispatch.
        Queue::fake();
        $eventId = $this->publisher()->publish(
            'UNSUPPORTED_TEST_EVENT',
            'TEST',
            (string) Str::uuid7(),
            ['recipient' => 'operator@example.test'],
        );
        Queue::assertPushed(ProcessOutboxEvent::class, fn (ProcessOutboxEvent $job): bool => $job->eventId === $eventId);
        self::assertSame(0, (int) DB::table('outbox_events')->where('id', $eventId)->value('attempts'));

        try {
            $this->app->make(OutboxProcessor::class)->process($eventId);
            self::fail('Unsupported outbox events must fail processing.');
        } catch (RuntimeException $exception) {
            self::assertSame('Unsupported outbox event type.', $exception->getMessage());
        }

        $event = DB::table('outbox_events')->where('id', $eventId)->sole();
        self::assertSame(1, (int) $event->attempts);
        self::assertNull($event->processed_at);
    }

    public function test_dispatch_command_excludes_exhausted_events(): void
    {
        Queue::fake();
        $eligibleId = $this->insertPendingEvent(OutboxProcessor::MAX_ATTEMPTS - 1);
        $exhaustedId = $this->insertPendingEvent(OutboxProcessor::MAX_ATTEMPTS);

        $this->artisan('materyalph:outbox-dispatch', ['--limit' => 100])
            ->expectsOutputToContain('Enqueued 1 pending outbox event(s).')
            ->assertSuccessful();

        Queue::assertPushed(ProcessOutboxEvent::class, 1);
        Queue::assertPushed(ProcessOutboxEvent::class, fn (ProcessOutboxEvent $job): bool => $job->eventId === $eligibleId);
        Queue::assertNotPushed(ProcessOutboxEvent::class, fn (ProcessOutboxEvent $job): bool => $job->eventId === $exhaustedId);
    }

    private function publisher(): OutboxPublisher
    {
        return $this->app->make(OutboxPublisher::class);
    }

    private function insertPendingEvent(int $attempts): string
    {
        $id = (string) Str::uuid7();
        DB::table('outbox_events')->insert([
            'id' => $id,
            'event_type' => 'UNSUPPORTED_TEST_EVENT',
            'aggregate_type' => 'TEST',
            'aggregate_id' => (string) Str::uuid7(),
            'payload' => json_encode(['sealed_payload' => 'unused-by-dispatch-test'], JSON_THROW_ON_ERROR),
            'available_at' => now(),
            'processed_at' => null,
            'attempts' => $attempts,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return $id;
    }
}
