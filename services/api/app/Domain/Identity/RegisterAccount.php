<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\User;
use App\Models\UserProfile;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

final class RegisterAccount
{
    public function __construct(private readonly EmailOtpService $otps) {}

    /** @param array<string, mixed> $input */
    public function handle(array $input): User
    {
        return DB::transaction(function () use ($input): User {
            $email = mb_strtolower(trim((string) $input['email']));
            if (User::query()->whereRaw('LOWER(email) = ?', [$email])->exists()) {
                throw new AuthenticationException('ACCOUNT_ALREADY_EXISTS', 'An account already exists for this email.', 409);
            }

            /** @var User $user */
            $user = User::query()->create([
                'name' => trim((string) $input['full_name']),
                'email' => $email,
                'password' => Hash::make((string) $input['password']),
                'account_type' => $input['account_type'],
                'account_status' => 'PENDING_VERIFICATION',
            ]);
            UserProfile::query()->create([
                'user_id' => $user->getKey(),
                'full_name' => $user->name,
                'mobile_e164' => $input['mobile_e164'],
                'locale' => 'en',
            ]);

            if ($user->account_type === 'BUYER') {
                DB::table('buyer_profiles')->insert([
                    'id' => (string) Str::uuid7(),
                    'user_id' => $user->getKey(),
                    'buyer_type' => $input['buyer_type'],
                    'company_name' => $input['company_name'] ?? null,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            } else {
                $organization = VendorOrganization::query()->create([
                    'legal_name' => trim((string) $input['business_name']),
                    'store_name' => trim((string) $input['business_name']),
                    'account_status' => 'ACTIVE',
                    'onboarding_status' => 'NOT_STARTED',
                    'marketplace_status' => 'NOT_ACTIVE',
                ]);
                VendorMembership::query()->create([
                    'vendor_organization_id' => $organization->getKey(),
                    'user_id' => $user->getKey(),
                    'role' => 'OWNER',
                    'status' => 'ACTIVE',
                    'activated_at' => now(),
                ]);
            }

            $this->recordRequiredAgreements($user, (string) $input['account_type']);
            $this->otps->issue($email, 'EMAIL_VERIFICATION', $user);

            return $user;
        });
    }

    public function assertEmailAvailable(string $email): void
    {
        $normalized = mb_strtolower(trim($email));
        if (User::query()->whereRaw('LOWER(email) = ?', [$normalized])->exists()) {
            throw new AuthenticationException('ACCOUNT_ALREADY_EXISTS', 'An account already exists for this email.', 409);
        }
    }

    private function recordRequiredAgreements(User $user, string $audience): void
    {
        $versions = DB::table('agreement_versions as av')
            ->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')
            ->whereIn('ad.audience', ['ALL', $audience])
            ->whereIn('ad.code', ['TERMS_OF_SERVICE', 'PRIVACY_NOTICE'])
            ->whereNull('av.retired_at')
            ->where('av.effective_at', '<=', now())
            ->select('av.id')
            ->get();

        if ($versions->count() !== 2) {
            throw new AuthenticationException('AGREEMENTS_NOT_CONFIGURED', 'Registration is temporarily unavailable.', 503);
        }

        foreach ($versions as $version) {
            DB::table('agreement_acceptances')->insert([
                'id' => (string) Str::uuid7(),
                'user_id' => $user->getKey(),
                'agreement_version_id' => $version->id,
                'vendor_organization_id' => null,
                'source' => 'REGISTRATION',
                'accepted_at' => now(),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
