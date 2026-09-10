<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\IssuedAccessToken;
use App\Domain\Identity\TokenSessionService;
use App\Models\AuthRefreshTokenHistory;
use App\Models\AuthSession;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

final class RefreshTokenReuseTest extends TestCase
{
    use RefreshDatabase;

    public function test_reusing_a_rotated_refresh_token_commits_family_revocation(): void
    {
        $issuer = new class implements AccessTokenIssuer
        {
            private int $sequence = 0;

            /** @var list<string> */
            public array $revoked = [];

            public function issue(User $user, string $clientKind): IssuedAccessToken
            {
                $this->sequence++;

                return new IssuedAccessToken('plain-access-'.$this->sequence, 'access-id-'.$this->sequence);
            }

            public function revoke(?string $identifier): void
            {
                if ($identifier !== null) {
                    $this->revoked[] = $identifier;
                }
            }
        };
        $service = new TokenSessionService($issuer);
        $user = User::factory()->create();

        $original = $service->start($user, 'MOBILE', null, '127.0.0.1', 'test-agent');
        $rotated = $service->rotate($original->refreshToken, '127.0.0.2', 'test-agent');
        self::assertNotSame($original->refreshToken, $rotated->refreshToken);

        try {
            $service->rotate($original->refreshToken, '127.0.0.3', 'test-agent');
            self::fail('Refresh-token reuse must be rejected.');
        } catch (AuthenticationException $exception) {
            self::assertSame('REFRESH_TOKEN_REUSE_DETECTED', $exception->errorCode);
        }

        $session = AuthSession::query()->findOrFail($original->sessionId);
        self::assertNotNull($session->revoked_at);
        self::assertSame('REFRESH_TOKEN_REUSE', $session->revoke_reason);
        self::assertNotNull(
            AuthRefreshTokenHistory::query()
                ->where('auth_session_id', $session->getKey())
                ->value('reuse_detected_at'),
        );
        self::assertContains('access-id-2', $issuer->revoked);
    }

    public function test_expired_and_revoked_refresh_sessions_are_rejected(): void
    {
        $issuer = new class implements AccessTokenIssuer
        {
            private int $sequence = 0;

            public function issue(User $user, string $clientKind): IssuedAccessToken
            {
                $this->sequence++;

                return new IssuedAccessToken('plain-access-'.$this->sequence, 'access-id-'.$this->sequence);
            }

            public function revoke(?string $identifier): void {}
        };
        $service = new TokenSessionService($issuer);
        $user = User::factory()->create();

        $expired = $service->start($user, 'MOBILE', null, '127.0.0.1', 'test-agent');
        AuthSession::query()->findOrFail($expired->sessionId)->update(['expires_at' => now()->subSecond()]);
        $this->assertRefreshRejected($service, $expired->refreshToken);

        $revoked = $service->start($user, 'MOBILE', null, '127.0.0.1', 'test-agent');
        AuthSession::query()->findOrFail($revoked->sessionId)->update([
            'revoked_at' => now(),
            'revoke_reason' => 'LOGOUT',
        ]);
        $this->assertRefreshRejected($service, $revoked->refreshToken);
    }

    private function assertRefreshRejected(TokenSessionService $service, string $token): void
    {
        try {
            $service->rotate($token, '127.0.0.1', 'test-agent');
            self::fail('An expired or revoked refresh session must be rejected.');
        } catch (AuthenticationException $exception) {
            self::assertSame('REFRESH_TOKEN_INVALID', $exception->errorCode);
        }
    }
}
