<?php

declare(strict_types=1);

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

final class SchemaFoundationTest extends TestCase
{
    use RefreshDatabase;

    public function test_required_postgresql_extensions_and_domain_tables_are_present(): void
    {
        $extensions = DB::table('pg_extension')->pluck('extname')->all();

        self::assertContains('postgis', $extensions);
        self::assertContains('pg_trgm', $extensions);
        self::assertContains('pgcrypto', $extensions);
        self::assertTrue(Schema::hasColumns('financial_snapshots', [
            'materials_payable_centavos',
            'materials_exclusive_centavos',
            'buyer_total_centavos',
            'calculation_version',
        ]));
        self::assertTrue(Schema::hasColumns('material_price_daily_aggregates', [
            'local_snapshot_date',
            'material_comparable_group_version_id',
            'distinct_vendor_count',
            'average_php_price',
        ]));
    }

    public function test_critical_financial_and_analytics_constraints_are_installed(): void
    {
        $required = [
            'financial_snapshot_amounts_check',
            'physical_payment_state_amount_check',
            'refund_source_allocation_check',
            'remittance_amounts_check',
            'posting_batch_balance_check',
            'analytics_refresh_counts_check',
            'material_daily_aggregate_values_check',
            'comparable_assignment_state_check',
        ];
        $installed = DB::table('pg_constraint')
            ->whereIn('conname', $required)
            ->pluck('conname')
            ->all();

        sort($required);
        sort($installed);
        self::assertSame($required, $installed);
    }

    public function test_null_safe_material_cache_uniqueness_indexes_exist(): void
    {
        $indexes = DB::table('pg_indexes')
            ->where('schemaname', 'public')
            ->whereIn('indexname', [
                'material_daily_aggregate_null_safe_unique',
                'materials_analytics_cache_null_safe_unique',
            ])
            ->pluck('indexname')
            ->all();

        self::assertCount(2, $indexes);
    }
}
