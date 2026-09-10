<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\LoginEvent;
use App\Models\User;
use Illuminate\Http\Request;

final class AuditRecorder
{
    /** @param array<string, mixed> $safeContext */
    public function record(Request $request, string $eventType, bool $succeeded, ?User $user = null, array $safeContext = []): void
    {
        LoginEvent::query()->create([
            'user_id' => $user?->getKey(),
            'normalized_email_hash' => isset($safeContext['email'])
                ? hash_hmac('sha256', mb_strtolower(trim((string) $safeContext['email'])), (string) config('app.key'))
                : null,
            'event_type' => $eventType,
            'succeeded' => $succeeded,
            'ip_address' => $request->ip(),
            'correlation_id' => (string) $request->attributes->get('correlation_id'),
            'safe_context' => array_diff_key($safeContext, ['email' => true]),
        ]);
    }
}
