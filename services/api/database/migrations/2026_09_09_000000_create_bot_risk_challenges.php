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
        Schema::create('bot_risk_challenges', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('normalized_email_hash', 64);
            $table->string('portal', 16);
            $table->string('action', 64);
            $table->string('platform', 16);
            $table->string('outcome', 32);
            $table->boolean('delivery_allowed')->default(false);
            $table->string('proof_hash', 64)->nullable()->unique();
            $table->timestampTz('expires_at');
            $table->timestampTz('verified_at')->nullable();
            $table->timestampTz('proof_expires_at')->nullable();
            $table->timestampTz('consumed_at')->nullable();
            $table->timestampTz('invalidated_at')->nullable();
            $table->timestampsTz();
            $table->index(['normalized_email_hash', 'action', 'expires_at'], 'bot_risk_lookup_idx');
            $table->index(['proof_hash', 'proof_expires_at'], 'bot_risk_proof_idx');
        });

        Schema::table('email_otps', function (Blueprint $table): void {
            $table->foreignUuid('bot_risk_challenge_id')
                ->nullable()
                ->after('user_id')
                ->constrained('bot_risk_challenges')
                ->restrictOnDelete();
            $table->index('bot_risk_challenge_id');
        });

        if (DB::getDriverName() === 'pgsql') {
            DB::statement("ALTER TABLE bot_risk_challenges ADD CONSTRAINT bot_risk_portal_check CHECK (portal IN ('BUYER', 'VENDOR'))");
            DB::statement("ALTER TABLE bot_risk_challenges ADD CONSTRAINT bot_risk_platform_check CHECK (platform IN ('WEB', 'ANDROID', 'IOS'))");
        }
    }

    public function down(): void
    {
        Schema::table('email_otps', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('bot_risk_challenge_id');
        });
        Schema::dropIfExists('bot_risk_challenges');
    }
};
