<?php

declare(strict_types=1);

return [
    'business_timezone' => env('BUSINESS_TIMEZONE', 'Asia/Manila'),
    'auth' => [
        'otp_ttl_minutes' => (int) env('EMAIL_OTP_TTL_MINUTES', 10),
        'otp_max_attempts' => (int) env('EMAIL_OTP_MAX_ATTEMPTS', 5),
        'otp_resend_seconds' => (int) env('EMAIL_OTP_RESEND_SECONDS', 60),
        'access_token_minutes' => (int) env('PASSPORT_ACCESS_TOKEN_MINUTES', 15),
        'refresh_token_days' => (int) env('PASSPORT_REFRESH_TOKEN_DAYS', 14),
        'mfa_challenge_ttl_minutes' => (int) env('MFA_CHALLENGE_TTL_MINUTES', 5),
        'mfa_challenge_max_attempts' => (int) env('MFA_CHALLENGE_MAX_ATTEMPTS', 5),
        'cookie_secure' => filter_var(env('COOKIE_SECURE', true), FILTER_VALIDATE_BOOL),
        'cookie_same_site' => env('COOKIE_SAME_SITE', 'lax'),
        'cookie_domain' => env('SESSION_DOMAIN'),
    ],
    'bot_protection' => [
        'enabled' => filter_var(env('RECAPTCHA_ENABLED', false), FILTER_VALIDATE_BOOL),
        'step_up_ttl_minutes' => (int) env('BOT_STEP_UP_TTL_MINUTES', 5),
        'site_keys' => [
            'WEB' => env('RECAPTCHA_VENDOR_WEB_SITE_KEY'),
        ],
        'allowed_identities' => [
            'WEB' => array_values(array_filter(array_map('trim', explode(',', (string) env('RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES', 'localhost,127.0.0.1'))))),
        ],
    ],
];
