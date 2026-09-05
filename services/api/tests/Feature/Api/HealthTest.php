<?php

namespace Tests\Feature\Api;

use Tests\TestCase;

class HealthTest extends TestCase
{
    public function test_the_versioned_api_health_endpoint_is_available(): void
    {
        $this->getJson('/api/v1/health')
            ->assertOk()
            ->assertJsonPath('status', 'ok');
    }
}
