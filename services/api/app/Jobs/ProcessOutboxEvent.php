<?php

declare(strict_types=1);

namespace App\Jobs;

use App\Domain\Operations\OutboxProcessor;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

final class ProcessOutboxEvent implements ShouldQueue
{
    use Dispatchable;
    use InteractsWithQueue;
    use Queueable;
    use SerializesModels;

    public int $tries = OutboxProcessor::MAX_ATTEMPTS;

    public function __construct(public readonly string $eventId) {}

    public function handle(OutboxProcessor $processor): void
    {
        $processor->process($this->eventId);
    }

    /** @return list<int> */
    public function backoff(): array
    {
        return [30, 120, 300, 900];
    }
}
