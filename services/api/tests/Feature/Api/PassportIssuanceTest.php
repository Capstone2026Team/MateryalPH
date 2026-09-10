<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AccessTokenIssuer;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Passport\Token;
use Tests\TestCase;

final class PassportIssuanceTest extends TestCase
{
    use RefreshDatabase;

    public function test_real_passport_issuer_supports_every_existing_account_scope(): void
    {
        $key = openssl_pkey_new(['private_key_bits' => 2048]);
        self::assertNotFalse($key);
        self::assertTrue(openssl_pkey_export($key, $privateKey));
        $details = openssl_pkey_get_details($key);
        self::assertNotFalse($details);
        config()->set('passport.private_key', $privateKey);
        config()->set('passport.public_key', $details['key']);
        $this->seed(SystemFoundationSeeder::class);

        foreach (['BUYER', 'VENDOR', 'ADMIN'] as $accountType) {
            $user = User::factory()->create(['account_type' => $accountType]);
            $issued = app(AccessTokenIssuer::class)->issue($user, $accountType === 'BUYER' ? 'MOBILE' : 'WEB');
            $token = Token::query()->findOrFail($issued->identifier);

            self::assertSame((string) $user->getKey(), (string) $token->user_id);
            self::assertSame([$accountType], $token->scopes);
            self::assertFalse($token->revoked);
        }
    }

    public function test_verified_buyer_login_issues_a_real_passport_session_from_runtime_keys(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $password = 'CorrectPassword123';
        $user = User::factory()->create([
            'email' => 'runtime-passport-login@example.test',
            'password' => $password,
            'account_type' => 'BUYER',
            'account_status' => 'ACTIVE',
            'email_verified_at' => now(),
        ]);

        $response = $this->postJson('/api/v1/mobile/auth/login', [
            'email' => $user->email,
            'password' => $password,
        ])->assertOk()
            ->assertCookieMissing('mp_access')
            ->assertJsonPath('data.user.account_type', 'BUYER');

        self::assertIsString($response->json('data.access_token'));
        self::assertIsString($response->json('data.refresh_token'));
        $token = Token::query()->where('user_id', $user->getKey())->sole();
        self::assertSame(['BUYER'], $token->scopes);
        self::assertFalse($token->revoked);
        $this->assertDatabaseHas('auth_sessions', [
            'user_id' => $user->getKey(),
            'oauth_access_token_id' => $token->getKey(),
            'client_kind' => 'MOBILE',
        ]);
    }
}
