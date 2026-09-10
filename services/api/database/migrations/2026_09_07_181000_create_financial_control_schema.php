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
        $this->taxProfiles();
        $this->immutableMoney();
        $this->remittanceAndCommission();
        $this->refundsAndLedger();
        $this->documentsAndCalendar();
        $this->linkDeferredReferences();
        $this->addPostgresChecks();
    }

    private function taxProfiles(): void
    {
        $this->entity('vendor_tax_profiles', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('status', 24)->default('INCOMPLETE');
            $table->uuid('current_version_id')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        $this->entity('tax_rule_versions', function (Blueprint $table): void {
            $table->string('environment', 8)->default('TEST');
            $table->string('code', 64);
            $table->unsignedInteger('version');
            $table->string('source_type', 32);
            $table->string('source_reference')->nullable();
            $table->jsonb('rules');
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->foreignId('approved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('approved_at')->nullable();
            $table->unique(['environment', 'code', 'version']);
        });
        $this->entity('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->foreignUuid('vendor_tax_profile_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->string('taxpayer_key_hash');
            $table->string('entity_class', 32);
            $table->string('registration_category', 32);
            $table->string('vat_category', 24);
            $table->unsignedSmallInteger('fiscal_year_start_month')->default(1);
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->foreignId('submitted_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('approved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('approved_at')->nullable();
            $table->string('content_hash');
            $table->unique(['vendor_tax_profile_id', 'version']);
        });
        Schema::table('vendor_tax_profiles', function (Blueprint $table): void {
            $table->foreign('current_version_id')->references('id')->on('vendor_tax_profile_versions')->restrictOnDelete();
        });
        $this->entity('tax_evidence', function (Blueprint $table): void {
            $table->foreignUuid('vendor_tax_profile_version_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->string('evidence_type', 48);
            $table->string('origin', 32);
            $table->string('document_hash');
            $table->date('valid_from')->nullable();
            $table->date('valid_until')->nullable();
            $table->string('review_state', 24)->default('PENDING');
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('reviewed_at')->nullable();
        });
        $this->entity('withholding_assignments', function (Blueprint $table): void {
            $table->foreignUuid('vendor_tax_profile_version_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('tax_rule_version_id')->constrained()->restrictOnDelete();
            $table->string('atc_code', 32)->nullable();
            $table->unsignedInteger('rate_basis_points');
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->string('reason');
        });
    }

    private function immutableMoney(): void
    {
        $this->entity('financial_snapshots', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('quotation_version_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('tax_rule_version_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->bigInteger('materials_gross_centavos');
            $table->bigInteger('vendor_discount_centavos')->default(0);
            $table->bigInteger('materials_payable_centavos');
            $table->bigInteger('materials_vat_centavos')->default(0);
            $table->bigInteger('materials_exclusive_centavos');
            $table->bigInteger('delivery_centavos')->default(0);
            $table->bigInteger('delivery_vat_centavos')->default(0);
            $table->bigInteger('processing_fee_centavos')->default(0);
            $table->bigInteger('nrpc_centavos')->default(0);
            $table->bigInteger('buyer_total_centavos');
            $table->string('currency', 3)->default('PHP');
            $table->uuid('fee_policy_version_id')->nullable();
            $table->string('calculation_version', 48);
            $table->jsonb('rounding_allocation');
            $table->string('calculation_hash')->unique();
            $table->timestampTz('published_at');
        });
        $this->entity('financial_snapshot_lines', function (Blueprint $table): void {
            $table->foreignUuid('financial_snapshot_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('order_line_id')->unique()->constrained()->restrictOnDelete();
            $table->decimal('source_quantity', 20, 6);
            $table->bigInteger('source_unit_price_centavos');
            $table->bigInteger('gross_centavos');
            $table->bigInteger('discount_centavos')->default(0);
            $table->bigInteger('vat_centavos')->default(0);
            $table->bigInteger('ordinary_payable_centavos');
            $table->bigInteger('principal_allocated_centavos')->default(0);
            $table->bigInteger('refund_allocated_centavos')->default(0);
            $table->string('tax_category', 16);
        });
        $this->entity('financial_allocations', function (Blueprint $table): void {
            $table->foreignUuid('financial_snapshot_id')->constrained()->restrictOnDelete();
            $table->string('allocation_type', 32);
            $table->string('source_type', 32);
            $table->uuid('source_id');
            $table->string('target_type', 32);
            $table->uuid('target_id');
            $table->bigInteger('amount_centavos');
            $table->jsonb('basis');
            $table->unique(['allocation_type', 'source_type', 'source_id', 'target_type', 'target_id']);
        });
    }

    private function remittanceAndCommission(): void
    {
        $this->entity('remittance_groups', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('withholding_assignment_id')->constrained()->restrictOnDelete();
            $table->unsignedSmallInteger('tax_year');
            $table->string('environment', 8)->default('TEST');
            $table->string('taxpayer_key_hash');
            $table->string('obligation_type', 32);
            $table->string('period_key', 16);
            $table->string('state', 32)->default('OPEN');
            $table->unique(['vendor_organization_id', 'withholding_assignment_id', 'period_key']);
        });
        $this->entity('remittance_collections', function (Blueprint $table): void {
            $table->foreignUuid('remittance_group_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('payment_id')->constrained()->restrictOnDelete();
            $table->bigInteger('collected_centavos');
            $table->bigInteger('source_principal_centavos');
            $table->bigInteger('prior_allocated_centavos')->default(0);
            $table->timestampTz('collected_at');
            $table->unique(['remittance_group_id', 'payment_id']);
        });
        $this->entity('remittance_assessments', function (Blueprint $table): void {
            $table->foreignUuid('remittance_group_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('financial_snapshot_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('taxpayer_key_hash');
            $table->string('obligation_type', 32);
            $table->string('assigned_withholding_entity', 32);
            $table->bigInteger('collections_centavos');
            $table->bigInteger('refunds_centavos')->default(0);
            $table->bigInteger('discounts_refunded_centavos')->default(0);
            $table->bigInteger('vat_refunded_centavos')->default(0);
            $table->bigInteger('delivery_centavos')->default(0);
            $table->bigInteger('vat_centavos')->default(0);
            $table->bigInteger('provider_charge_centavos')->default(0);
            $table->bigInteger('principal_centavos');
            $table->bigInteger('gross_basis_centavos');
            $table->bigInteger('withheld_centavos');
            $table->bigInteger('threshold_before_centavos');
            $table->bigInteger('threshold_after_centavos');
            $table->unsignedInteger('effective_rate_basis_points');
            $table->string('threshold_status', 32);
            $table->string('calculation_state', 32)->default('CALCULATED');
            $table->string('deduction_evidence_state', 32)->default('UNCONFIRMED');
            $table->string('reconciliation_state', 32)->default('PENDING');
            $table->foreignUuid('evidence_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->text('assessment_reason');
            $table->jsonb('calculation');
            $table->unique(['environment', 'taxpayer_key_hash', 'remittance_group_id', 'obligation_type'], 'remittance_assessment_scope_unique');
        });
        $this->entity('tax_year_accumulators', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('taxpayer_key_hash');
            $table->unsignedSmallInteger('tax_year');
            $table->bigInteger('platform_gross_basis_centavos')->default(0);
            $table->bigInteger('platform_withheld_centavos')->default(0);
            $table->bigInteger('outside_evidence_centavos')->default(0);
            $table->string('external_declaration_scope', 32)->default('NONE');
            $table->bigInteger('external_declared_total_centavos')->default(0);
            $table->bigInteger('external_locally_represented_centavos')->default(0);
            $table->string('overlap_state', 32)->default('CLEAR');
            $table->boolean('threshold_breached')->default(false);
            $table->timestampTz('threshold_breached_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->uuid('last_locked_event_id')->nullable();
            $table->unique(['environment', 'taxpayer_key_hash', 'tax_year'], 'tax_accumulator_taxpayer_year_unique');
        });

        $this->entity('fee_policy_versions', function (Blueprint $table): void {
            $table->string('code', 64);
            $table->unsignedInteger('version');
            $table->string('environment', 8)->default('TEST');
            $table->unsignedInteger('commission_basis_points')->default(200);
            $table->string('basis', 64)->default('MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT');
            $table->string('cadence', 16)->default('MONTHLY');
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->foreignId('approved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('approved_at')->nullable();
            $table->unique(['environment', 'code', 'version']);
        });
        $this->entity('fee_assessments', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('financial_snapshot_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('fee_policy_version_id')->constrained()->restrictOnDelete();
            $table->bigInteger('commission_basis_centavos');
            $table->unsignedInteger('commission_basis_points');
            $table->bigInteger('earned_centavos');
            $table->bigInteger('earned_target_centavos');
            $table->bigInteger('credited_centavos')->default(0);
            $table->string('credited_state', 32)->default('NOT_CREDITED');
            $table->string('state', 32)->default('ESTIMATED');
            $table->timestampTz('earned_at')->nullable();
            $table->boolean('dispute_hold')->default(false);
            $table->timestampTz('dispute_hold_at')->nullable();
            $table->string('calculation_hash');
            $table->unique(['order_id', 'fee_policy_version_id']);
        });
        $this->entity('fee_adjustments', function (Blueprint $table): void {
            $table->foreignUuid('fee_assessment_id')->constrained()->restrictOnDelete();
            $table->string('kind', 24);
            $table->bigInteger('amount_centavos');
            $table->bigInteger('target_fee_before_centavos');
            $table->bigInteger('target_fee_after_centavos');
            $table->text('reason');
            $table->foreignId('prepared_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('approved_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('approved_at');
        });
        $this->entity('fee_statements', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->date('period_start');
            $table->date('period_end');
            $table->date('issued_on');
            $table->date('due_on');
            $table->bigInteger('charges_centavos')->default(0);
            $table->bigInteger('credits_centavos')->default(0);
            $table->bigInteger('paid_centavos')->default(0);
            $table->bigInteger('balance_centavos')->default(0);
            $table->bigInteger('outstanding_centavos')->default(0);
            $table->string('state', 24)->default('DRAFT');
            $table->unsignedInteger('version')->default(1);
            $table->unique(['vendor_organization_id', 'period_start', 'period_end', 'version']);
        });
        $this->entity('fee_statement_lines', function (Blueprint $table): void {
            $table->foreignUuid('fee_statement_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('fee_assessment_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('fee_adjustment_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('line_type', 24);
            $table->bigInteger('amount_centavos');
            $table->string('description');
            $table->unique('fee_assessment_id');
            $table->unique('fee_adjustment_id');
        });
        $this->entity('fee_payment_allocations', function (Blueprint $table): void {
            $table->foreignUuid('fee_statement_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('payment_id')->constrained()->restrictOnDelete();
            $table->bigInteger('amount_centavos');
            $table->bigInteger('statement_outstanding_before_centavos');
            $table->bigInteger('payment_unallocated_before_centavos');
            $table->timestampTz('allocated_at');
            $table->unique(['fee_statement_id', 'payment_id']);
        });
    }

    private function refundsAndLedger(): void
    {
        $this->entity('physical_reimbursements', function (Blueprint $table): void {
            $table->foreignUuid('refund_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('physical_payment_record_id')->constrained()->restrictOnDelete();
            $table->foreignId('recorded_by_user_id')->constrained('users')->restrictOnDelete();
            $table->bigInteger('amount_centavos');
            $table->string('method', 24);
            $table->string('state', 32)->default('VENDOR_REIMBURSEMENT_PENDING');
            $table->foreignUuid('evidence_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->timestampTz('reimbursed_at')->nullable();
            $table->timestampTz('buyer_acknowledged_at')->nullable();
            $table->foreignId('confirmed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->text('confirmation_reason')->nullable();
        });
        $this->entity('tax_adjustments', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('refund_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('remittance_assessment_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('original_record_type', 32);
            $table->uuid('original_record_id');
            $table->date('period_start');
            $table->date('period_end');
            $table->string('kind', 32);
            $table->bigInteger('amount_centavos');
            $table->jsonb('before_values');
            $table->jsonb('after_values');
            $table->text('reason');
            $table->string('state', 32)->default('ADJUSTMENT_REQUIRED');
            $table->foreignId('prepared_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->foreignUuid('evidence_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->timestampTz('reviewed_at')->nullable();
            $table->timestampTz('posted_at')->nullable();
        });
        $this->entity('financial_posting_batches', function (Blueprint $table): void {
            $table->string('environment', 8)->default('TEST');
            $table->string('ledger', 32);
            $table->char('currency', 3)->default('PHP');
            $table->string('batch_type', 32);
            $table->string('source_event_key')->unique();
            $table->date('posting_date');
            $table->string('state', 24)->default('PREPARED');
            $table->bigInteger('debit_total_centavos')->default(0);
            $table->bigInteger('credit_total_centavos')->default(0);
            $table->foreignId('prepared_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('content_hash')->nullable()->unique();
            $table->string('correlation_id', 64)->index();
            $table->timestampTz('posted_at')->nullable();
        });
        $this->entity('financial_ledger_entries', function (Blueprint $table): void {
            $table->foreignUuid('financial_posting_batch_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('ledger', 32);
            $table->string('account_code', 64);
            $table->string('source_type', 32);
            $table->uuid('source_id');
            $table->string('direction', 8);
            $table->bigInteger('amount_centavos');
            $table->string('currency', 3)->default('PHP');
            $table->string('idempotency_key')->unique();
            $table->jsonb('dimensions')->nullable();
            $table->uuid('reverses_ledger_entry_id')->nullable();
            $table->bigInteger('original_available_centavos')->nullable();
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('actor_role', 64)->nullable();
            $table->string('correlation_id', 64)->index();
            $table->timestampTz('occurred_at');
        });
        Schema::table('financial_ledger_entries', function (Blueprint $table): void {
            $table->foreign('reverses_ledger_entry_id')->references('id')->on('financial_ledger_entries')->restrictOnDelete();
        });
    }

    private function documentsAndCalendar(): void
    {
        $this->entity('tax_report_packages', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('package_type', 48);
            $table->date('period_start');
            $table->date('period_end');
            $table->string('state', 24)->default('DRAFT');
            $table->foreignUuid('filing_calendar_version_id')->nullable();
            $table->foreignId('prepared_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->foreignUuid('file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->string('content_hash')->nullable();
            $table->string('export_hash')->nullable()->unique();
            $table->string('submission_state', 40)->nullable();
            $table->text('review_reason')->nullable();
            $table->timestampTz('reviewed_at')->nullable();
            $table->timestampTz('issued_at')->nullable();
        });
        $this->entity('tax_report_package_lines', function (Blueprint $table): void {
            $table->foreignUuid('tax_report_package_id')->constrained()->restrictOnDelete();
            $table->string('source_type', 32);
            $table->uuid('source_id');
            $table->string('atc_code', 32)->nullable();
            $table->bigInteger('basis_centavos');
            $table->bigInteger('tax_centavos');
            $table->unique(['tax_report_package_id', 'source_type', 'source_id']);
        });
        $this->entity('tax_certificates', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('certificate_type', 48);
            $table->string('document_origin', 24);
            $table->string('issuer');
            $table->string('issuer_taxpayer_key_hash')->nullable();
            $table->string('payee_name');
            $table->string('payee_taxpayer_key_hash');
            $table->string('certificate_number_hash')->nullable();
            $table->string('atc_code', 32)->nullable();
            $table->date('period_start');
            $table->date('period_end');
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->string('content_hash');
            $table->bigInteger('basis_centavos');
            $table->bigInteger('tax_centavos');
            $table->string('verification_state', 32)->default('UNVERIFIED');
            $table->foreignId('verified_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('verified_at')->nullable();
            $table->boolean('authentic_evidence')->default(false);
        });
        $this->entity('invoice_records', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('fee_statement_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('invoice_type', 32);
            $table->string('document_origin', 24);
            $table->string('issuer');
            $table->string('issuer_taxpayer_key_hash')->nullable();
            $table->string('payee_name');
            $table->string('payee_taxpayer_key_hash')->nullable();
            $table->string('invoice_number_hash');
            $table->date('issued_on');
            $table->bigInteger('amount_centavos');
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->string('content_hash');
            $table->string('verification_state', 32)->default('UNVERIFIED');
            $table->foreignId('verified_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('verified_at')->nullable();
            $table->unique(['environment', 'issuer_taxpayer_key_hash', 'invoice_number_hash'], 'invoice_issuer_number_unique');
        });
        $this->entity('filing_calendar_versions', function (Blueprint $table): void {
            $table->string('environment', 8)->default('TEST');
            $table->unsignedInteger('version');
            $table->string('source_type', 32);
            $table->string('source_reference')->nullable();
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->foreignId('approved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->unique(['environment', 'version']);
        });
        $this->entity('filing_deadlines', function (Blueprint $table): void {
            $table->foreignUuid('filing_calendar_version_id')->constrained()->restrictOnDelete();
            $table->string('obligation_code', 64);
            $table->string('taxpayer_class', 32);
            $table->string('periodicity', 24);
            $table->jsonb('due_rule');
            $table->unique(['filing_calendar_version_id', 'obligation_code', 'taxpayer_class']);
        });
        $this->entity('external_filing_evidence', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('filing_deadline_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('evidence_type', 32);
            $table->string('content_hash');
            $table->date('filed_on');
            $table->boolean('authentic_evidence')->default(false);
            $table->string('verification_state', 32)->default('UNVERIFIED');
            $table->foreignId('verified_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('verified_at')->nullable();
        });
    }

    private function linkDeferredReferences(): void
    {
        Schema::table('payments', function (Blueprint $table): void {
            $table->foreign('fee_statement_id')->references('id')->on('fee_statements')->restrictOnDelete();
        });
        Schema::table('refunds', function (Blueprint $table): void {
            $table->foreign('fee_statement_id')->references('id')->on('fee_statements')->restrictOnDelete();
            $table->foreign('fee_adjustment_id')->references('id')->on('fee_adjustments')->restrictOnDelete();
        });
        Schema::table('financial_snapshots', function (Blueprint $table): void {
            $table->foreign('fee_policy_version_id')->references('id')->on('fee_policy_versions')->restrictOnDelete();
        });
        Schema::table('tax_report_packages', function (Blueprint $table): void {
            $table->foreign('filing_calendar_version_id')->references('id')->on('filing_calendar_versions')->restrictOnDelete();
        });
    }

    private function addPostgresChecks(): void
    {
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }

        foreach ([
            "ALTER TABLE vendor_tax_profiles ADD CONSTRAINT vendor_tax_profiles_environment_check CHECK (environment IN ('TEST','DEMO','LIVE'))",
            "ALTER TABLE tax_rule_versions ADD CONSTRAINT tax_rule_environment_check CHECK (environment IN ('TEST','DEMO','LIVE'))",
            'ALTER TABLE vendor_tax_profile_versions ADD CONSTRAINT tax_profile_fiscal_month_check CHECK (fiscal_year_start_month BETWEEN 1 AND 12)',
            'ALTER TABLE vendor_tax_profile_versions ADD CONSTRAINT tax_profile_approval_actor_check CHECK (approved_by_user_id IS NULL OR approved_by_user_id <> submitted_by_user_id)',
            'ALTER TABLE tax_evidence ADD CONSTRAINT tax_evidence_validity_check CHECK (valid_until IS NULL OR valid_from IS NULL OR valid_until >= valid_from)',
            'ALTER TABLE withholding_assignments ADD CONSTRAINT withholding_rate_check CHECK (rate_basis_points BETWEEN 0 AND 10000)',
            "ALTER TABLE financial_snapshots ADD CONSTRAINT financial_snapshot_environment_currency_check CHECK (environment IN ('TEST','DEMO','LIVE') AND currency = 'PHP')",
            'ALTER TABLE financial_snapshots ADD CONSTRAINT financial_snapshot_amounts_check CHECK (materials_gross_centavos >= 0 AND vendor_discount_centavos >= 0 AND materials_payable_centavos = materials_gross_centavos - vendor_discount_centavos AND materials_vat_centavos >= 0 AND materials_exclusive_centavos = materials_payable_centavos - materials_vat_centavos AND delivery_centavos >= 0 AND delivery_vat_centavos >= 0 AND delivery_vat_centavos <= delivery_centavos AND processing_fee_centavos >= 0 AND nrpc_centavos >= 0 AND nrpc_centavos <= materials_payable_centavos AND buyer_total_centavos = materials_payable_centavos + delivery_centavos + processing_fee_centavos)',
            'ALTER TABLE financial_snapshot_lines ADD CONSTRAINT financial_snapshot_line_amounts_check CHECK (source_quantity > 0 AND source_unit_price_centavos >= 0 AND gross_centavos >= 0 AND discount_centavos >= 0 AND discount_centavos <= gross_centavos AND vat_centavos >= 0 AND vat_centavos <= ordinary_payable_centavos AND ordinary_payable_centavos = gross_centavos - discount_centavos AND principal_allocated_centavos >= 0 AND refund_allocated_centavos >= 0 AND principal_allocated_centavos + refund_allocated_centavos <= ordinary_payable_centavos)',
            'ALTER TABLE financial_allocations ADD CONSTRAINT financial_allocation_amount_check CHECK (amount_centavos >= 0)',
            "ALTER TABLE remittance_groups ADD CONSTRAINT remittance_group_environment_check CHECK (environment IN ('TEST','DEMO','LIVE'))",
            'ALTER TABLE remittance_collections ADD CONSTRAINT remittance_collection_allocation_check CHECK (source_principal_centavos >= 0 AND prior_allocated_centavos >= 0 AND collected_centavos > 0 AND prior_allocated_centavos + collected_centavos <= source_principal_centavos)',
            "ALTER TABLE remittance_assessments ADD CONSTRAINT remittance_environment_check CHECK (environment IN ('TEST','DEMO','LIVE'))",
            'ALTER TABLE remittance_assessments ADD CONSTRAINT remittance_amounts_check CHECK (collections_centavos >= 0 AND refunds_centavos >= 0 AND refunds_centavos <= collections_centavos AND discounts_refunded_centavos >= 0 AND vat_refunded_centavos >= 0 AND delivery_centavos >= 0 AND vat_centavos >= 0 AND provider_charge_centavos >= 0 AND principal_centavos >= 0 AND gross_basis_centavos >= 0 AND withheld_centavos >= 0 AND withheld_centavos <= gross_basis_centavos AND threshold_before_centavos >= 0 AND threshold_after_centavos >= threshold_before_centavos AND effective_rate_basis_points BETWEEN 0 AND 10000)',
            "ALTER TABLE remittance_assessments ADD CONSTRAINT remittance_calculation_state_check CHECK (calculation_state IN ('CALCULATED','POSTED','BASE_REVIEW_REQUIRED','VOIDED'))",
            "ALTER TABLE remittance_assessments ADD CONSTRAINT remittance_deduction_state_check CHECK (deduction_evidence_state IN ('UNCONFIRMED','SIMULATED_WITHHELD','PROVIDER_REPORTED','PLATFORM_EVIDENCED'))",
            "ALTER TABLE remittance_assessments ADD CONSTRAINT remittance_reconciliation_state_check CHECK (reconciliation_state IN ('PENDING','RECONCILED','RECONCILIATION_EXCEPTION'))",
            "ALTER TABLE tax_year_accumulators ADD CONSTRAINT tax_accumulator_environment_check CHECK (environment IN ('TEST','DEMO','LIVE'))",
            'ALTER TABLE tax_year_accumulators ADD CONSTRAINT tax_year_amounts_check CHECK (platform_gross_basis_centavos >= 0 AND platform_withheld_centavos >= 0 AND outside_evidence_centavos >= 0 AND external_declared_total_centavos >= 0 AND external_locally_represented_centavos >= 0 AND external_locally_represented_centavos <= external_declared_total_centavos)',
            "ALTER TABLE fee_policy_versions ADD CONSTRAINT fee_policy_commission_check CHECK (commission_basis_points = 200 AND basis = 'MATERIALS_AFTER_DISCOUNT_EXCLUDING_VAT' AND cadence = 'MONTHLY')",
            "ALTER TABLE fee_policy_versions ADD CONSTRAINT fee_policy_environment_check CHECK (environment IN ('TEST','DEMO','LIVE'))",
            'ALTER TABLE fee_assessments ADD CONSTRAINT fee_assessment_amounts_check CHECK (commission_basis_centavos >= 0 AND commission_basis_points = 200 AND earned_centavos >= 0 AND earned_target_centavos >= 0 AND credited_centavos >= 0 AND credited_centavos <= earned_centavos)',
            "ALTER TABLE fee_assessments ADD CONSTRAINT fee_assessment_state_check CHECK (state IN ('ESTIMATED','EARNED','CANCELLED') AND credited_state IN ('NOT_CREDITED','PARTIALLY_CREDITED','CREDITED'))",
            'ALTER TABLE fee_adjustments ADD CONSTRAINT fee_adjustment_amount_check CHECK (amount_centavos > 0 AND target_fee_before_centavos >= target_fee_after_centavos AND target_fee_after_centavos >= 0)',
            'ALTER TABLE fee_adjustments ADD CONSTRAINT fee_adjustment_actor_check CHECK (prepared_by_user_id <> approved_by_user_id)',
            'ALTER TABLE fee_statements ADD CONSTRAINT fee_statement_dates_check CHECK (period_start <= period_end AND issued_on <= due_on)',
            'ALTER TABLE fee_statements ADD CONSTRAINT fee_statement_amounts_check CHECK (charges_centavos >= 0 AND credits_centavos >= 0 AND paid_centavos >= 0 AND balance_centavos >= 0 AND outstanding_centavos = balance_centavos AND balance_centavos = charges_centavos - credits_centavos - paid_centavos)',
            "ALTER TABLE fee_statements ADD CONSTRAINT fee_statement_state_check CHECK (state IN ('DRAFT','ISSUED','PARTIALLY_PAID','PAID','VOIDED'))",
            'ALTER TABLE fee_statement_lines ADD CONSTRAINT fee_statement_line_source_check CHECK ((fee_assessment_id IS NOT NULL)::int + (fee_adjustment_id IS NOT NULL)::int = 1)',
            'ALTER TABLE fee_payment_allocations ADD CONSTRAINT fee_payment_allocation_check CHECK (amount_centavos > 0 AND statement_outstanding_before_centavos >= amount_centavos AND payment_unallocated_before_centavos >= amount_centavos)',
            "ALTER TABLE physical_reimbursements ADD CONSTRAINT physical_reimbursement_state_check CHECK (state IN ('VENDOR_REIMBURSEMENT_PENDING','REIMBURSEMENT_CONFIRMED'))",
            'ALTER TABLE physical_reimbursements ADD CONSTRAINT physical_reimbursement_amount_check CHECK (amount_centavos > 0)',
            'ALTER TABLE tax_adjustments ADD CONSTRAINT tax_adjustment_dates_check CHECK (period_start <= period_end)',
            'ALTER TABLE tax_adjustments ADD CONSTRAINT tax_adjustment_actor_check CHECK (reviewed_by_user_id IS NULL OR reviewed_by_user_id <> prepared_by_user_id)',
            "ALTER TABLE tax_adjustments ADD CONSTRAINT tax_adjustment_state_check CHECK (state IN ('ADJUSTMENT_REQUIRED','UNDER_REVIEW','APPROVED','POSTED','REJECTED'))",
            "ALTER TABLE financial_posting_batches ADD CONSTRAINT posting_batch_scope_check CHECK (environment IN ('TEST','DEMO','LIVE') AND currency = 'PHP' AND ledger IN ('DEMO_FLOW','PLATFORM_FEE'))",
            "ALTER TABLE financial_posting_batches ADD CONSTRAINT posting_batch_state_check CHECK (state IN ('PREPARED','REVIEWED','POSTED','REJECTED','REVERSED'))",
            'ALTER TABLE financial_posting_batches ADD CONSTRAINT posting_batch_actor_check CHECK (reviewed_by_user_id IS NULL OR reviewed_by_user_id <> prepared_by_user_id)',
            "ALTER TABLE financial_posting_batches ADD CONSTRAINT posting_batch_balance_check CHECK (debit_total_centavos >= 0 AND credit_total_centavos >= 0 AND (state <> 'POSTED' OR (debit_total_centavos = credit_total_centavos AND posted_at IS NOT NULL)))",
            "ALTER TABLE financial_ledger_entries ADD CONSTRAINT ledger_direction_check CHECK (direction IN ('DEBIT','CREDIT') AND amount_centavos > 0 AND environment IN ('TEST','DEMO','LIVE') AND ledger IN ('DEMO_FLOW','PLATFORM_FEE') AND currency = 'PHP')",
            'ALTER TABLE financial_ledger_entries ADD CONSTRAINT ledger_reversal_amount_check CHECK (reverses_ledger_entry_id IS NULL OR (original_available_centavos IS NOT NULL AND amount_centavos <= original_available_centavos))',
            'ALTER TABLE tax_report_packages ADD CONSTRAINT tax_package_actor_check CHECK (reviewed_by_user_id IS NULL OR reviewed_by_user_id <> prepared_by_user_id)',
            "ALTER TABLE tax_report_packages ADD CONSTRAINT tax_package_state_check CHECK (state IN ('DRAFT','REVIEWED','EXPORTED') AND (submission_state IS NULL OR (environment = 'TEST' AND submission_state = 'SIMULATED_SUBMISSION_RECORDED')))",
            "ALTER TABLE tax_certificates ADD CONSTRAINT tax_certificate_evidence_check CHECK (environment = 'LIVE' OR authentic_evidence = false)",
            'ALTER TABLE tax_certificates ADD CONSTRAINT tax_certificate_amounts_check CHECK (basis_centavos >= 0 AND tax_centavos >= 0 AND tax_centavos <= basis_centavos)',
            'ALTER TABLE invoice_records ADD CONSTRAINT invoice_record_target_check CHECK ((order_id IS NOT NULL)::int + (fee_statement_id IS NOT NULL)::int = 1 AND amount_centavos >= 0)',
            "ALTER TABLE external_filing_evidence ADD CONSTRAINT filing_evidence_check CHECK (environment = 'LIVE' OR authentic_evidence = false)",
        ] as $statement) {
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
        Schema::table('vendor_tax_profiles', fn (Blueprint $table) => $table->dropForeign(['current_version_id']));
        Schema::table('tax_report_packages', fn (Blueprint $table) => $table->dropForeign(['filing_calendar_version_id']));
        Schema::table('financial_snapshots', fn (Blueprint $table) => $table->dropForeign(['fee_policy_version_id']));
        Schema::table('refunds', function (Blueprint $table): void {
            $table->dropForeign(['fee_statement_id']);
            $table->dropForeign(['fee_adjustment_id']);
        });
        Schema::table('payments', fn (Blueprint $table) => $table->dropForeign(['fee_statement_id']));

        foreach ([
            'external_filing_evidence', 'filing_deadlines', 'filing_calendar_versions', 'invoice_records',
            'tax_certificates', 'tax_report_package_lines', 'tax_report_packages', 'financial_ledger_entries',
            'financial_posting_batches', 'tax_adjustments', 'physical_reimbursements', 'fee_payment_allocations',
            'fee_statement_lines', 'fee_statements', 'fee_adjustments', 'fee_assessments', 'fee_policy_versions',
            'tax_year_accumulators', 'remittance_assessments', 'remittance_collections', 'remittance_groups',
            'financial_allocations', 'financial_snapshot_lines', 'financial_snapshots', 'withholding_assignments',
            'tax_evidence', 'vendor_tax_profile_versions', 'tax_rule_versions', 'vendor_tax_profiles',
        ] as $table) {
            Schema::dropIfExists($table);
        }
    }
};
