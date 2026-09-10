<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Models\AuthSession;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Passport\Token;
use Tests\TestCase;

final class PassportLogoutRevocationTest extends TestCase
{
    use RefreshDatabase;

    public function test_native_logout_revokes_real_passport_access_and_materyalph_refresh_credentials(): void
    {
        $key = openssl_pkey_new(['private_key_bits' => 2048]);
        self::assertNotFalse($key);
        self::assertTrue(openssl_pkey_export($key, $privateKey));
        $details = openssl_pkey_get_details($key);
        self::assertNotFalse($details);
        config()->set('passport.private_key', $privateKey);
        config()->set('passport.public_key', $details['key']);
        $this->seed(SystemFoundationSeeder::class);

        $password = 'CorrectPassword123';
        $user = User::factory()->create([
            'email' => 'passport-logout@example.test',
            'password' => $password,
            'account_type' => 'BUYER',
            'account_status' => 'ACTIVE',
            'email_verified_at' => now(),
        ]);

        $login = $this->postJson('/api/v1/mobile/auth/login', [
            'email' => $user->email,
            'password' => $password,
        ])->assertOk()->assertCookieMissing('mp_access');
        $firstAccessToken = (string) $login->json('data.access_token');
        $firstRefreshToken = (string) $login->json('data.refresh_token');
        self::assertNotSame('', $firstAccessToken);
        self::assertNotSame('', $firstRefreshToken);

        $this->withToken($firstAccessToken)
            ->getJson('/api/v1/mobile/auth/session')
            ->assertOk()
            ->assertJsonPath('data.user.account_type', 'BUYER');
        $this->app['auth']->forgetGuards();

        $refresh = $this->postJson('/api/v1/mobile/auth/refresh', [
            'refresh_token' => $firstRefreshToken,
        ])->assertOk();
        $activeAccessToken = (string) $refresh->json('data.access_token');
        $activeRefreshToken = (string) $refresh->json('data.refresh_token');
        self::assertNotSame($firstAccessToken, $activeAccessToken);
        self::assertNotSame($firstRefreshToken, $activeRefreshToken);

        $this->app['auth']->forgetGuards();
        $this->withToken($activeAccessToken)
            ->postJson('/api/v1/mobile/auth/logout')
            ->assertOk()
            ->assertJsonPath('data.logged_out', true);

        $session = AuthSession::query()->where('user_id', $user->getKey())->firstOrFail();
        self::assertNotNull($session->revoked_at);
        self::assertSame('LOGOUT', $session->getAttribute('revoke_reason'));
        self::assertTrue(Token::query()->findOrFail($session->oauth_access_token_id)->revoked);

        $this->app['auth']->forgetGuards();
        $this->withToken($activeAccessToken)
            ->getJson('/api/v1/mobile/auth/session')
            ->assertUnauthorized();
        $this->postJson('/api/v1/mobile/auth/refresh', [
            'refresh_token' => $activeRefreshToken,
        ])->assertUnauthorized()
            ->assertJsonPath('errors.0.code', 'REFRESH_TOKEN_INVALID');
    }
}
