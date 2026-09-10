<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\BotProtectionService;
use App\Domain\Identity\IssuedAccessToken;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\RecaptchaAssessmentGateway;
use App\Domain\Identity\RecaptchaAssessmentResult;
use App\Domain\Identity\RecaptchaProviderUnavailable;
use App\Models\BotRiskChallenge;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

final class FakeRecaptchaAssessmentGateway implements RecaptchaAssessmentGateway
{
    public ?RecaptchaAssessmentResult $result = null;

    public bool $unavailable = false;

    public int $calls = 0;

    /** @var array{string, string, string}|null */
    public ?array $lastCall = null;

    public function assess(string $token, string $siteKey, string $expectedAction): RecaptchaAssessmentResult
    {
        $this->calls++;
        $this->lastCall = [$token, $siteKey, $expectedAction];
        if ($this->unavailable) {
            throw new RecaptchaProviderUnavailable('Provider unavailable in test.');
        }

        return $this->result ?? throw new \LogicException('A fake assessment result was not configured.');
    }
}

final class BotProtectionTest extends TestCase
{
    use RefreshDatabase;

    private FakeRecaptchaAssessmentGateway $gateway;

    protected function setUp(): void
    {
        parent::setUp();

        config()->set([
            'materyalph.bot_protection.enabled' => true,
            'materyalph.bot_protection.step_up_ttl_minutes' => 5,
            'materyalph.bot_protection.site_keys.WEB' => 'vendor-web-site-key',
            'materyalph.bot_protection.allowed_identities.WEB' => ['localhost'],
            'services.recaptcha.project_id' => 'test-project',
            'services.recaptcha.api_key' => 'test-api-key',
        ]);

        $this->gateway = new FakeRecaptchaAssessmentGateway;
        $this->app->instance(RecaptchaAssessmentGateway::class, $this->gateway);
        $this->app->instance(OtpCodeGenerator::class, new class implements OtpCodeGenerator
        {
            public function sixDigits(): string
            {
                return '123456';
            }
        });
        $this->app->instance(AccessTokenIssuer::class, new class implements AccessTokenIssuer
        {
            public function issue(User $user, string $clientKind): IssuedAccessToken
            {
                return new IssuedAccessToken('test-access-token', (string) Str::uuid7());
            }

            public function revoke(?string $identifier): void {}
        });
        $this->seed(SystemFoundationSeeder::class);
    }

    public function test_buyer_registration_requires_no_captcha_and_never_calls_the_provider(): void
    {
        $this->mobilePost('/api/v1/mobile/auth/register', $this->buyerRegistration())
            ->assertCreated()
            ->assertJsonPath('data.account_type', 'BUYER');

        self::assertSame(0, $this->gateway->calls);
        self::assertSame(0, BotRiskChallenge::query()->count());
    }

    public function test_buyer_login_requires_no_captcha_and_never_calls_the_provider(): void
    {
        User::factory()->create([
            'email' => 'buyer-login@example.test',
            'password' => 'CorrectPassword123',
            'account_type' => 'BUYER',
        ]);

        $this->mobilePost('/api/v1/mobile/auth/login', [
            'email' => 'buyer-login@example.test',
            'password' => 'CorrectPassword123',
        ])->assertOk()->assertJsonPath('data.access_token', 'test-access-token');

        self::assertSame(0, $this->gateway->calls);
    }

    public function test_buyer_cannot_submit_vendor_captcha_evidence(): void
    {
        $payload = $this->buyerRegistration();
        $payload['bot_protection'] = ['recaptcha_token' => 'must-not-be-accepted'];

        $this->mobilePost('/api/v1/mobile/auth/register', $payload)
            ->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');

        self::assertSame(0, $this->gateway->calls);
        self::assertFalse(User::query()->where('email', 'buyer@example.test')->exists());
    }

    public function test_valid_vendor_checkbox_assessment_allows_registration_without_a_score_gate(): void
    {
        $this->gateway->result = new RecaptchaAssessmentResult(true, 'vendor_register', 'localhost');

        $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'recaptcha_token' => 'checkbox-token',
        ]))->assertCreated()
            ->assertJsonPath('data.account_type', 'VENDOR');

        self::assertSame(['checkbox-token', 'vendor-web-site-key', 'vendor_register'], $this->gateway->lastCall);
        self::assertSame(0, BotRiskChallenge::query()->count());
    }

    public function test_vendor_login_and_recovery_use_their_server_selected_checkbox_actions(): void
    {
        User::factory()->create([
            'email' => 'vendor-auth@example.test',
            'password' => 'CorrectPassword123',
            'account_type' => 'VENDOR',
        ]);

        $this->gateway->result = new RecaptchaAssessmentResult(true, 'vendor_login', 'localhost');
        $this->webPost('/api/v1/auth/login', [
            'email' => 'vendor-auth@example.test',
            'password' => 'CorrectPassword123',
            'portal' => 'VENDOR',
            'bot_protection' => ['recaptcha_token' => 'login-checkbox-token'],
        ])->assertOk()
            ->assertJsonPath('data.user.account_type', 'VENDOR')
            ->assertCookie('mp_access');
        self::assertSame(['login-checkbox-token', 'vendor-web-site-key', 'vendor_login'], $this->gateway->lastCall);

        $this->gateway->result = new RecaptchaAssessmentResult(true, 'vendor_password_recovery', 'localhost');
        $this->webPost('/api/v1/auth/password/forgot', [
            'email' => 'vendor-auth@example.test',
            'portal' => 'VENDOR',
            'bot_protection' => ['recaptcha_token' => 'recovery-checkbox-token'],
        ])->assertOk();
        self::assertSame(['recovery-checkbox-token', 'vendor-web-site-key', 'vendor_password_recovery'], $this->gateway->lastCall);
    }

    public function test_vendor_submission_without_checkbox_or_accessible_fallback_is_rejected(): void
    {
        $payload = $this->vendorRegistration([]);
        unset($payload['bot_protection']);

        $this->webPost('/api/v1/auth/register', $payload)
            ->assertUnprocessable()
            ->assertJsonPath('errors.0.code', 'VALIDATION_FAILED');

        self::assertSame(0, $this->gateway->calls);
    }

    public function test_wrong_vendor_action_hostname_and_invalid_token_use_email_step_up(): void
    {
        foreach ([
            new RecaptchaAssessmentResult(true, 'vendor_login', 'localhost'),
            new RecaptchaAssessmentResult(true, 'vendor_register', 'unapproved.example.test'),
            new RecaptchaAssessmentResult(false, null, null),
        ] as $index => $assessment) {
            $this->gateway->result = $assessment;
            $payload = $this->vendorRegistration(['recaptcha_token' => 'rejected-token-'.$index]);
            $payload['email'] = "rejected-$index@example.test";
            $this->webPost('/api/v1/auth/register', $payload)
                ->assertForbidden()
                ->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');
        }

        self::assertSame(3, BotRiskChallenge::query()->count());
        self::assertSame(3, DB::table('email_otps')->where('purpose', 'BOT_RISK_STEP_UP')->count());
    }

    public function test_provider_failure_uses_the_existing_email_step_up(): void
    {
        $this->gateway->unavailable = true;

        $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'recaptcha_token' => 'provider-failure-token',
        ]))->assertForbidden()
            ->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');

        self::assertSame('PROVIDER_UNAVAILABLE', BotRiskChallenge::query()->sole()->outcome);
    }

    public function test_accessible_vendor_fallback_and_cookie_proof_remain_single_use(): void
    {
        $response = $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'request_email_step_up' => true,
        ]))->assertForbidden()
            ->assertJsonPath('errors.0.code', 'BOT_STEP_UP_REQUIRED');

        $challengeId = (string) $response->json('errors.0.details.challenge_id');
        $proof = $this->app->make(BotProtectionService::class)->verifyChallenge(
            Request::create('/api/v1/auth/bot-challenges/'.$challengeId.'/verify', 'POST'),
            $challengeId,
            'vendor@example.test',
            '123456',
            'VENDOR',
        );
        $request = Request::create('/api/v1/auth/register', 'POST', cookies: ['mp_bot_proof' => $proof->token]);
        $service = $this->app->make(BotProtectionService::class);

        self::assertTrue($service->guard(
            $request,
            'vendor@example.test',
            'VENDOR',
            'REGISTER',
            [],
            null,
            true,
        ));

        try {
            $service->guard($request, 'vendor@example.test', 'VENDOR', 'REGISTER', [], null, true);
            self::fail('A consumed proof must not be reusable.');
        } catch (AuthenticationException $exception) {
            self::assertSame('BOT_STEP_UP_INVALID', $exception->errorCode);
        }
    }

    public function test_buyer_recovery_remains_anti_enumerating_without_captcha(): void
    {
        $this->mobilePost('/api/v1/mobile/auth/password/forgot', [
            'email' => 'unknown@example.test',
        ])->assertOk()
            ->assertJsonPath('data.message', 'If the account exists, a recovery code is being delivered.');

        self::assertSame(0, $this->gateway->calls);
        self::assertSame(0, DB::table('email_otps')->count());
    }

    public function test_admin_login_requires_no_captcha(): void
    {
        User::factory()->create([
            'email' => 'admin@example.test',
            'password' => 'CorrectPassword123',
            'account_type' => 'ADMIN',
            'account_status' => 'ACTIVE',
        ]);

        $this->webPost('/api/v1/auth/login', [
            'email' => 'admin@example.test',
            'password' => 'CorrectPassword123',
            'portal' => 'ADMIN',
        ])->assertOk()->assertJsonPath('data.mfa_required', true);

        self::assertSame(0, $this->gateway->calls);
    }

    public function test_missing_vendor_provider_configuration_fails_closed(): void
    {
        config()->set('services.recaptcha.api_key', '');

        $this->webPost('/api/v1/auth/register', $this->vendorRegistration([
            'recaptcha_token' => 'checkbox-token',
        ]))->assertStatus(503)
            ->assertJsonPath('errors.0.code', 'BOT_PROTECTION_NOT_CONFIGURED');

        self::assertSame(0, BotRiskChallenge::query()->count());
    }

    /** @return array<string, mixed> */
    private function buyerRegistration(): array
    {
        return [
            'full_name' => 'Buyer Example',
            'email' => 'buyer@example.test',
            'mobile_e164' => '+639171234567',
            'password' => 'StrongPassword123',
            'password_confirmation' => 'StrongPassword123',
            'buyer_type' => 'INDIVIDUAL',
            'terms_accepted' => true,
            'privacy_accepted' => true,
        ];
    }

    /** @param array<string, mixed> $botProtection
     * @return array<string, mixed>
     */
    private function vendorRegistration(array $botProtection): array
    {
        return [
            'full_name' => 'Vendor Example',
            'email' => 'vendor@example.test',
            'mobile_e164' => '+639171234568',
            'password' => 'StrongPassword123',
            'password_confirmation' => 'StrongPassword123',
            'business_name' => 'Example Hardware',
            'terms_accepted' => true,
            'privacy_accepted' => true,
            'bot_protection' => $botProtection,
        ];
    }

    /** @param array<string, mixed> $payload */
    private function mobilePost(string $uri, array $payload): TestResponse
    {
        return $this->postJson($uri, $payload);
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
