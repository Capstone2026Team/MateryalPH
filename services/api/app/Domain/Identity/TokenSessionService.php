<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\AuthRefreshTokenHistory;
use App\Models\AuthSession;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class TokenSessionService
{
    public function __construct(private readonly AccessTokenIssuer $accessTokens) {}

    public function start(User $user, string $clientKind, ?string $deviceId, ?string $ipAddress, ?string $userAgent): AuthTokenPair
    {
        $refresh = $this->newRefreshToken();
        $access = $this->accessTokens->issue($user, $clientKind);
        $refreshSeconds = (int) config('materyalph.auth.refresh_token_days', 14) * 86400;

        $session = AuthSession::query()->create([
            'user_id' => $user->getKey(),
            'family_id' => (string) Str::uuid7(),
            'device_id' => $deviceId,
            'refresh_token_hash' => $this->hash($refresh),
            'oauth_access_token_id' => $access->identifier,
            'client_kind' => $clientKind,
            'ip_address' => $ipAddress,
            'user_agent_hash' => $userAgent === null ? null : hash('sha256', $userAgent),
            'last_used_at' => now(),
            'expires_at' => now()->addSeconds($refreshSeconds),
        ]);

        return $this->pair($access->plainText, $refresh, $session, $refreshSeconds);
    }

    public function rotate(string $plainRefreshToken, ?string $ipAddress, ?string $userAgent): AuthTokenPair
    {
        $tokens = DB::transaction(function () use ($plainRefreshToken, $ipAddress, $userAgent): ?AuthTokenPair {
            $hash = $this->hash($plainRefreshToken);
            /** @var AuthSession|null $session */
            $session = AuthSession::query()->where('refresh_token_hash', $hash)->lockForUpdate()->first();

            if ($session === null) {
                $history = AuthRefreshTokenHistory::query()->where('token_hash', $hash)->lockForUpdate()->first();
                if ($history !== null) {
                    $history->update(['reuse_detected_at' => now()]);
                    $session = AuthSession::query()->whereKey($history->auth_session_id)->first();
                    if ($session !== null) {
                        AuthSession::query()->where('family_id', $session->family_id)->update([
                            'revoked_at' => now(),
                            'revoke_reason' => 'REFRESH_TOKEN_REUSE',
                        ]);
                        $this->accessTokens->revoke($session->oauth_access_token_id);
                    }

                    return null;
                }
            }

            if ($session === null || $session->revoked_at !== null || $session->expires_at->isPast()) {
                throw new AuthenticationException('REFRESH_TOKEN_INVALID', 'The session has expired. Please sign in again.', 401);
            }

            $user = $session->user;
            $newRefresh = $this->newRefreshToken();
            $access = $this->accessTokens->issue($user, $session->client_kind);
            $refreshSeconds = (int) config('materyalph.auth.refresh_token_days', 14) * 86400;
            $this->accessTokens->revoke($session->oauth_access_token_id);

            AuthRefreshTokenHistory::query()->create([
                'auth_session_id' => $session->getKey(),
                'family_id' => $session->family_id,
                'token_hash' => $session->refresh_token_hash,
                'rotated_at' => now(),
            ]);

            $session->update([
                'previous_refresh_token_hash' => $session->refresh_token_hash,
                'refresh_token_hash' => $this->hash($newRefresh),
                'oauth_access_token_id' => $access->identifier,
                'ip_address' => $ipAddress,
                'user_agent_hash' => $userAgent === null ? null : hash('sha256', $userAgent),
                'last_used_at' => now(),
                'expires_at' => now()->addSeconds($refreshSeconds),
            ]);

            return $this->pair($access->plainText, $newRefresh, $session->refresh(), $refreshSeconds);
        });

        if ($tokens === null) {
            throw new AuthenticationException('REFRESH_TOKEN_REUSE_DETECTED', 'This session was revoked. Please sign in again.', 401);
        }

        return $tokens;
    }

    public function revoke(AuthSession $session, string $reason = 'LOGOUT'): void
    {
        $session->update(['revoked_at' => now(), 'revoke_reason' => $reason]);
        $this->accessTokens->revoke($session->oauth_access_token_id);
    }

    private function pair(string $access, string $refresh, AuthSession $session, int $refreshSeconds): AuthTokenPair
    {
        return new AuthTokenPair(
            $access,
            $refresh,
            (string) $session->getKey(),
            (int) config('materyalph.auth.access_token_minutes', 15) * 60,
            $refreshSeconds,
        );
    }

    private function newRefreshToken(): string
    {
        return rtrim(strtr(base64_encode(random_bytes(48)), '+/', '-_'), '=');
    }

    private function hash(string $token): string
    {
        return hash_hmac('sha256', $token, (string) config('app.key'));
    }
}
