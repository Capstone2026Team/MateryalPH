<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('analytics_refresh_runs', function (Blueprint $table): void {
            $table->string('error_code', 64)->nullable();
            $table->timestampTz('validated_at')->nullable();
            $table->timestampTz('published_at')->nullable();
        });
        $this->entity('material_comparable_groups', function (Blueprint $table): void {
            $table->foreignUuid('material_id')->constrained('materials')->restrictOnDelete();
            $table->string('code', 96)->unique();
            $table->string('display_name');
            $table->string('status', 24)->default('DRAFT');
            $table->uuid('current_version_id')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        $this->entity('material_comparable_group_versions', function (Blueprint $table): void {
            $table->foreignUuid('material_comparable_group_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->string('brand')->nullable();
            $table->string('model')->nullable();
            $table->jsonb('controlled_specification');
            $table->string('variant_key', 128);
            $table->foreignUuid('canonical_unit_id')->constrained('units')->restrictOnDelete();
            $table->string('conversion_version', 48);
            $table->string('review_state', 24)->default('DRAFT');
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('reviewed_at')->nullable();
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->string('content_hash');
            $table->unique(['material_comparable_group_id', 'variant_key', 'version'], 'material_comparable_group_versions_unique_variant_version');
        });
        Schema::table('material_comparable_groups', function (Blueprint $table): void {
            $table->foreign('current_version_id')->references('id')->on('material_comparable_group_versions')->restrictOnDelete();
        });
        $this->entity('listing_comparable_assignments', function (Blueprint $table): void {
            $table->foreignUuid('listing_variant_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('material_comparable_group_version_id')->constrained()->restrictOnDelete();
            $table->string('mapping_state', 24)->default('PENDING_REVIEW');
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->text('review_reason')->nullable();
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->unique(['listing_variant_id', 'material_comparable_group_version_id']);
        });
        Schema::table('price_observations', function (Blueprint $table): void {
            $table->foreign('comparable_group_version_id')
                ->references('id')
                ->on('material_comparable_group_versions')
                ->restrictOnDelete();
        });
        $this->entity('analytics_published_runs', function (Blueprint $table): void {
            $table->string('kind', 48);
            $table->string('environment', 8);
            $table->string('dataset_id', 64);
            $table->date('snapshot_date');
            $table->foreignUuid('analytics_refresh_run_id')->unique()->constrained()->restrictOnDelete();
            $table->timestampTz('published_at');
            $table->unique(['kind', 'environment', 'dataset_id', 'snapshot_date'], 'analytics_published_run_scope_unique');
        });
        $this->entity('material_price_daily_aggregates', function (Blueprint $table): void {
            $table->foreignUuid('analytics_refresh_run_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('material_comparable_group_version_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8);
            $table->string('dataset_id', 64);
            $table->date('local_snapshot_date');
            $table->string('audience', 16);
            $table->string('geography_scope_type', 24);
            $table->string('geography_scope_hash');
            $table->unsignedSmallInteger('radius_km')->nullable();
            $table->unsignedInteger('distinct_vendor_count');
            $table->unsignedInteger('distinct_listing_count');
            $table->decimal('average_php_price', 20, 8);
            $table->bigInteger('minimum_centavos');
            $table->bigInteger('maximum_centavos');
            $table->string('composition_hash');
            $table->unique(['analytics_refresh_run_id', 'material_comparable_group_version_id', 'audience', 'geography_scope_hash', 'radius_km'], 'material_daily_aggregate_scope_unique');
            $table->index(['environment', 'dataset_id', 'material_comparable_group_version_id', 'local_snapshot_date'], 'material_daily_aggregate_lookup_index');
        });
        $this->entity('materials_analytics_result_cache', function (Blueprint $table): void {
            $table->foreignUuid('analytics_refresh_run_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8);
            $table->string('dataset_id', 64);
            $table->string('audience', 16);
            $table->string('geography_scope_type', 24);
            $table->string('geography_scope_hash');
            $table->unsignedSmallInteger('radius_km')->nullable();
            $table->date('window_start');
            $table->date('window_end');
            $table->unsignedSmallInteger('minimum_vendor_count');
            $table->string('filters_hash');
            $table->jsonb('safe_response');
            $table->timestampTz('expires_at');
            $table->unique(['analytics_refresh_run_id', 'audience', 'geography_scope_hash', 'radius_km', 'window_start', 'window_end', 'filters_hash'], 'materials_analytics_cache_scope_unique');
            $table->index(['environment', 'dataset_id', 'audience', 'expires_at'], 'materials_analytics_cache_expiry_index');
        });

        if (DB::getDriverName() === 'pgsql') {
            DB::statement("ALTER TABLE analytics_refresh_runs ADD CONSTRAINT analytics_refresh_environment_check CHECK (environment IN ('TEST','DEMO'))");
            DB::statement("ALTER TABLE analytics_refresh_runs ADD CONSTRAINT analytics_refresh_kind_check CHECK (kind = 'MATERIAL_PRICE_DAILY')");
            DB::statement("ALTER TABLE analytics_refresh_runs ADD CONSTRAINT analytics_refresh_state_check CHECK (state IN ('RUNNING','VALIDATED','PUBLISHED','FAILED','SUPERSEDED'))");
            DB::statement("ALTER TABLE analytics_refresh_runs ADD CONSTRAINT analytics_refresh_counts_check CHECK (selected_count <= source_count AND (state <> 'FAILED' OR error_code IS NOT NULL) AND (state <> 'VALIDATED' OR validated_at IS NOT NULL) AND (state <> 'PUBLISHED' OR published_at IS NOT NULL))");
            DB::statement("ALTER TABLE price_observations ADD CONSTRAINT price_observation_environment_check CHECK (environment IN ('TEST','DEMO'))");
            DB::statement("ALTER TABLE price_observations ADD CONSTRAINT price_observation_date_check CHECK (local_snapshot_date = (observed_at AT TIME ZONE 'Asia/Manila')::date)");
            DB::statement('ALTER TABLE price_observations ADD CONSTRAINT price_observation_address_version_check CHECK (address_version >= 1)');
            DB::statement("ALTER TABLE listing_comparable_assignments ADD CONSTRAINT comparable_assignment_state_check CHECK (mapping_state IN ('PENDING_REVIEW','APPROVED','REJECTED','RETIRED'))");
            DB::statement('ALTER TABLE listing_comparable_assignments ADD CONSTRAINT comparable_assignment_dates_check CHECK (effective_until IS NULL OR effective_until > effective_from)');
            DB::statement('ALTER TABLE material_comparable_group_versions ADD CONSTRAINT comparable_group_version_dates_check CHECK (effective_until IS NULL OR effective_until > effective_from)');
            DB::statement("ALTER TABLE material_comparable_group_versions ADD CONSTRAINT comparable_group_review_check CHECK (review_state IN ('DRAFT','APPROVED','REJECTED','SUPERSEDED'))");
            DB::statement("CREATE UNIQUE INDEX listing_one_effective_comparable_assignment ON listing_comparable_assignments (listing_variant_id) WHERE effective_until IS NULL AND mapping_state = 'APPROVED'");
            DB::statement('CREATE INDEX price_observations_group_date_index ON price_observations (environment, dataset_id, comparable_group_version_id, local_snapshot_date)');
            DB::statement("ALTER TABLE analytics_published_runs ADD CONSTRAINT analytics_published_run_scope_check CHECK (kind = 'MATERIAL_PRICE_DAILY' AND environment IN ('TEST','DEMO'))");
            DB::statement("ALTER TABLE material_price_daily_aggregates ADD CONSTRAINT material_daily_aggregate_scope_check CHECK (environment IN ('TEST','DEMO') AND audience IN ('BUYER','VENDOR','ADMIN') AND geography_scope_type IN ('RADIUS','PSGC'))");
            DB::statement('ALTER TABLE material_price_daily_aggregates ADD CONSTRAINT material_daily_aggregate_radius_check CHECK ((geography_scope_type = \'RADIUS\' AND radius_km IN (5,10,20,30,40,50)) OR (geography_scope_type = \'PSGC\' AND radius_km IS NULL))');
            DB::statement("ALTER TABLE material_price_daily_aggregates ADD CONSTRAINT material_daily_aggregate_values_check CHECK (distinct_vendor_count >= 1 AND distinct_listing_count >= 1 AND average_php_price > 0 AND minimum_centavos > 0 AND maximum_centavos >= minimum_centavos AND (audience <> 'VENDOR' OR distinct_vendor_count >= 3))");
            DB::statement('CREATE UNIQUE INDEX material_daily_aggregate_null_safe_unique ON material_price_daily_aggregates (analytics_refresh_run_id, material_comparable_group_version_id, audience, geography_scope_hash, COALESCE(radius_km, 0))');
            DB::statement("ALTER TABLE materials_analytics_result_cache ADD CONSTRAINT materials_analytics_cache_scope_check CHECK (environment IN ('TEST','DEMO') AND audience IN ('BUYER','VENDOR','ADMIN') AND geography_scope_type IN ('RADIUS','PSGC'))");
            DB::statement('ALTER TABLE materials_analytics_result_cache ADD CONSTRAINT materials_analytics_cache_radius_check CHECK ((geography_scope_type = \'RADIUS\' AND radius_km IN (5,10,20,30,40,50)) OR (geography_scope_type = \'PSGC\' AND radius_km IS NULL))');
            DB::statement("ALTER TABLE materials_analytics_result_cache ADD CONSTRAINT materials_analytics_cache_window_check CHECK (window_start <= window_end AND window_end - window_start <= 365 AND minimum_vendor_count >= 1 AND (audience <> 'VENDOR' OR minimum_vendor_count >= 3))");
            DB::statement('CREATE UNIQUE INDEX materials_analytics_cache_null_safe_unique ON materials_analytics_result_cache (analytics_refresh_run_id, audience, geography_scope_hash, COALESCE(radius_km, 0), window_start, window_end, filters_hash)');
        }
    }

    private function entity(string $name, callable $columns): void
    {
        Schema::create($name, function (Blueprint $table) use ($columns): void {
            $table->uuid('id')->primary();
            $columns($table);
            $table->timestampsTz();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('materials_analytics_result_cache');
        Schema::dropIfExists('material_price_daily_aggregates');
        Schema::dropIfExists('analytics_published_runs');
        Schema::table('price_observations', fn (Blueprint $table) => $table->dropForeign(['comparable_group_version_id']));
        Schema::dropIfExists('listing_comparable_assignments');
        Schema::table('material_comparable_groups', fn (Blueprint $table) => $table->dropForeign(['current_version_id']));
        Schema::dropIfExists('material_comparable_group_versions');
        Schema::dropIfExists('material_comparable_groups');
        Schema::table('analytics_refresh_runs', function (Blueprint $table): void {
            $table->dropColumn(['error_code', 'validated_at', 'published_at']);
        });
    }
};
