<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\AdminInvitation;
use App\Models\AdminMembership;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

final class AcceptAdminInvitation
{
    public function handle(string $token, string $fullName, string $password): User
    {
        return DB::transaction(function () use ($token, $fullName, $password): User {
            $hash = hash_hmac('sha256', $token, (string) config('app.key'));
            $invitation = AdminInvitation::query()->where('token_hash', $hash)->lockForUpdate()->first();
            if ($invitation === null || $invitation->accepted_at !== null || $invitation->expires_at->isPast()) {
                throw new AuthenticationException('ADMIN_INVITATION_INVALID', 'This invitation is invalid or expired.', 410);
            }
            if (User::query()->whereRaw('LOWER(email) = ?', [$invitation->normalized_email])->exists()) {
                throw new AuthenticationException('ACCOUNT_ALREADY_EXISTS', 'An account already exists for this email.', 409);
            }

            $user = User::query()->create([
                'name' => trim($fullName),
                'email' => $invitation->normalized_email,
                'password' => Hash::make($password),
                'account_type' => 'ADMIN',
                'account_status' => 'ACTIVE',
                'email_verified_at' => now(),
            ]);
            UserProfile::query()->create(['user_id' => $user->getKey(), 'full_name' => $user->name, 'locale' => 'en']);
            AdminMembership::query()->create([
                'user_id' => $user->getKey(),
                'platform_role_id' => $invitation->platform_role_id,
                'status' => 'ACTIVE',
                'activated_at' => now(),
            ]);
            $this->recordAgreements($user);
            $invitation->update(['accepted_at' => now()]);

            DB::table('audit_logs')->insert([
                'id' => (string) Str::uuid7(),
                'actor_user_id' => $user->getKey(),
                'actor_role' => 'ADMIN_SUPERADMIN',
                'action' => 'ADMIN_BOOTSTRAP_INVITATION_ACCEPTED',
                'resource_type' => 'ADMIN_INVITATION',
                'resource_id' => $invitation->getKey(),
                'correlation_id' => 'bootstrap-'.Str::uuid7(),
                'after' => json_encode(['bootstrap' => $invitation->bootstrap], JSON_THROW_ON_ERROR),
                'succeeded' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            return $user;
        });
    }

    private function recordAgreements(User $user): void
    {
        $versions = DB::table('agreement_versions as av')
            ->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')
            ->whereIn('ad.audience', ['ALL', 'ADMIN'])
            ->whereIn('ad.code', ['TERMS_OF_SERVICE', 'PRIVACY_NOTICE'])
            ->whereNull('av.retired_at')
            ->where('av.effective_at', '<=', now())
            ->pluck('av.id');
        if ($versions->count() !== 2) {
            throw new AuthenticationException('AGREEMENTS_NOT_CONFIGURED', 'Invitation acceptance is temporarily unavailable.', 503);
        }
        foreach ($versions as $versionId) {
            DB::table('agreement_acceptances')->insert([
                'id' => (string) Str::uuid7(),
                'user_id' => $user->getKey(),
                'agreement_version_id' => $versionId,
                'source' => 'ADMIN_INVITATION',
                'accepted_at' => now(),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
