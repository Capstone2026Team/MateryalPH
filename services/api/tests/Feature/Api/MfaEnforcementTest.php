<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\MfaChallengeService;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

final class MfaEnforcementTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        config()->set('materyalph.bot_protection.enabled', false);
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_admin_password_login_stops_at_mfa_without_issuing_a_session(): void
    {
        $admin = User::factory()->create([
            'account_type' => 'ADMIN',
            'account_status' => 'ACTIVE',
            'password' => Hash::make('Correct-password-123'),
        ]);

        $response = $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson('/api/v1/auth/login', [
                'email' => $admin->email,
                'password' => 'Correct-password-123',
                'portal' => 'ADMIN',
            ]);

        $response->assertOk()
            ->assertCookie('mp_mfa_challenge')
            ->assertCookieMissing('mp_access')
            ->assertCookieMissing('mp_refresh')
            ->assertJsonPath('data.mfa_required', true)
            ->assertJsonPath('data.mfa_enrollment_required', true)
            ->assertJsonPath('errors', []);

        $this->assertDatabaseCount('auth_sessions', 0);
        $this->assertDatabaseCount('oauth_access_tokens', 0);
    }

    public function test_only_privileged_vendor_roles_require_mfa(): void
    {
        $organization = VendorOrganization::query()->create([
            'legal_name' => 'MFA Test Hardware Inc.',
            'store_name' => 'MFA Test Hardware',
        ]);
        $owner = User::factory()->create(['account_type' => 'VENDOR']);
        $staff = User::factory()->create(['account_type' => 'VENDOR']);
        VendorMembership::query()->create([
            'vendor_organization_id' => $organization->getKey(),
            'user_id' => $owner->getKey(),
            'role' => 'OWNER',
            'status' => 'ACTIVE',
        ]);
        VendorMembership::query()->create([
            'vendor_organization_id' => $organization->getKey(),
            'user_id' => $staff->getKey(),
            'role' => 'STORE_STAFF',
            'status' => 'ACTIVE',
        ]);

        $service = app(MfaChallengeService::class);

        self::assertTrue($service->requiredFor($owner));
        self::assertFalse($service->requiredFor($staff));
    }

    public function test_vendor_enrollment_and_returning_challenge_preserve_authenticated_web_sessions(): void
    {
        $password = 'Correct-password-123';
        [$vendor, $organization] = $this->privilegedVendor($password);

        $freshLogin = $this->webPost('/api/v1/auth/login', [
            'email' => $vendor->email,
            'password' => $password,
            'portal' => 'VENDOR',
        ])->assertOk()
            ->assertJsonPath('data.mfa_required', true)
            ->assertJsonPath('data.mfa_enrollment_required', true)
            ->assertCookieMissing('mp_access')
            ->assertCookieMissing('mp_refresh');

        $freshChallenge = $freshLogin->getCookie('mp_mfa_challenge', false);
        self::assertNotNull($freshChallenge);
        $freshChallengeToken = (string) $freshChallenge->getValue();

        $this->withUnencryptedCookie('mp_mfa_challenge', $freshChallengeToken)
            ->getJson('/api/v1/auth/mfa/status')
            ->assertOk()
            ->assertJsonPath('data.mfa_enrollment_required', true);

        $enrollment = $this->webPost('/api/v1/auth/mfa/enrollment', [], [
            'mp_mfa_challenge' => $freshChallengeToken,
        ])->assertOk();
        $secret = (string) $enrollment->json('data.secret');
        self::assertNotSame('', $secret);

        $confirmation = $this->webPost('/api/v1/auth/mfa/enrollment/confirm', [
            'code' => $this->totpCode($secret, intdiv(time(), 30)),
        ], ['mp_mfa_challenge' => $freshChallengeToken])
            ->assertOk()
            ->assertCookie('mp_access')
            ->assertCookie('mp_refresh')
            ->assertJsonCount(8, 'data.recovery_codes');

        $firstAccessCookie = $confirmation->getCookie('mp_access', false);
        self::assertNotNull($firstAccessCookie);
        $this->app['auth']->forgetGuards();
        $firstSession = $this->withCredentials()
            ->withUnencryptedCookie('mp_access', (string) $firstAccessCookie->getValue())
            ->getJson('/api/v1/auth/session');
        self::assertTrue($firstSession->baseRequest?->cookies->has('mp_access') ?? false);
        self::assertTrue($firstSession->baseRequest?->headers->has('Authorization') ?? false);
        $firstSession
            ->assertOk()
            ->assertJsonPath('data.user.account_type', 'VENDOR');

        self::assertSame('NOT_STARTED', $organization->refresh()->onboarding_status);

        $returningLogin = $this->webPost('/api/v1/auth/login', [
            'email' => $vendor->email,
            'password' => $password,
            'portal' => 'VENDOR',
        ])->assertOk()
            ->assertJsonPath('data.mfa_required', true)
            ->assertJsonPath('data.mfa_enrollment_required', false)
            ->assertCookieMissing('mp_access')
            ->assertCookieMissing('mp_refresh');

        $returningChallenge = $returningLogin->getCookie('mp_mfa_challenge', false);
        self::assertNotNull($returningChallenge);

        $challenge = $this->webPost('/api/v1/auth/mfa/challenge', [
            'code' => $this->totpCode($secret, intdiv(time(), 30) + 1),
        ], ['mp_mfa_challenge' => (string) $returningChallenge->getValue()])
            ->assertOk()
            ->assertCookie('mp_access')
            ->assertCookie('mp_refresh');

        $returningAccessCookie = $challenge->getCookie('mp_access', false);
        self::assertNotNull($returningAccessCookie);
        $this->app['auth']->forgetGuards();
        $returningSession = $this->withCredentials()
            ->withUnencryptedCookie('mp_access', (string) $returningAccessCookie->getValue())
            ->getJson('/api/v1/auth/session');
        self::assertTrue($returningSession->baseRequest?->cookies->has('mp_access') ?? false);
        self::assertTrue($returningSession->baseRequest?->headers->has('Authorization') ?? false);
        $returningSession
            ->assertOk()
            ->assertJsonPath('data.user.account_type', 'VENDOR');

        self::assertSame('NOT_STARTED', $organization->refresh()->onboarding_status);
    }

    /** @return array{User, VendorOrganization} */
    private function privilegedVendor(string $password): array
    {
        $organization = VendorOrganization::query()->create([
            'legal_name' => 'MFA Session Hardware Inc.',
            'store_name' => 'MFA Session Hardware',
        ]);
        $vendor = User::factory()->create([
            'account_type' => 'VENDOR',
            'account_status' => 'ACTIVE',
            'password' => Hash::make($password),
        ]);
        VendorMembership::query()->create([
            'vendor_organization_id' => $organization->getKey(),
            'user_id' => $vendor->getKey(),
            'role' => 'OWNER',
            'status' => 'ACTIVE',
        ]);

        return [$vendor, $organization];
    }

    /**
     * @param  array<string, mixed>  $payload
     * @param  array<string, string>  $cookies
     */
    private function webPost(string $uri, array $payload, array $cookies = []): TestResponse
    {
        return $this->withCredentials()
            ->withUnencryptedCookies(['mp_csrf' => 'test-csrf-token'] + $cookies)
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson($uri, $payload);
    }

    private function totpCode(string $secret, int $counter): string
    {
        $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        $buffer = 0;
        $bits = 0;
        $decoded = '';
        foreach (str_split($secret) as $character) {
            $position = strpos($alphabet, $character);
            self::assertNotFalse($position);
            $buffer = ($buffer << 5) | $position;
            $bits += 5;
            if ($bits >= 8) {
                $bits -= 8;
                $decoded .= chr(($buffer >> $bits) & 0xFF);
            }
        }

        $hash = hash_hmac('sha1', pack('N2', 0, $counter), $decoded, true);
        $offset = ord($hash[19]) & 0x0F;
        $value = ((ord($hash[$offset]) & 0x7F) << 24)
            | ((ord($hash[$offset + 1]) & 0xFF) << 16)
            | ((ord($hash[$offset + 2]) & 0xFF) << 8)
            | (ord($hash[$offset + 3]) & 0xFF);

        return str_pad((string) ($value % 1_000_000), 6, '0', STR_PAD_LEFT);
    }
}
