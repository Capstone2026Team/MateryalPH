<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Mail\AdminInvitationMail;
use App\Mail\EmailOtpMail;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use RuntimeException;
use Throwable;

final class OutboxProcessor
{
    public const MAX_ATTEMPTS = 5;

    public function process(string $eventId): void
    {
        Cache::lock('outbox-event:'.$eventId, 120)->block(5, function () use ($eventId): void {
            $event = DB::table('outbox_events')->where('id', $eventId)->first();
            if ($event === null || $event->processed_at !== null || (int) $event->attempts >= self::MAX_ATTEMPTS) {
                return;
            }

            try {
                /** @var array{sealed_payload?: mixed} $envelope */
                $envelope = json_decode((string) $event->payload, true, flags: JSON_THROW_ON_ERROR);
                if (! is_string($envelope['sealed_payload'] ?? null)) {
                    throw new RuntimeException('The outbox event has no sealed payload.');
                }

                /** @var array<string, mixed> $payload */
                $payload = json_decode(Crypt::decryptString($envelope['sealed_payload']), true, flags: JSON_THROW_ON_ERROR);
                $this->deliver((string) $event->event_type, $payload);

                DB::table('outbox_events')
                    ->where('id', $eventId)
                    ->whereNull('processed_at')
                    ->update(['processed_at' => now(), 'updated_at' => now()]);
            } catch (Throwable $exception) {
                DB::table('outbox_events')
                    ->where('id', $eventId)
                    ->increment('attempts', 1, ['updated_at' => now()]);

                throw $exception;
            }
        });
    }

    /** @param array<string, mixed> $payload */
    private function deliver(string $eventType, array $payload): void
    {
        $recipient = $payload['recipient'] ?? null;
        if (! is_string($recipient)) {
            throw new RuntimeException('The outbox email recipient is invalid.');
        }

        match ($eventType) {
            'AUTH_EMAIL_OTP_REQUESTED' => Mail::to($recipient)->send(new EmailOtpMail(
                $this->requiredString($payload, 'code'),
                $this->requiredString($payload, 'purpose'),
                $this->requiredInteger($payload, 'ttl_minutes'),
            )),
            'ADMIN_BOOTSTRAP_INVITATION_REQUESTED' => Mail::to($recipient)->send(new AdminInvitationMail(
                $this->requiredString($payload, 'invitation_url'),
            )),
            default => throw new RuntimeException('Unsupported outbox event type.'),
        };
    }

    /** @param array<string, mixed> $payload */
    private function requiredString(array $payload, string $key): string
    {
        if (! is_string($payload[$key] ?? null)) {
            throw new RuntimeException('The outbox payload is invalid.');
        }

        return $payload[$key];
    }

    /** @param array<string, mixed> $payload */
    private function requiredInteger(array $payload, string $key): int
    {
        if (! is_int($payload[$key] ?? null)) {
            throw new RuntimeException('The outbox payload is invalid.');
        }

        return $payload[$key];
    }
}
