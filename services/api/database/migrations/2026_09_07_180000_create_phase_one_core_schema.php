<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::statement('CREATE EXTENSION IF NOT EXISTS postgis');
            DB::statement('CREATE EXTENSION IF NOT EXISTS pg_trgm');
            DB::statement('CREATE EXTENSION IF NOT EXISTS pgcrypto');
        }

        Schema::table('users', function (Blueprint $table): void {
            $table->uuid('public_id')->nullable()->unique();
            $table->string('account_type', 16)->default('BUYER')->index();
            $table->string('account_status', 24)->default('PENDING_VERIFICATION')->index();
            $table->timestampTz('last_authenticated_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });

        $this->identityAndAuthorization();
        $this->vendorsAndBuyers();
        $this->catalogAndInventory();
        $this->procurementAndCommerce();
        $this->trustGeographyAndOperations();
        $this->addPostgresChecksAndIndexes();
    }

    private function identityAndAuthorization(): void
    {
        $this->entity('user_profiles', function (Blueprint $table): void {
            $table->foreignId('user_id')->unique()->constrained()->restrictOnDelete();
            $table->string('full_name');
            $table->string('mobile_e164', 20)->nullable();
            $table->string('locale', 12)->default('en');
        });

        $this->entity('external_identities', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('provider', 32);
            $table->string('provider_subject');
            $table->string('email_at_link')->nullable();
            $table->timestampTz('linked_at');
            $table->unique(['provider', 'provider_subject']);
        });

        $this->entity('email_otps', function (Blueprint $table): void {
            $table->foreignId('user_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('normalized_email');
            $table->string('purpose', 32);
            $table->string('code_hash');
            $table->unsignedSmallInteger('attempts')->default(0);
            $table->unsignedSmallInteger('max_attempts')->default(5);
            $table->timestampTz('expires_at');
            $table->timestampTz('consumed_at')->nullable();
            $table->timestampTz('invalidated_at')->nullable();
            $table->index(['normalized_email', 'purpose', 'expires_at']);
        });

        $this->entity('auth_sessions', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->uuid('family_id')->index();
            $table->uuid('device_id')->nullable()->index();
            $table->string('refresh_token_hash');
            $table->string('previous_refresh_token_hash')->nullable();
            $table->string('oauth_access_token_id', 100)->nullable()->index();
            $table->string('client_kind', 16);
            $table->string('ip_address', 45)->nullable();
            $table->string('user_agent_hash')->nullable();
            $table->timestampTz('last_used_at');
            $table->timestampTz('expires_at');
            $table->timestampTz('revoked_at')->nullable();
            $table->string('revoke_reason', 64)->nullable();
            $table->unique('refresh_token_hash');
            $table->index(['user_id', 'revoked_at', 'expires_at']);
        });

        $this->entity('trusted_devices', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->uuid('device_id');
            $table->string('device_name')->nullable();
            $table->string('fingerprint_hash');
            $table->timestampTz('trusted_until');
            $table->timestampTz('revoked_at')->nullable();
            $table->unique(['user_id', 'device_id']);
        });

        $this->entity('auth_refresh_token_history', function (Blueprint $table): void {
            $table->foreignUuid('auth_session_id')->constrained()->restrictOnDelete();
            $table->uuid('family_id')->index();
            $table->string('token_hash')->unique();
            $table->timestampTz('rotated_at');
            $table->timestampTz('reuse_detected_at')->nullable();
        });

        $this->entity('totp_factors', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->text('encrypted_secret');
            $table->timestampTz('confirmed_at')->nullable();
            $table->timestampTz('last_used_at')->nullable();
            $table->unsignedBigInteger('last_used_counter')->nullable();
            $table->timestampTz('revoked_at')->nullable();
            $table->unique('user_id');
        });

        $this->entity('recovery_codes', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('code_hash');
            $table->timestampTz('used_at')->nullable();
            $table->unique(['user_id', 'code_hash']);
        });

        $this->entity('login_events', function (Blueprint $table): void {
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('normalized_email_hash')->nullable();
            $table->string('event_type', 48);
            $table->boolean('succeeded');
            $table->string('ip_address', 45)->nullable();
            $table->string('correlation_id', 64)->index();
            $table->jsonb('safe_context')->nullable();
            $table->index(['event_type', 'created_at']);
        });

        $this->entity('agreement_documents', function (Blueprint $table): void {
            $table->string('code', 64)->unique();
            $table->string('audience', 24);
            $table->string('title');
        });
        $this->entity('agreement_versions', function (Blueprint $table): void {
            $table->foreignUuid('agreement_document_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->string('content_hash');
            $table->string('content_uri');
            $table->timestampTz('effective_at');
            $table->timestampTz('retired_at')->nullable();
            $table->unique(['agreement_document_id', 'version']);
        });
        $this->entity('agreement_acceptances', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('agreement_version_id')->constrained()->restrictOnDelete();
            $table->uuid('vendor_organization_id')->nullable();
            $table->string('source', 32);
            $table->timestampTz('accepted_at');
            $table->unique(['user_id', 'agreement_version_id', 'vendor_organization_id']);
        });

        $this->entity('platform_roles', function (Blueprint $table): void {
            $table->string('code', 64)->unique();
            $table->string('platform', 16);
            $table->string('name');
            $table->boolean('system_role')->default(true);
        });
        $this->entity('permissions', function (Blueprint $table): void {
            $table->string('code', 96)->unique();
            $table->string('description');
        });
        $this->entity('role_permissions', function (Blueprint $table): void {
            $table->foreignUuid('platform_role_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('permission_id')->constrained()->restrictOnDelete();
            $table->unique(['platform_role_id', 'permission_id']);
        });
        $this->entity('admin_memberships', function (Blueprint $table): void {
            $table->foreignId('user_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('platform_role_id')->constrained()->restrictOnDelete();
            $table->string('status', 24)->default('PENDING');
            $table->foreignId('invited_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('activated_at')->nullable();
            $table->timestampTz('deactivated_at')->nullable();
        });
        $this->entity('admin_invitations', function (Blueprint $table): void {
            $table->string('normalized_email')->index();
            $table->foreignUuid('platform_role_id')->constrained()->restrictOnDelete();
            $table->foreignId('invited_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('token_hash')->unique();
            $table->timestampTz('expires_at');
            $table->timestampTz('accepted_at')->nullable();
            $table->boolean('bootstrap')->default(false);
        });
    }

    private function vendorsAndBuyers(): void
    {
        $this->entity('vendor_organizations', function (Blueprint $table): void {
            $table->string('legal_name');
            $table->string('store_name');
            $table->string('account_status', 24)->default('ACTIVE');
            $table->string('onboarding_status', 32)->default('NOT_STARTED');
            $table->string('marketplace_status', 24)->default('NOT_ACTIVE')->index();
            $table->boolean('bulk_order_capable')->default(false);
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('agreement_acceptances', function (Blueprint $table): void {
            $table->foreign('vendor_organization_id')->references('id')->on('vendor_organizations')->restrictOnDelete();
        });
        $this->entity('vendor_memberships', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->unique()->constrained()->restrictOnDelete();
            $table->string('role', 32);
            $table->boolean('can_manage_staff')->default(false);
            $table->string('status', 24)->default('ACTIVE');
            $table->timestampTz('activated_at')->nullable();
            $table->timestampTz('deactivated_at')->nullable();
            $table->index(['vendor_organization_id', 'role', 'status']);
        });
        $this->entity('vendor_invitations', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('invited_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('normalized_email');
            $table->string('role', 32);
            $table->boolean('can_manage_staff')->default(false);
            $table->string('token_hash')->unique();
            $table->timestampTz('expires_at');
            $table->timestampTz('accepted_at')->nullable();
        });
        $this->entity('vendor_contacts', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('full_name');
            $table->string('position')->nullable();
            $table->string('email')->nullable();
            $table->string('telephone_e164', 20)->nullable();
            $table->boolean('authorized_representative')->default(false);
        });
        $this->entity('vendor_classifications', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('classification', 64);
            $table->unique(['vendor_organization_id', 'classification']);
        });
        $this->entity('vendor_onboarding_steps', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('step_code', 64);
            $table->string('status', 32)->default('REQUIRED');
            $table->timestampTz('completed_at')->nullable();
            $table->unique(['vendor_organization_id', 'step_code']);
        });
        $this->entity('vendor_activation_history', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('from_status', 24)->nullable();
            $table->string('to_status', 24);
            $table->text('reason')->nullable();
        });
        $this->entity('addresses', function (Blueprint $table): void {
            $table->string('owner_type', 32);
            $table->uuid('owner_id');
            $table->string('label')->nullable();
            $table->text('formatted_address');
            $table->string('psgc_code', 16)->nullable()->index();
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();
            $table->text('geography_wkt')->nullable();
            $table->boolean('verified')->default(false);
            $table->index(['owner_type', 'owner_id']);
        });
        $this->entity('store_profiles', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('address_id')->nullable()->constrained('addresses')->restrictOnDelete();
            $table->text('description')->nullable();
            $table->string('public_email')->nullable();
            $table->string('public_phone', 20)->nullable();
            $table->boolean('pickup_enabled')->default(false);
            $table->boolean('delivery_enabled')->default(false);
        });
        $this->entity('store_media', function (Blueprint $table): void {
            $table->foreignUuid('store_profile_id')->constrained()->restrictOnDelete();
            $table->uuid('file_id')->nullable();
            $table->string('kind', 24);
            $table->string('alt_text')->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
        });
        $this->entity('operating_hours', function (Blueprint $table): void {
            $table->foreignUuid('store_profile_id')->constrained()->restrictOnDelete();
            $table->unsignedTinyInteger('weekday');
            $table->time('opens_at')->nullable();
            $table->time('closes_at')->nullable();
            $table->boolean('closed')->default(false);
            $table->unique(['store_profile_id', 'weekday']);
        });
        $this->entity('delivery_service_areas', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('origin_address_id')->constrained('addresses')->restrictOnDelete();
            $table->unsignedSmallInteger('radius_km');
            $table->unique(['vendor_organization_id', 'origin_address_id', 'radius_km']);
        });
        $this->entity('business_documents', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('document_type', 48);
            $table->uuid('current_version_id')->nullable();
            $table->string('status', 32)->default('PENDING_VERIFICATION')->index();
        });
        $this->entity('business_document_versions', function (Blueprint $table): void {
            $table->foreignUuid('business_document_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->uuid('file_id');
            $table->string('document_number_masked')->nullable();
            $table->date('issued_on')->nullable();
            $table->date('expires_on')->nullable();
            $table->boolean('expiry_not_applicable')->default(false);
            $table->string('content_hash');
            $table->unique(['business_document_id', 'version']);
        });
        Schema::table('business_documents', function (Blueprint $table): void {
            $table->foreign('current_version_id')->references('id')->on('business_document_versions')->restrictOnDelete();
        });
        $this->entity('business_document_reviews', function (Blueprint $table): void {
            $table->foreignUuid('business_document_version_id')->constrained()->restrictOnDelete();
            $table->foreignId('reviewer_user_id')->constrained('users')->restrictOnDelete();
            $table->string('decision', 32);
            $table->text('reason')->nullable();
            $table->string('source_reference')->nullable();
        });
        $this->entity('vendor_payment_accounts', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('provider', 32)->default('XENDIT');
            $table->string('provider_account_reference')->nullable();
            $table->string('status', 32)->default('NOT_CONNECTED');
            $table->jsonb('capabilities')->nullable();
        });
        $this->entity('buyer_profiles', function (Blueprint $table): void {
            $table->foreignId('user_id')->unique()->constrained()->restrictOnDelete();
            $table->string('buyer_type', 32);
            $table->string('company_name')->nullable();
        });
        $this->entity('buyer_locations', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('address_id')->constrained('addresses')->restrictOnDelete();
            $table->boolean('is_primary')->default(false);
            $table->unique(['buyer_profile_id', 'address_id']);
        });
        $this->entity('favorite_vendors', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->unique(['buyer_profile_id', 'vendor_organization_id']);
        });
        $this->entity('buyer_ranking_preferences', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->string('procurement_type', 24);
            $table->jsonb('weights');
            $table->unsignedInteger('version')->default(1);
            $table->unique(['buyer_profile_id', 'procurement_type']);
        });
    }

    private function catalogAndInventory(): void
    {
        $this->entity('material_categories', function (Blueprint $table): void {
            $table->string('code', 64)->unique();
            $table->string('name');
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->boolean('active')->default(true);
        });
        $this->entity('units', function (Blueprint $table): void {
            $table->string('code', 24)->unique();
            $table->string('name');
            $table->string('dimension', 32);
            $table->unsignedSmallInteger('precision')->default(4);
        });
        $this->entity('materials', function (Blueprint $table): void {
            $table->foreignUuid('material_category_id')->constrained()->restrictOnDelete();
            $table->string('code', 64)->unique();
            $table->string('name');
            $table->text('description')->nullable();
            $table->foreignUuid('canonical_unit_id')->constrained('units')->restrictOnDelete();
            $table->boolean('regulated')->default(false);
            $table->boolean('active')->default(true);
        });
        $this->entity('material_aliases', function (Blueprint $table): void {
            $table->foreignUuid('material_id')->constrained()->restrictOnDelete();
            $table->string('normalized_alias');
            $table->unique(['material_id', 'normalized_alias']);
        });
        $this->entity('unit_conversions', function (Blueprint $table): void {
            $table->foreignUuid('material_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('from_unit_id')->constrained('units')->restrictOnDelete();
            $table->foreignUuid('to_unit_id')->constrained('units')->restrictOnDelete();
            $table->decimal('multiplier', 20, 8);
            $table->unsignedInteger('version')->default(1);
            $table->foreignId('approved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->unique(['material_id', 'from_unit_id', 'to_unit_id', 'version']);
        });
        $this->entity('material_tags', function (Blueprint $table): void {
            $table->string('code', 64)->unique();
            $table->string('name');
        });
        $this->entity('material_tag_links', function (Blueprint $table): void {
            $table->foreignUuid('material_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('material_tag_id')->constrained()->restrictOnDelete();
            $table->unique(['material_id', 'material_tag_id']);
        });
        $this->entity('technical_attribute_definitions', function (Blueprint $table): void {
            $table->foreignUuid('material_category_id')->constrained()->restrictOnDelete();
            $table->string('code', 64);
            $table->string('label');
            $table->string('value_type', 24);
            $table->boolean('required')->default(false);
            $table->unique(['material_category_id', 'code']);
        });
        $this->entity('regulated_material_rules', function (Blueprint $table): void {
            $table->foreignUuid('material_id')->constrained()->restrictOnDelete();
            $table->string('required_marking', 24);
            $table->string('source_reference');
            $table->date('effective_from');
            $table->date('effective_to')->nullable();
            $table->unsignedInteger('version');
            $table->unique(['material_id', 'version']);
        });

        Schema::table('products', function (Blueprint $table): void {
            $table->uuid('public_id')->nullable()->unique();
            $table->uuid('material_id')->nullable();
            $table->string('brand')->nullable();
            $table->string('manufacturer')->nullable();
            $table->string('country_of_manufacture', 2)->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->foreign('material_id')->references('id')->on('materials')->restrictOnDelete();
        });
        $this->entity('vendor_listings', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('product_id')->constrained()->restrictOnDelete();
            $table->string('vendor_sku', 96);
            $table->string('display_name');
            $table->string('status', 48)->default('DRAFT')->index();
            $table->boolean('ordinary_public_price_available')->default(false);
            $table->unsignedInteger('lock_version')->default(1);
            $table->unique(['vendor_organization_id', 'vendor_sku']);
        });
        $this->entity('listing_variants', function (Blueprint $table): void {
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->string('sku', 96);
            $table->foreignUuid('unit_id')->constrained('units')->restrictOnDelete();
            $table->jsonb('attributes')->nullable();
            $table->decimal('pack_quantity', 18, 4)->default(1);
            $table->boolean('active')->default(true);
            $table->unique(['vendor_listing_id', 'sku']);
        });
        $this->entity('listing_media', function (Blueprint $table): void {
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->uuid('file_id');
            $table->string('alt_text')->nullable();
            $table->unsignedSmallInteger('sort_order')->default(0);
        });
        $this->entity('listing_price_versions', function (Blueprint $table): void {
            $table->foreignUuid('listing_variant_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->bigInteger('amount_centavos');
            $table->char('currency', 3)->default('PHP');
            $table->string('tax_category', 16);
            $table->timestampTz('effective_at');
            $table->timestampTz('retired_at')->nullable();
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->unique(['listing_variant_id', 'version']);
            $table->index(['listing_variant_id', 'effective_at']);
        });
        $this->entity('listing_status_history', function (Blueprint $table): void {
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->string('from_status', 48)->nullable();
            $table->string('to_status', 48);
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->text('reason')->nullable();
        });

        $this->entity('compliance_submissions', function (Blueprint $table): void {
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->string('path', 16);
            $table->string('status', 32)->default('PENDING_ADMIN_REVIEW')->index();
            $table->unsignedInteger('version')->default(1);
        });
        foreach (['compliance_evidence', 'compliance_extractions', 'compliance_reference_matches', 'compliance_reviews'] as $name) {
            $this->entity($name, function (Blueprint $table) use ($name): void {
                $table->foreignUuid('compliance_submission_id')->constrained()->restrictOnDelete();
                $table->jsonb('payload')->nullable();
                if ($name === 'compliance_reviews') {
                    $table->foreignId('reviewer_user_id')->nullable()->constrained('users')->restrictOnDelete();
                    $table->string('decision', 32)->nullable();
                }
            });
        }
        $this->entity('inventory_items', function (Blueprint $table): void {
            $table->foreignUuid('listing_variant_id')->unique()->constrained()->restrictOnDelete();
            $table->decimal('quantity_on_hand', 18, 4)->default(0);
            $table->decimal('hard_reserved_quantity', 18, 4)->default(0);
            $table->decimal('soft_held_quantity', 18, 4)->default(0);
            $table->timestampTz('confirmed_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        $this->entity('inventory_movements', function (Blueprint $table): void {
            $table->foreignUuid('inventory_item_id')->constrained()->restrictOnDelete();
            $table->string('movement_type', 32);
            $table->decimal('quantity', 18, 4);
            $table->decimal('quantity_on_hand_after', 18, 4);
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('source_type', 32);
            $table->uuid('source_id')->nullable();
        });
        $this->entity('inventory_holds', function (Blueprint $table): void {
            $table->foreignUuid('inventory_item_id')->constrained()->restrictOnDelete();
            $table->string('hold_type', 8);
            $table->decimal('quantity', 18, 4);
            $table->string('state', 16)->default('ACTIVE');
            $table->string('source_type', 24);
            $table->uuid('source_id');
            $table->timestampTz('expires_at')->nullable();
            $table->timestampTz('released_at')->nullable();
            $table->unique(['source_type', 'source_id', 'inventory_item_id', 'hold_type']);
        });
        $this->entity('auto_accept_policies', function (Blueprint $table): void {
            $table->foreignUuid('listing_variant_id')->unique()->constrained()->restrictOnDelete();
            $table->boolean('enabled')->default(false);
            $table->boolean('paused')->default(true);
            $table->unsignedInteger('current_version')->default(1);
            $table->unsignedInteger('lock_version')->default(1);
        });
        $this->entity('auto_accept_policy_versions', function (Blueprint $table): void {
            $table->foreignUuid('auto_accept_policy_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->decimal('allotment_quantity', 18, 4);
            $table->decimal('remaining_allotment_quantity', 18, 4);
            $table->decimal('max_unit_count', 18, 4)->nullable();
            $table->bigInteger('max_order_amount_centavos')->nullable();
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->unique(['auto_accept_policy_id', 'version']);
        });
        $this->entity('stock_confirmation_events', function (Blueprint $table): void {
            $table->foreignUuid('inventory_item_id')->constrained()->restrictOnDelete();
            $table->foreignId('actor_user_id')->constrained('users')->restrictOnDelete();
            $table->decimal('confirmed_quantity', 18, 4);
            $table->timestampTz('confirmed_at');
        });
        $this->entity('vendor_vehicles', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('vehicle_type', 32);
            $table->string('name');
            $table->decimal('capacity_kg', 18, 4);
            $table->unsignedSmallInteger('number_available');
            $table->boolean('active')->default(true);
        });
        $this->entity('vehicle_rate_versions', function (Blueprint $table): void {
            $table->foreignUuid('vendor_vehicle_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->bigInteger('base_fee_centavos');
            $table->bigInteger('per_km_centavos');
            $table->unsignedSmallInteger('maximum_distance_km');
            $table->timestampTz('effective_at');
            $table->unique(['vendor_vehicle_id', 'version']);
        });
        $this->entity('delivery_quotes', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vehicle_rate_version_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('distance_meters');
            $table->unsignedSmallInteger('trip_count');
            $table->bigInteger('amount_centavos');
            $table->timestampTz('expires_at');
        });
        $this->entity('delivery_assignments', function (Blueprint $table): void {
            $table->foreignUuid('delivery_quote_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_vehicle_id')->constrained()->restrictOnDelete();
            $table->foreignId('assigned_by_user_id')->constrained('users')->restrictOnDelete();
            $table->unsignedSmallInteger('trip_number');
            $table->unique(['delivery_quote_id', 'trip_number']);
        });
    }

    private function procurementAndCommerce(): void
    {
        $this->entity('carts', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->string('state', 16)->default('ACTIVE');
            $table->unsignedInteger('lock_version')->default(1);
        });
        $this->entity('cart_items', function (Blueprint $table): void {
            $table->foreignUuid('cart_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->constrained()->restrictOnDelete();
            $table->decimal('quantity', 18, 4);
            $table->uuid('listing_price_version_id')->nullable();
            $table->unique(['cart_id', 'listing_variant_id']);
        });
        $this->entity('checkout_groups', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->string('reference', 48)->unique();
            $table->string('state', 24);
            $table->string('idempotency_key')->unique();
        });
        $this->entity('checkout_vendor_groups', function (Blueprint $table): void {
            $table->foreignUuid('checkout_group_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->uuid('order_id')->nullable();
            $table->unique(['checkout_group_id', 'vendor_organization_id']);
        });
        $this->entity('projects', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->string('name');
            $table->string('status', 16)->default('ACTIVE');
            $table->bigInteger('budget_centavos');
            $table->date('starts_on')->nullable();
            $table->date('ends_on')->nullable();
        });
        $this->entity('project_sites', function (Blueprint $table): void {
            $table->foreignUuid('project_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('address_id')->constrained('addresses')->restrictOnDelete();
            $table->boolean('active')->default(true);
            $table->unique(['project_id', 'address_id']);
        });
        $this->entity('work_packages', function (Blueprint $table): void {
            $table->foreignUuid('project_id')->constrained()->restrictOnDelete();
            $table->string('name');
            $table->string('status', 32)->default('DRAFT');
            $table->bigInteger('budget_centavos');
            $table->uuid('selected_vendor_organization_id')->nullable();
            $table->uuid('current_version_id')->nullable();
        });
        $this->entity('work_package_versions', function (Blueprint $table): void {
            $table->foreignUuid('work_package_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->string('content_hash');
            $table->timestampTz('locked_at')->nullable();
            $table->unique(['work_package_id', 'version']);
        });
        Schema::table('work_packages', function (Blueprint $table): void {
            $table->foreign('selected_vendor_organization_id')->references('id')->on('vendor_organizations')->restrictOnDelete();
            $table->foreign('current_version_id')->references('id')->on('work_package_versions')->restrictOnDelete();
        });
        $this->entity('work_package_lines', function (Blueprint $table): void {
            $table->foreignUuid('work_package_version_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('material_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('unit_id')->constrained('units')->restrictOnDelete();
            $table->decimal('quantity', 18, 4);
            $table->jsonb('specifications')->nullable();
        });
        $this->entity('compiled_estimates', function (Blueprint $table): void {
            $table->foreignUuid('work_package_version_id')->constrained()->restrictOnDelete();
            $table->timestampTz('expires_at');
            $table->string('state', 24)->default('ACTIVE');
        });
        $this->entity('compiled_estimate_vendors', function (Blueprint $table): void {
            $table->foreignUuid('compiled_estimate_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->decimal('fms', 5, 2);
            $table->bigInteger('projected_total_centavos');
            $table->unique(['compiled_estimate_id', 'vendor_organization_id']);
        });
        $this->entity('compiled_estimate_lines', function (Blueprint $table): void {
            $table->foreignUuid('compiled_estimate_vendor_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('work_package_line_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->nullable()->constrained()->restrictOnDelete();
            $table->decimal('matched_quantity', 18, 4)->default(0);
            $table->bigInteger('amount_centavos')->nullable();
        });
        $this->entity('budget_overrides', function (Blueprint $table): void {
            $table->foreignUuid('project_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('work_package_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignId('buyer_user_id')->constrained('users')->restrictOnDelete();
            $table->bigInteger('overage_centavos');
            $table->text('reason');
        });

        $this->entity('conversations', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('context_type', 24);
            $table->uuid('context_id')->nullable();
            $table->string('state', 16)->default('ACTIVE');
        });
        $this->entity('conversation_participants', function (Blueprint $table): void {
            $table->foreignUuid('conversation_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('participant_role', 32);
            $table->unique(['conversation_id', 'user_id']);
        });
        $this->entity('conversation_assignments', function (Blueprint $table): void {
            $table->foreignUuid('conversation_id')->constrained()->restrictOnDelete();
            $table->foreignId('assigned_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('assigned_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('ended_at')->nullable();
        });
        $this->entity('messages', function (Blueprint $table): void {
            $table->foreignUuid('conversation_id')->constrained()->restrictOnDelete();
            $table->foreignId('sender_user_id')->constrained('users')->restrictOnDelete();
            $table->uuid('client_message_id');
            $table->text('body');
            $table->timestampTz('sent_at');
            $table->unique(['conversation_id', 'client_message_id']);
        });
        $this->entity('message_attachments', function (Blueprint $table): void {
            $table->foreignUuid('message_id')->constrained()->restrictOnDelete();
            $table->uuid('file_id');
            $table->string('scan_state', 24);
        });
        $this->entity('message_read_receipts', function (Blueprint $table): void {
            $table->foreignUuid('message_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->timestampTz('read_at');
            $table->unique(['message_id', 'user_id']);
        });

        $this->entity('quotations', function (Blueprint $table): void {
            $table->foreignUuid('conversation_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('work_package_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('procurement_type', 24);
            $table->string('state', 32)->default('DRAFT');
            $table->uuid('current_version_id')->nullable();
            $table->uuid('accepted_order_id')->nullable();
        });
        $this->entity('quotation_versions', function (Blueprint $table): void {
            $table->foreignUuid('quotation_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('published_at')->nullable();
            $table->timestampTz('expires_at')->nullable();
            $table->uuid('supersedes_version_id')->nullable();
            $table->bigInteger('materials_centavos')->default(0);
            $table->bigInteger('delivery_centavos')->default(0);
            $table->bigInteger('nrpc_centavos')->default(0);
            $table->bigInteger('total_centavos')->default(0);
            $table->string('content_hash');
            $table->unique(['quotation_id', 'version']);
        });
        Schema::table('quotation_versions', function (Blueprint $table): void {
            $table->foreign('supersedes_version_id')->references('id')->on('quotation_versions')->restrictOnDelete();
        });
        Schema::table('quotations', function (Blueprint $table): void {
            $table->foreign('current_version_id')->references('id')->on('quotation_versions')->restrictOnDelete();
        });
        $this->entity('quotation_lines', function (Blueprint $table): void {
            $table->foreignUuid('quotation_version_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('description');
            $table->foreignUuid('unit_id')->constrained('units')->restrictOnDelete();
            $table->decimal('quantity', 18, 4);
            $table->bigInteger('unit_price_centavos');
            $table->bigInteger('subtotal_centavos');
            $table->boolean('substitution')->default(false);
        });
        foreach (['quotation_changes', 'quotation_counter_offers', 'quotation_events'] as $name) {
            $this->entity($name, function (Blueprint $table) use ($name): void {
                $table->foreignUuid('quotation_id')->constrained()->restrictOnDelete();
                $table->foreignUuid('quotation_version_id')->nullable()->constrained()->restrictOnDelete();
                $table->foreignId('actor_user_id')->constrained('users')->restrictOnDelete();
                $table->string('event_type', 48)->nullable();
                $table->jsonb('payload');
                if ($name === 'quotation_counter_offers') {
                    $table->string('state', 24)->default('OPEN');
                }
            });
        }

        $this->entity('orders', function (Blueprint $table): void {
            $table->string('reference', 48)->unique();
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('checkout_group_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('work_package_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('quotation_version_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('procurement_type', 24);
            $table->string('order_state', 40)->index();
            $table->string('payment_state', 24)->default('NOT_REQUIRED');
            $table->string('refund_state', 24)->default('NOT_REQUESTED');
            $table->string('fulfillment_method', 24);
            $table->string('payment_method', 24);
            $table->bigInteger('commercial_total_centavos');
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('checkout_vendor_groups', function (Blueprint $table): void {
            $table->foreign('order_id')->references('id')->on('orders')->restrictOnDelete();
        });
        Schema::table('quotations', function (Blueprint $table): void {
            $table->foreign('accepted_order_id')->references('id')->on('orders')->restrictOnDelete();
        });
        $this->entity('order_lines', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('unit_id')->constrained('units')->restrictOnDelete();
            $table->decimal('quantity', 18, 4);
            $table->bigInteger('unit_price_centavos');
            $table->bigInteger('discount_centavos')->default(0);
            $table->bigInteger('included_vat_centavos')->default(0);
            $table->bigInteger('payable_centavos');
            $table->string('tax_category', 16);
        });
        $this->entity('order_snapshots', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->jsonb('snapshot');
            $table->string('content_hash');
            $table->unique(['order_id', 'version']);
        });
        $this->entity('order_status_history', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->string('from_state', 40)->nullable();
            $table->string('to_state', 40);
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->text('reason')->nullable();
            $table->string('correlation_id', 64)->index();
        });
        foreach (['vendor_confirmations', 'nrpc_records', 'nrpc_acceptances', 'cancellation_requests', 'cancellation_decisions'] as $name) {
            $this->entity($name, function (Blueprint $table) use ($name): void {
                $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
                $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
                $table->string('state', 32)->nullable();
                $table->text('reason')->nullable();
                $table->jsonb('payload')->nullable();
                if ($name === 'nrpc_records') {
                    $table->bigInteger('amount_centavos')->default(0);
                }
            });
        }
    }

    private function trustGeographyAndOperations(): void
    {
        $this->entity('payments', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->uuid('fee_statement_id')->nullable();
            $table->string('purpose', 32);
            $table->string('environment', 8)->default('TEST');
            $table->string('provider', 24)->default('XENDIT');
            $table->string('provider_reference')->nullable()->unique();
            $table->bigInteger('principal_centavos');
            $table->bigInteger('processing_fee_centavos')->default(0);
            $table->bigInteger('total_centavos');
            $table->char('currency', 3)->default('PHP');
            $table->string('state', 24)->default('PENDING');
            $table->string('idempotency_key')->unique();
            $table->timestampTz('expires_at')->nullable();
        });
        foreach (['payment_attempts', 'payment_events'] as $name) {
            $this->entity($name, function (Blueprint $table): void {
                $table->foreignUuid('payment_id')->constrained()->restrictOnDelete();
                $table->string('provider_event_id')->nullable()->unique();
                $table->string('state', 24);
                $table->jsonb('safe_payload')->nullable();
            });
        }

        $this->entity('files', function (Blueprint $table): void {
            $table->string('owner_type', 32);
            $table->uuid('owner_id');
            $table->string('purpose', 48);
            $table->string('visibility', 16)->default('PRIVATE');
            $table->string('content_type', 128);
            $table->unsignedBigInteger('byte_size');
            $table->string('checksum_sha256', 64);
            $table->string('scan_state', 24)->default('PENDING');
            $table->string('object_key')->unique();
            $table->string('retention_class', 32);
            $table->index(['owner_type', 'owner_id']);
        });
        Schema::table('store_media', fn (Blueprint $table) => $table->foreign('file_id')->references('id')->on('files')->restrictOnDelete());
        Schema::table('business_document_versions', fn (Blueprint $table) => $table->foreign('file_id')->references('id')->on('files')->restrictOnDelete());
        Schema::table('listing_media', fn (Blueprint $table) => $table->foreign('file_id')->references('id')->on('files')->restrictOnDelete());
        Schema::table('message_attachments', fn (Blueprint $table) => $table->foreign('file_id')->references('id')->on('files')->restrictOnDelete());

        $this->entity('physical_payment_records', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignId('recorded_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('record_kind', 24)->default('COLLECTION');
            $table->string('method', 24);
            $table->bigInteger('obligation_before_centavos');
            $table->bigInteger('amount_centavos');
            $table->bigInteger('remaining_obligation_centavos');
            $table->string('state', 32);
            $table->foreignUuid('evidence_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->uuid('original_record_id')->nullable();
            $table->text('correction_reason')->nullable();
            $table->string('idempotency_key')->unique();
            $table->timestampTz('recorded_at');
            $table->timestampTz('buyer_acknowledged_at')->nullable();
        });
        Schema::table('physical_payment_records', function (Blueprint $table): void {
            $table->foreign('original_record_id')->references('id')->on('physical_payment_records')->restrictOnDelete();
        });
        $this->entity('processing_fee_snapshots', function (Blueprint $table): void {
            $table->foreignUuid('payment_id')->unique()->constrained()->restrictOnDelete();
            $table->string('channel', 32);
            $table->bigInteger('quoted_centavos');
            $table->jsonb('calculation');
            $table->string('policy_version');
        });
        $this->entity('refunds', function (Blueprint $table): void {
            $table->string('target_type', 24)->default('ORDER');
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->uuid('fee_statement_id')->nullable();
            $table->foreignUuid('source_payment_id')->constrained('payments')->restrictOnDelete();
            $table->uuid('fee_adjustment_id')->nullable();
            $table->string('trigger', 32);
            $table->bigInteger('amount_centavos');
            $table->bigInteger('source_captured_centavos');
            $table->bigInteger('prior_allocated_centavos')->default(0);
            $table->string('state', 24)->default('REFUND_PENDING');
            $table->string('idempotency_key')->unique();
            $table->string('provider_reference')->nullable()->unique();
        });
        foreach (['refund_attempts', 'refund_events'] as $name) {
            $this->entity($name, function (Blueprint $table): void {
                $table->foreignUuid('refund_id')->constrained()->restrictOnDelete();
                $table->string('provider_event_id')->nullable()->unique();
                $table->string('state', 24);
                $table->jsonb('safe_payload')->nullable();
            });
        }
        $this->entity('fulfillments', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->unique()->constrained()->restrictOnDelete();
            $table->string('state', 32);
            $table->timestampTz('expected_at')->nullable();
            $table->timestampTz('completed_at')->nullable();
        });
        foreach (['fulfillment_milestones', 'fulfillment_proofs', 'pickup_authorizations', 'no_show_events'] as $name) {
            $this->entity($name, function (Blueprint $table): void {
                $table->foreignUuid('fulfillment_id')->constrained()->restrictOnDelete();
                $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
                $table->string('event_type', 40)->nullable();
                $table->jsonb('payload')->nullable();
                $table->timestampTz('occurred_at')->nullable();
            });
        }
        $this->entity('dispute_cases', function (Blueprint $table): void {
            $table->string('reference', 48)->unique();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->string('status', 40)->index();
            $table->string('issue_type', 48);
            $table->string('requested_remedy', 48);
            $table->timestampTz('response_due_at');
        });
        foreach (['dispute_parties', 'dispute_evidence', 'dispute_responses', 'dispute_clarifications', 'dispute_decisions', 'dispute_appeals', 'dispute_remedies'] as $name) {
            $this->entity($name, function (Blueprint $table) use ($name): void {
                $table->foreignUuid('dispute_case_id')->constrained()->restrictOnDelete();
                $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
                $table->string('state', 32)->nullable();
                $table->jsonb('payload')->nullable();
                if ($name === 'dispute_decisions') {
                    $table->bigInteger('awarded_centavos')->default(0);
                    $table->boolean('enforceable')->default(false);
                }
            });
        }
        $this->entity('reviews', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignId('reviewer_user_id')->constrained('users')->restrictOnDelete();
            $table->string('review_type', 24);
            $table->uuid('order_line_id')->nullable();
            $table->unsignedTinyInteger('rating');
            $table->text('comment')->nullable();
            $table->timestampTz('revealed_at')->nullable();
            $table->unique(['order_id', 'reviewer_user_id', 'review_type', 'order_line_id']);
        });
        foreach (['review_media', 'review_moderation'] as $name) {
            $this->entity($name, function (Blueprint $table): void {
                $table->foreignUuid('review_id')->constrained()->restrictOnDelete();
                $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
                $table->jsonb('payload')->nullable();
            });
        }
        $this->entity('metric_events', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('metric', 24);
            $table->uuid('source_id');
            $table->decimal('value', 12, 4);
            $table->unique(['metric', 'source_id']);
        });
        $this->entity('score_snapshots', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->date('window_ends_on');
            $table->decimal('vcs', 4, 2)->nullable();
            $table->decimal('mqs', 4, 2)->nullable();
            $table->decimal('ohs', 4, 2)->nullable();
            $table->decimal('vps', 4, 2)->nullable();
            $table->jsonb('sample_counts');
            $table->unique(['vendor_organization_id', 'window_ends_on']);
        });
        $this->entity('badge_definitions', function (Blueprint $table): void {
            $table->string('code', 48)->unique();
            $table->string('name');
            $table->jsonb('rule');
            $table->unsignedInteger('version');
        });
        $this->entity('vendor_badge_history', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('badge_definition_id')->constrained()->restrictOnDelete();
            $table->timestampTz('earned_at');
            $table->timestampTz('revoked_at')->nullable();
        });

        $this->entity('psgc_versions', function (Blueprint $table): void {
            $table->string('version', 32)->unique();
            $table->date('effective_on');
            $table->string('source_reference');
        });
        $this->entity('psgc_areas', function (Blueprint $table): void {
            $table->foreignUuid('psgc_version_id')->constrained()->restrictOnDelete();
            $table->string('code', 16);
            $table->string('name');
            $table->string('level', 24);
            $table->uuid('parent_id')->nullable();
            $table->unique(['psgc_version_id', 'code']);
        });
        Schema::table('psgc_areas', function (Blueprint $table): void {
            $table->foreign('parent_id')->references('id')->on('psgc_areas')->restrictOnDelete();
        });
        $this->entity('psgc_boundaries', function (Blueprint $table): void {
            $table->foreignUuid('psgc_area_id')->constrained()->restrictOnDelete();
            $table->text('geometry_wkt');
            $table->string('content_hash');
            $table->unique('psgc_area_id');
        });
        $this->entity('directory_suppliers', function (Blueprint $table): void {
            $table->string('google_place_id')->unique();
            $table->string('name');
            $table->text('formatted_address')->nullable();
            $table->decimal('latitude', 10, 7);
            $table->decimal('longitude', 10, 7);
            $table->uuid('claimed_vendor_organization_id')->nullable();
            $table->timestampTz('refreshed_at');
            $table->foreign('claimed_vendor_organization_id')->references('id')->on('vendor_organizations')->restrictOnDelete();
        });
        foreach (['place_cache_entries', 'route_cache_entries'] as $name) {
            $this->entity($name, function (Blueprint $table): void {
                $table->string('cache_key_hash')->unique();
                $table->jsonb('payload');
                $table->timestampTz('expires_at');
                $table->string('provider', 24)->default('GOOGLE');
            });
        }

        $this->entity('notifications', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('category', 32);
            $table->string('title');
            $table->text('body');
            $table->string('resource_type', 32)->nullable();
            $table->uuid('resource_id')->nullable();
            $table->timestampTz('read_at')->nullable();
            $table->index(['user_id', 'read_at', 'created_at']);
        });
        $this->entity('notification_deliveries', function (Blueprint $table): void {
            $table->foreignUuid('notification_id')->constrained()->restrictOnDelete();
            $table->string('channel', 16);
            $table->string('state', 24);
            $table->unsignedSmallInteger('attempt_count')->default(0);
            $table->timestampTz('delivered_at')->nullable();
        });
        $this->entity('notification_preferences', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('category', 32);
            $table->boolean('in_app')->default(true);
            $table->boolean('email')->default(true);
            $table->boolean('push')->default(true);
            $table->unique(['user_id', 'category']);
        });
        $this->entity('webhook_events', function (Blueprint $table): void {
            $table->string('provider', 24);
            $table->string('provider_event_id');
            $table->string('payload_hash');
            $table->string('state', 24)->default('RECEIVED');
            $table->timestampTz('processed_at')->nullable();
            $table->unique(['provider', 'provider_event_id']);
        });
        $this->entity('idempotency_records', function (Blueprint $table): void {
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('endpoint');
            $table->string('idempotency_key');
            $table->string('request_hash');
            $table->unsignedSmallInteger('response_status')->nullable();
            $table->jsonb('response_body')->nullable();
            $table->timestampTz('expires_at')->nullable();
            $table->unique(['actor_user_id', 'endpoint', 'idempotency_key']);
        });
        $this->entity('outbox_events', function (Blueprint $table): void {
            $table->string('event_type', 96);
            $table->string('aggregate_type', 48);
            $table->uuid('aggregate_id');
            $table->jsonb('payload');
            $table->timestampTz('available_at');
            $table->timestampTz('processed_at')->nullable();
            $table->unsignedSmallInteger('attempts')->default(0);
            $table->index(['processed_at', 'available_at']);
        });
        $this->entity('audit_logs', function (Blueprint $table): void {
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('actor_role', 48)->nullable();
            $table->string('action', 96);
            $table->string('resource_type', 48);
            $table->uuid('resource_id')->nullable();
            $table->uuid('vendor_organization_id')->nullable();
            $table->jsonb('before')->nullable();
            $table->jsonb('after')->nullable();
            $table->text('reason')->nullable();
            $table->string('correlation_id', 64)->index();
            $table->boolean('succeeded')->default(true);
            $table->index(['resource_type', 'resource_id']);
        });
        $this->entity('privacy_requests', function (Blueprint $table): void {
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('request_type', 32);
            $table->string('state', 24);
            $table->text('retention_exception')->nullable();
            $table->timestampTz('completed_at')->nullable();
        });
        $this->entity('data_exports', function (Blueprint $table): void {
            $table->foreignId('requested_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('export_type', 48);
            $table->jsonb('filters');
            $table->text('reason');
            $table->uuid('file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->string('state', 24);
            $table->timestampTz('expires_at')->nullable();
        });
        $this->entity('platform_settings', function (Blueprint $table): void {
            $table->string('key')->unique();
            $table->jsonb('value');
            $table->unsignedInteger('version');
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });

        foreach (['analytics_daily_facts', 'analytics_geography_facts', 'analytics_category_facts', 'analytics_active_user_facts'] as $name) {
            $this->entity($name, function (Blueprint $table): void {
                $table->date('fact_date');
                $table->string('environment', 8)->default('TEST');
                $table->string('dataset_id', 64);
                $table->string('dimension_key');
                $table->jsonb('metrics');
                $table->unique(['environment', 'dataset_id', 'fact_date', 'dimension_key']);
            });
        }
        $this->entity('analytics_refresh_runs', function (Blueprint $table): void {
            $table->string('kind', 48);
            $table->string('environment', 8)->default('TEST');
            $table->string('dataset_id', 64);
            $table->date('snapshot_date');
            $table->unsignedInteger('revision')->default(1);
            $table->string('state', 24)->default('RUNNING');
            $table->timestampTz('observed_at')->nullable();
            $table->unsignedInteger('source_count')->default(0);
            $table->unsignedInteger('selected_count')->default(0);
            $table->string('content_hash')->nullable();
            $table->uuid('supersedes_run_id')->nullable();
            $table->text('reviewer_reason')->nullable();
            $table->unique(['kind', 'environment', 'dataset_id', 'snapshot_date', 'revision']);
        });
        Schema::table('analytics_refresh_runs', function (Blueprint $table): void {
            $table->foreign('supersedes_run_id')->references('id')->on('analytics_refresh_runs')->restrictOnDelete();
        });
        $this->entity('price_observations', function (Blueprint $table): void {
            $table->foreignUuid('analytics_refresh_run_id')->constrained()->restrictOnDelete();
            $table->string('source_kind', 32)->default('PUBLIC_LISTING');
            $table->string('environment', 8)->default('TEST');
            $table->string('dataset_id', 64);
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_price_version_id')->constrained()->restrictOnDelete();
            $table->uuid('comparable_group_version_id')->nullable();
            $table->timestampTz('observed_at');
            $table->date('local_snapshot_date');
            $table->bigInteger('ordinary_payable_centavos');
            $table->decimal('normalized_php_price', 20, 8);
            $table->string('tax_category', 16);
            $table->foreignUuid('address_id')->constrained('addresses')->restrictOnDelete();
            $table->unsignedInteger('address_version');
            $table->string('eligibility_version', 32);
            $table->boolean('selected_for_average')->default(false);
            $table->string('exclusion_reason')->nullable();
            $table->unique(['analytics_refresh_run_id', 'listing_variant_id']);
            $table->index(['environment', 'dataset_id', 'local_snapshot_date']);
        });
    }

    private function addPostgresChecksAndIndexes(): void
    {
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }

        DB::table('users')
            ->whereNull('public_id')
            ->orderBy('id')
            ->pluck('id')
            ->each(fn (int|string $id) => DB::table('users')->where('id', $id)->update([
                'public_id' => (string) Str::uuid7(),
            ]));

        $statements = [
            'ALTER TABLE users ALTER COLUMN public_id SET NOT NULL',
            'CREATE UNIQUE INDEX users_email_normalized_unique ON users (LOWER(email))',
            "ALTER TABLE users ADD CONSTRAINT users_account_type_check CHECK (account_type IN ('BUYER','VENDOR','ADMIN'))",
            "ALTER TABLE vendor_memberships ADD CONSTRAINT vendor_memberships_role_check CHECK (role IN ('OWNER','STORE_MANAGER','STORE_STAFF','CUSTOMER_SERVICE','INVENTORY','FULFILLMENT'))",
            "ALTER TABLE vendor_memberships ADD CONSTRAINT vendor_manager_delegation_check CHECK (can_manage_staff = false OR role = 'STORE_MANAGER')",
            "CREATE UNIQUE INDEX vendor_one_active_owner_unique ON vendor_memberships (vendor_organization_id) WHERE role = 'OWNER' AND status = 'ACTIVE'",
            'ALTER TABLE delivery_service_areas ADD CONSTRAINT delivery_service_radius_check CHECK (radius_km IN (5,10,20,30,40,50))',
            'ALTER TABLE unit_conversions ADD CONSTRAINT unit_conversion_positive_check CHECK (multiplier > 0)',
            'ALTER TABLE listing_variants ADD CONSTRAINT listing_variants_pack_positive_check CHECK (pack_quantity > 0)',
            'ALTER TABLE listing_price_versions ADD CONSTRAINT listing_price_positive_check CHECK (amount_centavos > 0)',
            "ALTER TABLE listing_price_versions ADD CONSTRAINT listing_tax_category_check CHECK (tax_category IN ('VAT_12','VAT_ZERO','VAT_EXEMPT','NON_VAT'))",
            'ALTER TABLE inventory_items ADD CONSTRAINT inventory_balance_check CHECK (quantity_on_hand >= 0 AND hard_reserved_quantity >= 0 AND soft_held_quantity >= 0 AND hard_reserved_quantity <= quantity_on_hand)',
            'ALTER TABLE inventory_holds ADD CONSTRAINT inventory_hold_quantity_check CHECK (quantity > 0)',
            'ALTER TABLE auto_accept_policy_versions ADD CONSTRAINT auto_accept_allotment_check CHECK (allotment_quantity >= 0 AND remaining_allotment_quantity >= 0 AND remaining_allotment_quantity <= allotment_quantity)',
            'ALTER TABLE projects ADD CONSTRAINT projects_budget_check CHECK (budget_centavos >= 0)',
            'ALTER TABLE work_packages ADD CONSTRAINT work_packages_budget_check CHECK (budget_centavos >= 0)',
            'ALTER TABLE work_package_lines ADD CONSTRAINT work_package_line_quantity_check CHECK (quantity > 0)',
            'ALTER TABLE quotation_lines ADD CONSTRAINT quotation_line_amounts_check CHECK (quantity > 0 AND unit_price_centavos >= 0 AND subtotal_centavos >= 0)',
            'ALTER TABLE quotation_versions ADD CONSTRAINT quotation_totals_check CHECK (materials_centavos >= 0 AND delivery_centavos >= 0 AND nrpc_centavos >= 0 AND nrpc_centavos <= materials_centavos AND total_centavos >= materials_centavos + delivery_centavos)',
            'ALTER TABLE order_lines ADD CONSTRAINT order_line_amounts_check CHECK (quantity > 0 AND unit_price_centavos >= 0 AND discount_centavos >= 0 AND included_vat_centavos >= 0 AND payable_centavos >= 0)',
            "ALTER TABLE payments ADD CONSTRAINT payments_purpose_check CHECK (purpose IN ('FULL_ORDER_PAYMENT','NRPC_ASSURANCE_PAYMENT','ORDER_BALANCE_PAYMENT','PLATFORM_FEE_PAYMENT'))",
            'ALTER TABLE payments ADD CONSTRAINT payment_amounts_check CHECK (principal_centavos >= 0 AND processing_fee_centavos >= 0 AND total_centavos = principal_centavos + processing_fee_centavos)',
            "ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_kind_check CHECK (record_kind IN ('COLLECTION','CORRECTION','CANCELLATION_RELEASE'))",
            "ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_state_check CHECK (state IN ('UNPAID','PARTIALLY_RECORDED','PHYSICAL_PAYMENT_RECORDED','CANCELLED_UNPAID'))",
            'ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_amount_check CHECK (obligation_before_centavos >= 0 AND amount_centavos >= 0 AND remaining_obligation_centavos >= 0 AND amount_centavos <= obligation_before_centavos AND remaining_obligation_centavos = obligation_before_centavos - amount_centavos)',
            "ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_correction_link_check CHECK ((record_kind = 'CORRECTION') = (original_record_id IS NOT NULL AND correction_reason IS NOT NULL))",
            "ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_state_amount_check CHECK ((state = 'UNPAID' AND amount_centavos = 0 AND remaining_obligation_centavos = obligation_before_centavos) OR (state = 'PARTIALLY_RECORDED' AND amount_centavos > 0 AND remaining_obligation_centavos > 0) OR (state = 'PHYSICAL_PAYMENT_RECORDED' AND amount_centavos > 0 AND remaining_obligation_centavos = 0) OR (state = 'CANCELLED_UNPAID' AND record_kind = 'CANCELLATION_RELEASE' AND amount_centavos = 0 AND remaining_obligation_centavos = obligation_before_centavos))",
            'ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_evidence_check CHECK (amount_centavos = 0 OR evidence_file_id IS NOT NULL)',
            "ALTER TABLE refunds ADD CONSTRAINT refund_target_trigger_check CHECK ((target_type = 'ORDER' AND trigger IN ('CANCELLATION','DISPUTE_CONCLUSION','TECHNICAL_COMPENSATION') AND order_id IS NOT NULL) OR (target_type = 'PLATFORM_FEE' AND trigger = 'FEE_CREDIT' AND fee_statement_id IS NOT NULL AND fee_adjustment_id IS NOT NULL))",
            'ALTER TABLE refunds ADD CONSTRAINT refund_amount_positive_check CHECK (amount_centavos > 0)',
            'ALTER TABLE refunds ADD CONSTRAINT refund_source_allocation_check CHECK (source_captured_centavos >= 0 AND prior_allocated_centavos >= 0 AND prior_allocated_centavos <= source_captured_centavos AND amount_centavos <= source_captured_centavos - prior_allocated_centavos)',
            'ALTER TABLE reviews ADD CONSTRAINT reviews_rating_check CHECK (rating BETWEEN 1 AND 5)',
            'ALTER TABLE score_snapshots ADD CONSTRAINT score_ranges_check CHECK ((vcs IS NULL OR vcs BETWEEN 1 AND 5) AND (mqs IS NULL OR mqs BETWEEN 1 AND 5) AND (ohs IS NULL OR ohs BETWEEN 1 AND 5) AND (vps IS NULL OR vps BETWEEN 1 AND 5))',
            'ALTER TABLE addresses ADD COLUMN IF NOT EXISTS location geography(Point,4326)',
            'UPDATE addresses SET location = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography WHERE latitude IS NOT NULL AND longitude IS NOT NULL',
            'CREATE INDEX addresses_location_gist ON addresses USING GIST (location)',
            'ALTER TABLE directory_suppliers ADD COLUMN IF NOT EXISTS location geography(Point,4326)',
            'UPDATE directory_suppliers SET location = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography',
            'CREATE INDEX directory_suppliers_location_gist ON directory_suppliers USING GIST (location)',
            'ALTER TABLE price_observations ADD COLUMN IF NOT EXISTS recorded_store_geography geography(Point,4326)',
            'CREATE INDEX price_observations_geography_gist ON price_observations USING GIST (recorded_store_geography)',
            "ALTER TABLE price_observations ADD CONSTRAINT price_observation_source_check CHECK (source_kind = 'PUBLIC_LISTING')",
            'ALTER TABLE price_observations ADD CONSTRAINT price_observation_amount_check CHECK (ordinary_payable_centavos > 0 AND normalized_php_price > 0)',
            'ALTER TABLE price_observations ADD CONSTRAINT price_observation_selection_check CHECK (selected_for_average = false OR (comparable_group_version_id IS NOT NULL AND exclusion_reason IS NULL))',
            'CREATE UNIQUE INDEX price_observations_selected_vendor_group_unique ON price_observations (analytics_refresh_run_id, vendor_organization_id, comparable_group_version_id) WHERE selected_for_average = true',
            'CREATE UNIQUE INDEX buyer_one_primary_location_unique ON buyer_locations (buyer_profile_id) WHERE is_primary = true',
        ];

        foreach ($statements as $statement) {
            DB::statement($statement);
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
        // Remove the legacy products reference before dropping materials.
        Schema::table('products', function (Blueprint $table): void {
            $table->dropForeign(['material_id']);
            $table->dropColumn(['public_id', 'material_id', 'brand', 'manufacturer', 'country_of_manufacture', 'lock_version']);
        });
        $tables = [
            'price_observations', 'analytics_refresh_runs', 'analytics_active_user_facts', 'analytics_category_facts',
            'analytics_geography_facts', 'analytics_daily_facts', 'platform_settings', 'data_exports', 'privacy_requests',
            'audit_logs', 'outbox_events', 'idempotency_records', 'webhook_events', 'notification_preferences',
            'notification_deliveries', 'notifications', 'files', 'route_cache_entries', 'place_cache_entries',
            'directory_suppliers', 'psgc_boundaries', 'psgc_areas', 'psgc_versions', 'vendor_badge_history',
            'badge_definitions', 'score_snapshots', 'metric_events', 'review_moderation', 'review_media', 'reviews',
            'dispute_remedies', 'dispute_appeals', 'dispute_decisions', 'dispute_clarifications', 'dispute_responses',
            'dispute_evidence', 'dispute_parties', 'dispute_cases', 'no_show_events', 'pickup_authorizations',
            'fulfillment_proofs', 'fulfillment_milestones', 'fulfillments', 'refund_events', 'refund_attempts', 'refunds',
            'processing_fee_snapshots', 'physical_payment_records', 'payment_events', 'payment_attempts', 'payments',
            'cancellation_decisions', 'cancellation_requests', 'nrpc_acceptances', 'nrpc_records', 'vendor_confirmations',
            'order_status_history', 'order_snapshots', 'order_lines', 'orders', 'quotation_events', 'quotation_counter_offers',
            'quotation_changes', 'quotation_lines', 'quotation_versions', 'quotations', 'message_read_receipts',
            'message_attachments', 'messages', 'conversation_assignments', 'conversation_participants', 'conversations',
            'budget_overrides', 'compiled_estimate_lines', 'compiled_estimate_vendors', 'compiled_estimates',
            'work_package_lines', 'work_package_versions', 'work_packages', 'project_sites', 'projects',
            'checkout_vendor_groups', 'checkout_groups', 'cart_items', 'carts', 'delivery_assignments', 'delivery_quotes',
            'vehicle_rate_versions', 'vendor_vehicles', 'stock_confirmation_events', 'auto_accept_policy_versions',
            'auto_accept_policies', 'inventory_holds', 'inventory_movements', 'inventory_items', 'compliance_reviews',
            'compliance_reference_matches', 'compliance_extractions', 'compliance_evidence', 'compliance_submissions',
            'listing_status_history', 'listing_price_versions', 'listing_media', 'listing_variants', 'vendor_listings',
            'regulated_material_rules', 'technical_attribute_definitions', 'material_tag_links', 'material_tags',
            'unit_conversions', 'material_aliases', 'materials', 'units', 'material_categories', 'buyer_ranking_preferences',
            'favorite_vendors', 'buyer_locations', 'buyer_profiles', 'vendor_payment_accounts', 'business_document_reviews',
            'business_document_versions', 'business_documents', 'delivery_service_areas', 'operating_hours', 'store_media',
            'store_profiles', 'addresses', 'vendor_activation_history', 'vendor_onboarding_steps', 'vendor_classifications',
            'vendor_contacts', 'vendor_invitations', 'vendor_memberships', 'vendor_organizations', 'admin_invitations',
            'admin_memberships', 'role_permissions', 'permissions', 'platform_roles', 'agreement_acceptances',
            'agreement_versions', 'agreement_documents', 'login_events', 'recovery_codes', 'totp_factors', 'trusted_devices',
            'auth_refresh_token_history', 'auth_sessions', 'email_otps', 'external_identities', 'user_profiles',
        ];

        // This migration adds cross-domain and current-version references after
        // creation. Remove only constraints owned by these rollback targets;
        // do not use CASCADE, which could remove objects from other migrations.
        foreach ($tables as $table) {
            foreach (Schema::getForeignKeys($table) as $foreignKey) {
                Schema::table($table, fn (Blueprint $blueprint) => $blueprint->dropForeign($foreignKey['name']));
            }
        }

        foreach ($tables as $table) {
            Schema::dropIfExists($table);
        }

        Schema::table('users', function (Blueprint $table): void {
            $table->dropColumn(['public_id', 'account_type', 'account_status', 'last_authenticated_at', 'lock_version']);
        });
    }
};
