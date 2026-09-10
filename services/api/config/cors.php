<?php

$allowedOrigins = array_values(array_filter(
    array_map(
        static fn (string $origin): string => rtrim(trim($origin), '/'),
        explode(',', (string) env('CORS_ALLOWED_ORIGINS', '')),
    ),
    static fn (string $origin): bool => $origin !== '',
));

return [
    'paths' => ['api/*'],
    'allowed_methods' => ['GET', 'HEAD', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    'allowed_origins' => $allowedOrigins,
    'allowed_origins_patterns' => [],
    'allowed_headers' => [
        'Accept',
        'Authorization',
        'Content-Type',
        'Idempotency-Key',
        'X-Correlation-ID',
        'X-CSRF-Token',
    ],
    'exposed_headers' => ['X-Correlation-ID'],
    'max_age' => 600,
    'supports_credentials' => true,
];
