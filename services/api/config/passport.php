<?php

declare(strict_types=1);

$privateKey = env('PASSPORT_PRIVATE_KEY_BASE64');
$publicKey = env('PASSPORT_PUBLIC_KEY_BASE64');

return [

    /*
    |--------------------------------------------------------------------------
    | Passport Guard
    |--------------------------------------------------------------------------
    |
    | Here you may specify which authentication guard Passport will use when
    | authenticating users. This value should correspond with one of your
    | guards that is already present in your "auth" configuration file.
    |
    */

    'guard' => 'web',

    'middleware' => [],

    /*
    |--------------------------------------------------------------------------
    | Encryption Keys
    |--------------------------------------------------------------------------
    |
    | Passport uses encryption keys while generating secure access tokens for
    | your application. By default, the keys are stored as local files but
    | can be set via environment variables when that is more convenient.
    |
    */

    'private_key' => is_string($privateKey) && $privateKey !== '' ? base64_decode($privateKey, true) : null,

    'public_key' => is_string($publicKey) && $publicKey !== '' ? base64_decode($publicKey, true) : null,

    'key_path' => env('PASSPORT_KEY_PATH'),

    /*
    |--------------------------------------------------------------------------
    | Passport Database Connection
    |--------------------------------------------------------------------------
    |
    | By default, Passport's models will utilize your application's default
    | database connection. If you wish to use a different connection you
    | may specify the configured name of the database connection here.
    |
    */

    'connection' => env('PASSPORT_CONNECTION'),

];
