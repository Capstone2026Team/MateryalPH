<?php

declare(strict_types=1);

namespace Tests;

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Illuminate\Support\Facades\DB;
use RuntimeException;
use Throwable;

abstract class TestCase extends BaseTestCase
{
    public function createApplication(): Application
    {
        $app = parent::createApplication();
        $this->assertIsolatedTestEnvironment($app);

        return $app;
    }

    private function assertIsolatedTestEnvironment(Application $app): void
    {
        $connection = (array) config('database.connections.pgsql', []);
        $host = (string) ($connection['host'] ?? '');
        $password = (string) ($connection['password'] ?? '');
        $allowedHosts = array_filter(array_map('trim', explode(',', (string) env('TEST_DB_ALLOWED_HOSTS', 'postgres-test'))));
        $dbUrl = trim((string) env('DB_URL', ''));
        $configCacheOverride = trim((string) env('APP_CONFIG_CACHE', ''));
        $parallel = trim((string) (env('TEST_TOKEN', '') ?: env('LARAVEL_PARALLEL_TESTING', '')));

        $safeStaticConfiguration = $app->environment('testing')
            && ! $app->configurationIsCached()
            && config('database.default') === 'pgsql'
            && ($connection['database'] ?? null) === 'materyalph_test'
            && ($connection['username'] ?? null) === 'materyalph_test_runner'
            && in_array($host, $allowedHosts, true)
            && $host !== 'postgres'
            && strlen($password) >= 32
            && $dbUrl === ''
            && $configCacheOverride === ''
            && config('cache.default') === 'array'
            && config('queue.default') === 'sync'
            && config('session.driver') === 'array'
            && config('mail.default') === 'array'
            && $parallel === '';

        if (! $safeStaticConfiguration) {
            throw new RuntimeException('Unsafe test configuration. The Phase 1 suite requires the isolated testing environment and refuses development, cached, URL-based, incomplete, or parallel database configuration.');
        }

        try {
            $database = DB::connection('pgsql')->selectOne(
                "SELECT current_database() AS database_name, current_user AS database_user, current_setting('server_version_num') AS version",
            );
        } catch (Throwable $exception) {
            throw new RuntimeException('Unable to prove the isolated PostgreSQL test connection.', 0, $exception);
        }

        if (($database->database_name ?? null) !== 'materyalph_test'
            || ($database->database_user ?? null) !== 'materyalph_test_runner'
            || (int) ($database->version ?? 0) < 160000
            || (int) ($database->version ?? 0) >= 170000) {
            throw new RuntimeException('The live database connection is not the dedicated PostgreSQL 16 Phase 1 test database.');
        }
    }
}
