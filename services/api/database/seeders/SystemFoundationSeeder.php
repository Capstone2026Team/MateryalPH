<?php

declare(strict_types=1);

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Laravel\Passport\ClientRepository;

final class SystemFoundationSeeder extends Seeder
{
    public function run(): void
    {
        $this->agreements();
        $this->roles();
        $this->financePolicies();
        $this->passportClient();
    }

    private function agreements(): void
    {
        foreach ([
            ['TERMS_OF_SERVICE', 'ALL', 'Terms of Service', '/legal/terms-of-service'],
            ['PRIVACY_NOTICE', 'ALL', 'Privacy Notice', '/legal/privacy-notice'],
            ['VENDOR_CODE_OF_CONDUCT', 'VENDOR', 'Vendor Code of Conduct', '/legal/vendor-code-of-conduct'],
        ] as [$code, $audience, $title, $uri]) {
            $documentId = DB::table('agreement_documents')->where('code', $code)->value('id') ?? (string) Str::uuid7();
            DB::table('agreement_documents')->updateOrInsert(
                ['code' => $code],
                ['id' => $documentId, 'audience' => $audience, 'title' => $title, 'created_at' => now(), 'updated_at' => now()],
            );
            DB::table('agreement_versions')->updateOrInsert(
                ['agreement_document_id' => $documentId, 'version' => 1],
                [
                    'id' => DB::table('agreement_versions')->where('agreement_document_id', $documentId)->where('version', 1)->value('id') ?? (string) Str::uuid7(),
                    'content_hash' => hash('sha256', $code.'|1|'.$uri),
                    'content_uri' => $uri,
                    'effective_at' => now()->startOfDay(),
                    'retired_at' => null,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
            );
        }
    }

    private function roles(): void
    {
        foreach ([
            ['ADMIN_SUPERADMIN', 'ADMIN', 'Superadmin'],
            ['ADMIN_OPERATIONS', 'ADMIN', 'Operations Admin'],
            ['ADMIN_COMPLIANCE', 'ADMIN', 'Compliance Admin'],
            ['ADMIN_FINANCE', 'ADMIN', 'Finance Admin'],
            ['ADMIN_DISPUTE', 'ADMIN', 'Dispute Admin'],
        ] as [$code, $platform, $name]) {
            DB::table('platform_roles')->updateOrInsert(
                ['code' => $code],
                [
                    'id' => DB::table('platform_roles')->where('code', $code)->value('id') ?? (string) Str::uuid7(),
                    'platform' => $platform,
                    'name' => $name,
                    'system_role' => true,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
            );
        }
    }

    private function financePolicies(): void
    {
        foreach (['TEST', 'DEMO'] as $environment) {
            DB::table('fee_policy_versions')->updateOrInsert(
                ['environment' => $environment, 'code' => 'MONTHLY_VENDOR_COMMISSION', 'version' => 1],
                [
                    'id' => DB::table('fee_policy_versions')->where('environment', $environment)->where('code', 'MONTHLY_VENDOR_COMMISSION')->where('version', 1)->value('id') ?? (string) Str::uuid7(),
                    'commission_basis_points' => 200,
                    'basis' => 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT',
                    'cadence' => 'MONTHLY',
                    'effective_from' => now()->startOfDay(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
            );
        }
    }

    private function passportClient(): void
    {
        $hasPersonalClient = DB::table('oauth_clients')->get(['grant_types'])->contains(
            fn (object $client): bool => in_array('personal_access', json_decode($client->grant_types, true) ?? [], true),
        );
        if (! $hasPersonalClient) {
            app(ClientRepository::class)->createPersonalAccessGrantClient('MateryalPH first-party clients', 'users');
        }
    }
}
