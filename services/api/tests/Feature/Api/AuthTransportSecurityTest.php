<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\IssuedAccessToken;
use App\Http\Middleware\AuthenticateFromCookie;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Str;
use Tests\TestCase;

final class AuthTransportSecurityTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        config()->set('materyalph.bot_protection.enabled', false);
        $this->app->instance(AccessTokenIssuer::class, new class implements AccessTokenIssuer
        {
            public function issue(User $user, string $clientKind): IssuedAccessToken
            {
                return new IssuedAccessToken('native-access-token', (string) Str::uuid7());
            }

            public function revoke(?string $identifier): void {}
        });
    }

    public function test_browser_auth_mutation_without_csrf_is_rejected(): void
    {
        $this->postJson('/api/v1/auth/login', [
            'email' => 'vendor@example.test',
            'password' => 'not-a-real-password',
            'portal' => 'VENDOR',
        ])->assertStatus(419)
            ->assertJsonPath('data', null)
            ->assertJsonPath('errors.0.code', 'CSRF_TOKEN_MISMATCH');
    }

    public function test_client_controlled_mobile_header_cannot_bypass_browser_csrf(): void
    {
        $this->withHeader('X-Client-Kind', 'MOBILE')
            ->postJson('/api/v1/auth/login', [
                'email' => 'vendor@example.test',
                'password' => 'not-a-real-password',
                'portal' => 'VENDOR',
            ])->assertStatus(419)
            ->assertJsonPath('errors.0.code', 'CSRF_TOKEN_MISMATCH');
    }

    public function test_valid_browser_csrf_reaches_normal_request_validation(): void
    {
        $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson('/api/v1/auth/login', [])
            ->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
    }

    public function test_native_buyer_login_requires_no_browser_csrf_and_returns_only_native_tokens(): void
    {
        User::factory()->create([
            'email' => 'buyer@example.test',
            'password' => 'CorrectPassword123',
            'account_type' => 'BUYER',
        ]);

        $this->postJson('/api/v1/mobile/auth/login', [
            'email' => 'buyer@example.test',
            'password' => 'CorrectPassword123',
        ])->assertOk()
            ->assertJsonPath('data.access_token', 'native-access-token')
            ->assertJsonPath('data.user.account_type', 'BUYER')
            ->assertJsonStructure(['data' => ['refresh_token']])
            ->assertCookieMissing('mp_access')
            ->assertCookieMissing('mp_refresh')
            ->assertCookieMissing('mp_mfa_challenge')
            ->assertCookieMissing('mp_bot_proof');
    }

    public function test_only_browser_session_route_can_promote_its_cookie_to_bearer_authentication(): void
    {
        $routes = app('router')->getRoutes();
        $nativeRoute = $routes->match(Request::create('/api/v1/mobile/auth/session', 'GET'));
        $webRoute = $routes->match(Request::create('/api/v1/auth/session', 'GET'));

        self::assertNotContains('auth.cookie', $nativeRoute->gatherMiddleware());
        self::assertNotContains(AuthenticateFromCookie::class, $nativeRoute->gatherMiddleware());
        self::assertContains('auth.cookie', $webRoute->gatherMiddleware());
    }

    public function test_unauthenticated_browser_api_session_returns_the_canonical_json_error(): void
    {
        self::assertFalse(Route::has('login'));

        $this->withHeader('X-Correlation-ID', 'test-correlation-401')
            ->get('/api/v1/auth/session')
            ->assertStatus(401)
            ->assertHeader('Content-Type', 'application/json')
            ->assertHeader('X-Correlation-ID', 'test-correlation-401')
            ->assertHeaderMissing('Location')
            ->assertExactJson([
                'data' => null,
                'meta' => ['correlation_id' => 'test-correlation-401'],
                'errors' => [[
                    'code' => 'UNAUTHENTICATED',
                    'message' => 'Sign in to continue.',
                    'details' => [],
                ]],
            ]);
    }

    public function test_other_unauthenticated_protected_api_routes_use_the_same_json_error(): void
    {
        $this->get('/api/v1/mobile/auth/session')
            ->assertStatus(401)
            ->assertHeader('Content-Type', 'application/json')
            ->assertHeaderMissing('Location')
            ->assertJsonPath('data', null)
            ->assertJsonPath('errors.0.code', 'UNAUTHENTICATED')
            ->assertJsonPath('errors.0.message', 'Sign in to continue.')
            ->assertJsonStructure(['meta' => ['correlation_id']]);
    }

    public function test_browser_and_native_routes_reject_client_selected_transport_fields(): void
    {
        $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson('/api/v1/auth/login', [
                'email' => 'vendor@example.test',
                'password' => 'not-a-real-password',
                'portal' => 'VENDOR',
                'client_kind' => 'MOBILE',
            ])->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');

        $this->postJson('/api/v1/mobile/auth/login', [
            'email' => 'buyer@example.test',
            'password' => 'not-a-real-password',
            'portal' => 'VENDOR',
            'client_kind' => 'WEB',
        ])->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');
    }

    public function test_csrf_bootstrap_uses_the_canonical_envelope(): void
    {
        $this->getJson('/api/v1/auth/csrf')
            ->assertOk()
            ->assertCookie('mp_csrf')
            ->assertJsonStructure([
                'data' => ['csrf_token'],
                'meta',
                'errors',
            ]);
    }

    public function test_approved_web_origin_receives_credentialed_cors_headers(): void
    {
        config()->set('cors.allowed_origins', [
            'http://localhost:5173',
            'http://localhost:5174',
        ]);

        $this->withHeader('Origin', 'http://localhost:5173')
            ->getJson('/api/v1/auth/csrf')
            ->assertOk()
            ->assertHeader('Access-Control-Allow-Origin', 'http://localhost:5173')
            ->assertHeader('Access-Control-Allow-Credentials', 'true')
            ->assertHeader('Access-Control-Expose-Headers', 'X-Correlation-ID');
    }

    public function test_unapproved_web_origin_receives_no_cors_permission(): void
    {
        config()->set('cors.allowed_origins', [
            'http://localhost:5173',
            'http://localhost:5174',
        ]);

        $response = $this->withHeader('Origin', 'https://untrusted.example')
            ->getJson('/api/v1/auth/csrf')
            ->assertOk();

        self::assertFalse($response->headers->has('Access-Control-Allow-Origin'));
        self::assertFalse($response->headers->has('Access-Control-Allow-Credentials'));
    }

    public function test_approved_web_origin_can_preflight_auth_mutations_without_mobile_header(): void
    {
        config()->set('cors.allowed_origins', [
            'http://localhost:5173',
            'http://localhost:5174',
        ]);

        $this->withHeaders([
            'Origin' => 'http://localhost:5174',
            'Access-Control-Request-Method' => 'POST',
            'Access-Control-Request-Headers' => 'Content-Type, X-CSRF-Token',
        ])->options('/api/v1/auth/login')
            ->assertNoContent()
            ->assertHeader('Access-Control-Allow-Origin', 'http://localhost:5174')
            ->assertHeader('Access-Control-Allow-Credentials', 'true');
    }
}
