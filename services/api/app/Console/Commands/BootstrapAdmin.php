<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Operations\OutboxPublisher;
use App\Models\AdminInvitation;
use App\Models\PlatformRole;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

final class BootstrapAdmin extends Command
{
    protected $signature = 'materyalph:bootstrap-admin {email : The invited admin email address}';

    protected $description = 'Queue the one-time, auditable initial admin invitation';

    public function handle(OutboxPublisher $outbox): int
    {
        $email = mb_strtolower(trim((string) $this->argument('email')));
        if (filter_var($email, FILTER_VALIDATE_EMAIL) === false) {
            $this->components->error('Provide a valid admin email address.');

            return self::INVALID;
        }
        if (DB::table('admin_memberships')->exists() || AdminInvitation::query()->where('bootstrap', true)->exists()) {
            $this->components->error('The one-time admin bootstrap has already been used.');

            return self::FAILURE;
        }

        $plainToken = rtrim(strtr(base64_encode(random_bytes(48)), '+/', '-_'), '=');
        DB::transaction(function () use ($email, $plainToken, $outbox): void {
            $role = PlatformRole::query()->firstOrCreate(
                ['code' => 'ADMIN_SUPERADMIN'],
                ['platform' => 'ADMIN', 'name' => 'Superadmin', 'system_role' => true],
            );

            $invitation = AdminInvitation::query()->create([
                'normalized_email' => $email,
                'platform_role_id' => $role->getKey(),
                'token_hash' => hash_hmac('sha256', $plainToken, (string) config('app.key')),
                'expires_at' => now()->addDay(),
                'bootstrap' => true,
            ]);

            $url = rtrim((string) config('app.admin_frontend_url'), '/').'/accept-invite?token='.urlencode($plainToken);
            $outbox->publish('ADMIN_BOOTSTRAP_INVITATION_REQUESTED', 'ADMIN_INVITATION', (string) $invitation->getKey(), [
                'recipient' => $invitation->normalized_email,
                'invitation_url' => $url,
            ]);
        });
        $this->components->info('The one-time admin invitation was queued for delivery. No invitation secret was printed.');

        return self::SUCCESS;
    }
}
