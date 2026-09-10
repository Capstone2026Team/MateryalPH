<?php

declare(strict_types=1);

// Prints configuration status only. Never print configuration values or exceptions.
require __DIR__.'/../services/api/vendor/autoload.php';
$app = require __DIR__.'/../services/api/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$ready = (bool) config('materyalph.bot_protection.enabled');
echo 'RECAPTCHA_ENABLED: '.($ready ? 'enabled' : 'disabled').PHP_EOL;
foreach ([
    'RECAPTCHA_GOOGLE_CLOUD_PROJECT_ID' => 'services.recaptcha.project_id',
    'RECAPTCHA_ENTERPRISE_API_KEY' => 'services.recaptcha.api_key',
    'RECAPTCHA_VENDOR_WEB_SITE_KEY' => 'materyalph.bot_protection.site_keys.WEB',
] as $name => $path) {
    $present = trim((string) config($path)) !== '';
    $ready = $ready && $present;
    echo $name.': '.($present ? 'populated' : 'missing').PHP_EOL;
}

if (! $ready) {
    exit(1);
}
if (! in_array('--probe-provider', $argv, true)) {
    exit(0);
}

// A deliberately invalid token checks provider access, NOT successful user verification.
// No real user token is requested, retained, or displayed by this diagnostic.
$gateway = $app->make(App\Domain\Identity\RecaptchaAssessmentGateway::class);
$failed = false;
try {
    $result = $gateway->assess(
        'materyalph-preflight-invalid-token',
        (string) config('materyalph.bot_protection.site_keys.WEB'),
        'vendor_login',
    );
    $passed = ! $result->valid;
    echo 'VENDOR_WEB: '.($passed ? 'provider reachable; invalid token rejected' : 'unexpected result; investigate configuration').PHP_EOL;
    $failed = ! $passed;
} catch (App\Domain\Identity\AuthenticationException) {
    echo 'VENDOR_WEB: provider configuration/access rejected'.PHP_EOL;
    $failed = true;
} catch (Throwable) {
    echo 'VENDOR_WEB: provider unavailable or unusable response'.PHP_EOL;
    $failed = true;
}
echo 'A real Vendor browser checkbox-token smoke test is still required.'.PHP_EOL;
exit($failed ? 1 : 0);
