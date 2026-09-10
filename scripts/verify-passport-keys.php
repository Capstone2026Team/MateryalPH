<?php

declare(strict_types=1);
use League\OAuth2\Server\CryptKey;

require __DIR__.'/../services/api/vendor/autoload.php';

set_error_handler(static function (): never {
    throw new RuntimeException('Passport key permission validation failed.');
});

$configuredPath = getenv('PASSPORT_KEY_PATH');
$keyDirectory = is_string($configuredPath) && trim($configuredPath) !== ''
    ? rtrim($configuredPath, '/\\')
    : getcwd().'/storage';

foreach (['oauth-private.key', 'oauth-public.key'] as $filename) {
    new CryptKey($keyDirectory.DIRECTORY_SEPARATOR.$filename);
}

fwrite(STDOUT, "Passport keys and permissions passed.\n");
