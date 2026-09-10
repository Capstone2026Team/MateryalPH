<?php

declare(strict_types=1);

namespace App\Infrastructure\Identity;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\RecaptchaAssessmentGateway;
use App\Domain\Identity\RecaptchaAssessmentResult;
use App\Domain\Identity\RecaptchaProviderUnavailable;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;
use Throwable;

final class GoogleRecaptchaEnterpriseGateway implements RecaptchaAssessmentGateway
{
    public function assess(string $token, string $siteKey, string $expectedAction): RecaptchaAssessmentResult
    {
        $projectId = (string) config('services.recaptcha.project_id');
        $apiKey = (string) config('services.recaptcha.api_key');
        $timeout = (int) config('services.recaptcha.timeout_seconds', 5);

        try {
            $response = Http::acceptJson()
                ->asJson()
                ->withHeaders(['x-goog-api-key' => $apiKey])
                ->timeout($timeout)
                ->post(
                    'https://recaptchaenterprise.googleapis.com/v1/projects/'.rawurlencode($projectId).'/assessments',
                    [
                        'event' => [
                            'token' => $token,
                            'siteKey' => $siteKey,
                            'expectedAction' => $expectedAction,
                        ],
                    ],
                );
        } catch (ConnectionException) {
            throw new RecaptchaProviderUnavailable('reCAPTCHA Enterprise is unavailable.');
        } catch (Throwable) {
            throw new RecaptchaProviderUnavailable('reCAPTCHA Enterprise assessment failed.');
        }

        if ($response->serverError() || $response->status() === 429) {
            throw new RecaptchaProviderUnavailable('reCAPTCHA Enterprise is unavailable.');
        }
        if (! $response->successful()) {
            throw new AuthenticationException('BOT_PROTECTION_NOT_CONFIGURED', 'Bot protection is unavailable for this client.', 503);
        }

        $valid = $response->json('tokenProperties.valid');
        // Never coerce malformed provider fields into a passing assessment.
        // Unknown additional fields remain harmless and are ignored.
        if (! is_bool($valid)) {
            throw new RecaptchaProviderUnavailable('reCAPTCHA Enterprise returned an unusable assessment.');
        }

        return new RecaptchaAssessmentResult(
            valid: $valid,
            action: $this->nullableString($response->json('tokenProperties.action')),
            hostname: $this->nullableString($response->json('tokenProperties.hostname')),
        );
    }

    private function nullableString(mixed $value): ?string
    {
        return is_string($value) && $value !== '' ? $value : null;
    }
}
