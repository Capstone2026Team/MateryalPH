<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Models\AdminInvitation;
use App\Models\PlatformRole;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

final class PhaseOneAuthAcceptanceTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        config()->set('materyalph.bot_protection.enabled', false);
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_one_email_cannot_register_a_second_account_type(): void
    {
        User::factory()->create(['email' => 'one-identity@example.test', 'account_type' => 'BUYER']);

        $this->webPost('/api/v1/auth/register', [
            'full_name' => 'Duplicate Account',
            'email' => 'ONE-IDENTITY@example.test',
            'mobile_e164' => '+639171234567',
            'password' => 'StrongPassword123',
            'password_confirmation' => 'StrongPassword123',
            'business_name' => 'Duplicate Hardware',
            'terms_accepted' => true,
            'privacy_accepted' => true,
        ])->assertStatus(409)
            ->assertJsonPath('errors.0.code', 'ACCOUNT_ALREADY_EXISTS');

        self::assertSame(1, User::query()->whereRaw('LOWER(email) = ?', ['one-identity@example.test'])->count());
    }

    public function test_admin_access_requires_and_consumes_a_valid_invitation(): void
    {
        $this->webPost('/api/v1/auth/register', [
            'full_name' => 'Public Admin',
            'email' => 'public-admin@example.test',
            'mobile_e164' => '+639171234567',
            'password' => 'StrongPassword123',
            'password_confirmation' => 'StrongPassword123',
            'account_type' => 'ADMIN',
            'terms_accepted' => true,
            'privacy_accepted' => true,
        ])->assertUnprocessable();

        $token = 'single-use-admin-invitation-token';
        $role = PlatformRole::query()->where('code', 'ADMIN_SUPERADMIN')->sole();
        $invitation = AdminInvitation::query()->create([
            'normalized_email' => 'invited.admin@example.test',
            'platform_role_id' => $role->getKey(),
            'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')),
            'expires_at' => now()->addHour(),
            'bootstrap' => true,
        ]);

        $payload = [
            'token' => $token,
            'full_name' => 'Invited Admin',
            'password' => 'StrongPassword123',
            'password_confirmation' => 'StrongPassword123',
            'terms_accepted' => true,
            'privacy_accepted' => true,
        ];

        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)
            ->assertCreated()
            ->assertJsonPath('data.next', 'SIGN_IN_AND_ENROLL_MFA');

        $admin = User::query()->where('email', 'invited.admin@example.test')->sole();
        self::assertSame('ADMIN', $admin->account_type);
        self::assertSame('ACTIVE', $admin->account_status);
        self::assertTrue(Hash::check('StrongPassword123', (string) $admin->password));
        self::assertNotNull($invitation->refresh()->accepted_at);
        $this->assertDatabaseHas('admin_memberships', [
            'user_id' => $admin->getKey(),
            'platform_role_id' => $role->getKey(),
            'status' => 'ACTIVE',
        ]);

        $this->webPost('/api/v1/auth/admin-invitations/accept', $payload)
            ->assertStatus(410)
            ->assertJsonPath('errors.0.code', 'ADMIN_INVITATION_INVALID');
    }

    /** @param array<string, mixed> $payload */
    private function webPost(string $uri, array $payload): TestResponse
    {
        return $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson($uri, $payload);
    }
}
