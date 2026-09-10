<?php

declare(strict_types=1);

require __DIR__.'/../services/api/vendor/autoload.php';
$app = require __DIR__.'/../services/api/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$connection = (array) config('database.connections.pgsql', []);
$host = (string) ($connection['host'] ?? '');
$password = (string) ($connection['password'] ?? '');
$allowedHosts = array_filter(array_map('trim', explode(',', (string) env('TEST_DB_ALLOWED_HOSTS', 'postgres-test'))));
$dbUrl = trim((string) env('DB_URL', ''));
$configCacheOverride = trim((string) env('APP_CONFIG_CACHE', ''));
$parallel = trim((string) (env('TEST_TOKEN', '') ?: env('LARAVEL_PARALLEL_TESTING', '')));

$safe = $app->environment('testing')
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

if (! $safe) {
    fwrite(STDERR, "Refusing: unsafe or incomplete Phase 1 test configuration.\n");
    exit(1);
}

try {
    $database = Illuminate\Support\Facades\DB::connection('pgsql')->selectOne(
        "SELECT current_database() AS database_name, current_user AS database_user, current_setting('server_version_num') AS version",
    );
} catch (Throwable) {
    fwrite(STDERR, "Refusing: unable to prove the isolated PostgreSQL test connection.\n");
    exit(1);
}

if (($database->database_name ?? null) !== 'materyalph_test'
    || ($database->database_user ?? null) !== 'materyalph_test_runner'
    || (int) ($database->version ?? 0) < 160000
    || (int) ($database->version ?? 0) >= 170000) {
    fwrite(STDERR, "Refusing: live connection is not the dedicated PostgreSQL 16 Phase 1 test database.\n");
    exit(1);
}

if (in_array('--guard-only', $argv, true)) {
    echo "Isolation guard passed.\n";
    exit(0);
}

foreach ([
    ['migrate:fresh', ['--seed' => true, '--force' => true]],
    ['migrate:rollback', ['--force' => true]],
    ['migrate', ['--seed' => true, '--force' => true]],
    ['materyalph:schema-document', []],
    ['materyalph:schema-document', ['--check' => true]],
] as [$command, $options]) {
    echo $command.PHP_EOL;
    try {
        $status = Illuminate\Support\Facades\Artisan::call($command, $options);
    } catch (Throwable) {
        fwrite(STDERR, $command." failed; remaining gates were not run.\n");
        exit(1);
    }
    echo Illuminate\Support\Facades\Artisan::output();
    if ($status !== 0) {
        exit($status);
    }
}
