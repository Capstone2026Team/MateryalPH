<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Operations\OutboxProcessor;
use App\Jobs\ProcessOutboxEvent;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

final class DispatchOutbox extends Command
{
    protected $signature = 'materyalph:outbox-dispatch {--limit=100 : Maximum pending events to enqueue}';

    protected $description = 'Enqueue available MateryalPH outbox events for idempotent processing';

    public function handle(): int
    {
        $limit = max(1, min(1000, (int) $this->option('limit')));
        $ids = DB::table('outbox_events')
            ->whereNull('processed_at')
            ->where('attempts', '<', OutboxProcessor::MAX_ATTEMPTS)
            ->where('available_at', '<=', now())
            ->orderBy('available_at')
            ->limit($limit)
            ->pluck('id');

        foreach ($ids as $id) {
            ProcessOutboxEvent::dispatch((string) $id);
        }

        $this->components->info(sprintf('Enqueued %d pending outbox event(s).', $ids->count()));

        return self::SUCCESS;
    }
}
