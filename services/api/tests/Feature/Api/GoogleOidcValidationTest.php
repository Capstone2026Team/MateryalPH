<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\GoogleOidcService;
use App\Models\User;
use Firebase\JWT\JWT;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

final class GoogleOidcValidationTest extends TestCase
{
    use RefreshDatabase;

    public function test_web_and_native_google_starts_store_route_owned_transport_context(): void
    {
        $this->configureOidc();
        config()->set('app.buyer_redirect_uri', 'materyalph://auth/callback');

        $mobileResponse = $this->postJson('/api/v1/mobile/auth/google/start', [
            'mode' => 'SIGN_IN',
        ])->assertOk();
        $mobileFlow = $this->flowFromAuthorizationUrl((string) $mobileResponse->json('data.authorization_url'));
        self::assertSame('BUYER', $mobileFlow['portal']);
        self::assertSame('MOBILE', $mobileFlow['client_kind']);

        $webResponse = $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson('/api/v1/auth/google/start', [
                'portal' => 'VENDOR',
                'mode' => 'SIGN_IN',
            ])->assertOk();
        $webFlow = $this->flowFromAuthorizationUrl((string) $webResponse->json('data.authorization_url'));
        self::assertSame('VENDOR', $webFlow['portal']);
        self::assertSame('WEB', $webFlow['client_kind']);
    }

    public function test_google_token_with_a_mismatched_audience_is_rejected(): void
    {
        $this->configureOidc();

        $service = app(GoogleOidcService::class);
        $authorizationUrl = $service->authorizationUrl('BUYER', 'WEB', false, false, 'SIGN_IN', null, null, null, null);
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        self::assertNotSame('', $state);
        /** @var array{nonce: string} $flow */
        $flow = Cache::get('oidc:'.hash('sha256', $state));

        $this->fakeGoogleIdentity($flow['nonce'], 'buyer@example.test', 'different-client-id');

        try {
            $service->complete($state, 'authorization-code');
            self::fail('An ID token issued to another OAuth client must be rejected.');
        } catch (AuthenticationException $exception) {
            self::assertSame('OIDC_TOKEN_INVALID', $exception->errorCode);
        }
    }

    public function test_cross_portal_google_identity_redirects_to_a_safe_vendor_error_without_creating_access(): void
    {
        $this->configureOidc();
        config()->set('app.vendor_frontend_url', 'https://vendor.example.test');
        User::factory()->create([
            'email' => 'single-identity@example.test',
            'account_type' => 'BUYER',
            'account_status' => 'ACTIVE',
            'email_verified_at' => now(),
        ]);

        $service = app(GoogleOidcService::class);
        $authorizationUrl = $service->authorizationUrl('VENDOR', 'WEB', false, false, 'SIGN_IN', null, null, null, null);
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        self::assertNotSame('', $state);
        /** @var array{nonce: string} $flow */
        $flow = Cache::get('oidc:'.hash('sha256', $state));
        $this->fakeGoogleIdentity($flow['nonce'], 'single-identity@example.test');

        $this->get('/api/v1/auth/google/callback?'.http_build_query([
            'state' => $state,
            'code' => 'authorization-code',
        ]))->assertRedirect('https://vendor.example.test/auth/callback?status=error&code=PORTAL_ACCESS_DENIED');

        $this->assertDatabaseCount('users', 1);
        $this->assertDatabaseCount('external_identities', 0);
        $this->assertDatabaseCount('auth_sessions', 0);
        $this->assertDatabaseCount('oauth_access_tokens', 0);
        $this->assertDatabaseHas('login_events', [
            'event_type' => 'GOOGLE_OIDC_CALLBACK_FAILED',
            'succeeded' => false,
        ]);
    }

    public function test_non_allowlisted_google_callback_failure_uses_the_sanitized_api_error_path(): void
    {
        $this->configureOidc();
        config()->set('app.vendor_frontend_url', 'https://vendor.example.test');
        $service = app(GoogleOidcService::class);
        $authorizationUrl = $service->authorizationUrl('VENDOR', 'WEB', false, false, 'SIGN_IN', null, null, null, null);
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        Http::fake([
            'https://accounts.example.test/token' => Http::response([], 503),
        ]);

        $this->getJson('/api/v1/auth/google/callback?'.http_build_query([
            'state' => $state,
            'code' => 'authorization-code',
        ]))->assertUnauthorized()
            ->assertJsonPath('errors.0.code', 'OIDC_EXCHANGE_FAILED');
    }

    private function base64Url(string $value): string
    {
        return rtrim(strtr(base64_encode($value), '+/', '-_'), '=');
    }

    private function fakeGoogleIdentity(string $nonce, string $email, string $audience = 'expected-client-id'): void
    {
        $privateKey = openssl_pkey_new(['private_key_bits' => 2048, 'private_key_type' => OPENSSL_KEYTYPE_RSA]);
        self::assertNotFalse($privateKey);
        self::assertTrue(openssl_pkey_export($privateKey, $privatePem));
        $details = openssl_pkey_get_details($privateKey);
        self::assertIsArray($details);
        self::assertArrayHasKey('rsa', $details);

        $idToken = JWT::encode([
            'iss' => 'https://accounts.google.com',
            'aud' => $audience,
            'sub' => 'google-subject',
            'email' => $email,
            'email_verified' => true,
            'nonce' => $nonce,
            'iat' => time(),
            'exp' => time() + 300,
        ], $privatePem, 'RS256', 'test-key');

        /** @var array{n: string, e: string} $rsa */
        $rsa = $details['rsa'];
        Http::fake([
            'https://accounts.example.test/token' => Http::response(['id_token' => $idToken]),
            'https://accounts.example.test/jwks' => Http::response(['keys' => [[
                'kty' => 'RSA',
                'kid' => 'test-key',
                'use' => 'sig',
                'alg' => 'RS256',
                'n' => $this->base64Url($rsa['n']),
                'e' => $this->base64Url($rsa['e']),
            ]]]),
        ]);
    }

    /** @return array<string, mixed> */
    private function flowFromAuthorizationUrl(string $authorizationUrl): array
    {
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        self::assertNotSame('', $state);
        $flow = Cache::get('oidc:'.hash('sha256', $state));
        self::assertIsArray($flow);

        return $flow;
    }

    private function configureOidc(): void
    {
        config()->set([
            'services.google_oidc.client_id' => 'expected-client-id',
            'services.google_oidc.client_secret' => 'test-client-secret',
            'services.google_oidc.redirect_uri' => 'http://localhost:8080/api/v1/auth/google/callback',
            'services.google_oidc.authorization_endpoint' => 'https://accounts.example.test/auth',
            'services.google_oidc.token_endpoint' => 'https://accounts.example.test/token',
            'services.google_oidc.jwks_uri' => 'https://accounts.example.test/jwks',
        ]);
    }
}
