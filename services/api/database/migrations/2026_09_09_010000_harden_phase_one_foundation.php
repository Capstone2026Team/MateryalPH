<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    /** @var array<string, list<string>> */
    private array $utcTimestampColumns = [
        'users' => ['email_verified_at', 'created_at', 'updated_at'],
        'password_reset_tokens' => ['created_at'],
        'failed_jobs' => ['failed_at'],
        'products' => ['created_at', 'updated_at'],
        'oauth_auth_codes' => ['expires_at'],
        'oauth_access_tokens' => ['created_at', 'updated_at', 'expires_at'],
        'oauth_refresh_tokens' => ['expires_at'],
        'oauth_clients' => ['created_at', 'updated_at'],
        'oauth_device_codes' => ['user_approved_at', 'last_polled_at', 'expires_at'],
    ];

    public function up(): void
    {
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }

        DB::table('products')->whereNull('public_id')->orderBy('id')->eachById(
            static fn (object $product) => DB::table('products')->where('id', $product->id)->update([
                'public_id' => (string) Str::uuid7(),
            ]),
        );
        DB::statement('ALTER TABLE products ALTER COLUMN public_id SET NOT NULL');
        Schema::table('products', static function ($table): void {
            $table->dropColumn(['price', 'stock']);
        });

        foreach ($this->utcTimestampColumns as $table => $columns) {
            foreach ($columns as $column) {
                DB::statement(sprintf(
                    'ALTER TABLE %s ALTER COLUMN %s TYPE TIMESTAMPTZ USING %s AT TIME ZONE \'UTC\'',
                    $table,
                    $column,
                    $column,
                ));
            }
        }

    }

    public function down(): void
    {
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }

        foreach ($this->utcTimestampColumns as $table => $columns) {
            foreach ($columns as $column) {
                DB::statement(sprintf(
                    'ALTER TABLE %s ALTER COLUMN %s TYPE TIMESTAMP WITHOUT TIME ZONE USING %s AT TIME ZONE \'UTC\'',
                    $table,
                    $column,
                    $column,
                ));
            }
        }

        Schema::table('products', static function ($table): void {
            $table->decimal('price', 10, 2)->default(0);
            $table->integer('stock')->default(0);
        });
        DB::statement('ALTER TABLE products ALTER COLUMN public_id DROP NOT NULL');
    }
};
