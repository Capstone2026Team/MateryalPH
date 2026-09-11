<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use Tests\TestCase;

final class GoogleCallbackPresentationTest extends TestCase
{
    public function test_browser_cancellation_has_safe_actions_and_no_callback_values(): void
    {
        config()->set('app.vendor_frontend_url', 'https://vendor.example.test');
        config()->set('app.buyer_redirect_uri', 'materyalph://auth/callback');
        $response = $this->withHeader('Accept', 'text/html')->get('/api/v1/auth/google/callback?error=access_denied&state=private-callback-value');

        $response->assertStatus(422)
            ->assertSee('Google sign-in was cancelled')
            ->assertSee('https://vendor.example.test/login')
            ->assertSee('materyalph://auth/callback')
            ->assertDontSee('private-callback-value')
            ->assertHeader('Referrer-Policy', 'no-referrer');
        self::assertStringContainsString('no-store', (string) $response->headers->get('Cache-Control'));
        self::assertSame([], $response->headers->getCookies());
    }

    public function test_json_callback_validation_keeps_the_api_error_envelope(): void
    {
        $this->getJson('/api/v1/auth/google/callback?error=access_denied')
            ->assertStatus(422)
            ->assertJsonStructure(['data', 'meta', 'errors'])
            ->assertDontSee('<html');
    }
}
