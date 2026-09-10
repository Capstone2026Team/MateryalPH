<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\RecaptchaProviderUnavailable;
use App\Infrastructure\Identity\GoogleRecaptchaEnterpriseGateway;
use Illuminate\Http\Client\Request;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

final class RecaptchaGatewayTest extends TestCase
{
    public function test_assessment_uses_header_credentials_and_server_selected_action(): void
    {
        config()->set('services.recaptcha.project_id', 'test-project');
        config()->set('services.recaptcha.api_key', 'test-key');
        Http::preventStrayRequests();
        Http::fake(['*' => Http::response([
            'tokenProperties' => ['valid' => true, 'action' => 'vendor_login', 'hostname' => 'localhost'],
        ])]);
        $result = (new GoogleRecaptchaEnterpriseGateway)->assess('test-token', 'test-site', 'vendor_login');
        self::assertTrue($result->valid);
        self::assertSame('localhost', $result->hostname);
        Http::assertSent(fn (Request $request): bool => $request->url() === 'https://recaptchaenterprise.googleapis.com/v1/projects/test-project/assessments'
            && $request->hasHeader('x-goog-api-key', 'test-key')
            && $request['event'] === ['token' => 'test-token', 'siteKey' => 'test-site', 'expectedAction' => 'vendor_login']);
    }

    public function test_permission_failure_is_configuration_error_without_provider_details(): void
    {
        Http::fake(['*' => Http::response(['error' => 'private-provider-detail'], 403)]);
        try {
            (new GoogleRecaptchaEnterpriseGateway)->assess('test-token', 'test-site', 'vendor_login');
            self::fail('Provider permission failure must fail closed.');
        } catch (AuthenticationException $exception) {
            self::assertSame(503, $exception->httpStatus);
            self::assertStringNotContainsString('private-provider-detail', $exception->getMessage());
            self::assertNull($exception->getPrevious());
        }
    }

    public function test_provider_outage_is_replaceable_by_email_step_up(): void
    {
        Http::fake(['*' => Http::response([], 503)]);
        $this->expectException(RecaptchaProviderUnavailable::class);
        (new GoogleRecaptchaEnterpriseGateway)->assess('test-token', 'test-site', 'vendor_login');
    }

    public function test_malformed_assessments_never_coerce_into_success(): void
    {
        foreach ([
            ['tokenProperties' => ['valid' => 'false']],
            ['tokenProperties' => []],
            [],
        ] as $payload) {
            Http::fake(['*' => Http::response($payload)]);
            try {
                (new GoogleRecaptchaEnterpriseGateway)->assess('test-token', 'test-site', 'vendor_login');
                self::fail('Malformed assessment must use the unavailable-provider path.');
            } catch (RecaptchaProviderUnavailable $exception) {
                self::assertNull($exception->getPrevious());
            }
        }
    }

    public function test_invalid_token_without_score_is_a_rejected_assessment(): void
    {
        Http::fake(['*' => Http::response(['tokenProperties' => ['valid' => false]])]);
        $result = (new GoogleRecaptchaEnterpriseGateway)->assess('test-token', 'test-site', 'vendor_login');
        self::assertFalse($result->valid);
    }
}
