<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Jobs\ProcessOutboxEvent;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

final class OutboxPublisher
{
    /** @param array<string, int|string> $sensitivePayload */
    public function publish(
        string $eventType,
        string $aggregateType,
        string $aggregateId,
        array $sensitivePayload,
    ): string {
        $id = (string) Str::uuid7();
        $sealedPayload = Crypt::encryptString(json_encode($sensitivePayload, JSON_THROW_ON_ERROR));

        DB::table('outbox_events')->insert([
            'id' => $id,
            'event_type' => $eventType,
            'aggregate_type' => $aggregateType,
            'aggregate_id' => $aggregateId,
            'payload' => json_encode(['sealed_payload' => $sealedPayload], JSON_THROW_ON_ERROR),
            'available_at' => now(),
            'attempts' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        DB::afterCommit(static function () use ($id): void {
            try {
                ProcessOutboxEvent::dispatch($id);
            } catch (Throwable $exception) {
                report($exception);
            }
        });

        return $id;
    }
}
