<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Models\ExternalIdentity;
use App\Models\User;
use Firebase\JWT\JWK;
use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

final class GoogleOidcService
{
    /** @return array{portal: string, client_kind: string}|null */
    public function webCallbackContext(string $state): ?array
    {
        $flow = Cache::get($this->cacheKey($state));
        if (! is_array($flow)
            || ($flow['client_kind'] ?? null) !== 'WEB'
            || ! in_array($flow['portal'] ?? null, ['VENDOR', 'ADMIN'], true)) {
            return null;
        }

        return [
            'portal' => (string) $flow['portal'],
            'client_kind' => 'WEB',
        ];
    }

    public function authorizationUrl(
        string $portal,
        string $clientKind,
        bool $termsAccepted,
        bool $privacyAccepted,
        string $mode,
        ?string $mobileE164,
        ?string $buyerType,
        ?string $companyName,
        ?string $businessName,
    ): string {
        $this->assertConfigured();
        if ($clientKind === 'MOBILE' && blank(config('app.buyer_redirect_uri'))) {
            throw new AuthenticationException('OIDC_NOT_CONFIGURED', 'Google sign-in is not configured for the Buyer app.', 503);
        }
        $state = $this->randomToken(32);
        $nonce = $this->randomToken(32);
        $verifier = $this->randomToken(64);
        $challenge = rtrim(strtr(base64_encode(hash('sha256', $verifier, true)), '+/', '-_'), '=');

        Cache::put($this->cacheKey($state), [
            'nonce' => $nonce,
            'verifier' => $verifier,
            'portal' => $portal,
            'client_kind' => $clientKind,
            'terms_accepted' => $termsAccepted,
            'privacy_accepted' => $privacyAccepted,
            'mode' => $mode,
            'mobile_e164' => $mobileE164,
            'buyer_type' => $buyerType,
            'company_name' => $companyName,
            'business_name' => $businessName,
        ], now()->addMinutes(10));

        return config('services.google_oidc.authorization_endpoint').'?'.http_build_query([
            'client_id' => config('services.google_oidc.client_id'),
            'redirect_uri' => config('services.google_oidc.redirect_uri'),
            'response_type' => 'code',
            'scope' => 'openid email profile',
            'state' => $state,
            'nonce' => $nonce,
            'code_challenge' => $challenge,
            'code_challenge_method' => 'S256',
            'prompt' => 'select_account',
        ], '', '&', PHP_QUERY_RFC3986);
    }

    public function complete(string $state, string $code): GoogleOidcResult
    {
        $this->assertConfigured();
        $key = $this->cacheKey($state);
        $flow = Cache::pull($key);
        if (! is_array($flow)) {
            throw new AuthenticationException('OIDC_STATE_INVALID', 'The Google sign-in request expired. Please try again.', 401);
        }

        $tokenResponse = Http::asForm()->timeout(10)->post((string) config('services.google_oidc.token_endpoint'), [
            'client_id' => config('services.google_oidc.client_id'),
            'client_secret' => config('services.google_oidc.client_secret'),
            'redirect_uri' => config('services.google_oidc.redirect_uri'),
            'grant_type' => 'authorization_code',
            'code' => $code,
            'code_verifier' => $flow['verifier'],
        ]);
        if (! $tokenResponse->successful() || ! is_string($tokenResponse->json('id_token'))) {
            throw new AuthenticationException('OIDC_EXCHANGE_FAILED', 'Google sign-in could not be completed.', 401);
        }

        $claims = $this->verifiedClaims($tokenResponse->json('id_token'));
        if (($claims['nonce'] ?? null) !== $flow['nonce'] || ($claims['email_verified'] ?? false) !== true) {
            throw new AuthenticationException('OIDC_TOKEN_INVALID', 'Google sign-in could not be verified.', 401);
        }

        $portal = (string) $flow['portal'];
        $user = DB::transaction(function () use ($claims, $portal, $flow): User {
            $identity = ExternalIdentity::query()
                ->where('provider', 'GOOGLE')
                ->where('provider_subject', $claims['sub'])
                ->first();
            if ($identity !== null) {
                return User::query()->findOrFail($identity->user_id);
            }

            $email = mb_strtolower(trim((string) $claims['email']));
            $user = User::query()->whereRaw('LOWER(email) = ?', [$email])->first();
            if ($user === null) {
                if ($flow['mode'] !== 'SIGN_UP') {
                    throw new AuthenticationException('ACCOUNT_NOT_FOUND', 'No MateryalPH account is linked to this Google identity.', 404);
                }
                if ($portal === 'ADMIN') {
                    throw new AuthenticationException('ADMIN_INVITE_REQUIRED', 'Admin access requires an invitation.', 403);
                }
                if (! $flow['terms_accepted'] || ! $flow['privacy_accepted']) {
                    throw new AuthenticationException('CONSENT_REQUIRED', 'Accept the Terms and Privacy Notice to create an account.');
                }
                $user = User::query()->create([
                    'name' => trim((string) ($claims['name'] ?? 'MateryalPH user')),
                    'email' => $email,
                    'password' => Hash::make($this->randomToken(64)),
                    'account_type' => $portal,
                    'account_status' => 'ACTIVE',
                    'email_verified_at' => now(),
                ]);
                DB::table('user_profiles')->insert([
                    'id' => (string) Str::uuid7(),
                    'user_id' => $user->getKey(),
                    'full_name' => $user->name,
                    'mobile_e164' => $flow['mobile_e164'],
                    'locale' => 'en',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
                $this->createRoleFoundation($user, $portal, $flow);
                $this->recordAgreements($user, $portal);
            }
            if ($user->account_type !== $portal || $user->account_status !== 'ACTIVE') {
                throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot sign in to the selected portal.', 403);
            }
            ExternalIdentity::query()->create([
                'user_id' => $user->getKey(),
                'provider' => 'GOOGLE',
                'provider_subject' => (string) $claims['sub'],
                'email_at_link' => $email,
                'linked_at' => now(),
            ]);

            return $user;
        });

        return new GoogleOidcResult($user, $portal, (string) $flow['client_kind']);
    }

    public function issueMobileExchangeCode(GoogleOidcResult $result): string
    {
        if ($result->clientKind !== 'MOBILE' || $result->portal !== 'BUYER') {
            throw new AuthenticationException('OIDC_CLIENT_INVALID', 'The Google sign-in client is not supported.', 422);
        }

        $code = $this->randomToken(32);
        Cache::put($this->mobileExchangeCacheKey($code), [
            'user_id' => $result->user->getKey(),
            'portal' => $result->portal,
        ], now()->addMinutes(2));

        return $code;
    }

    public function consumeMobileExchangeCode(string $code): GoogleOidcResult
    {
        $grant = Cache::pull($this->mobileExchangeCacheKey($code));
        if (! is_array($grant) || ($grant['portal'] ?? null) !== 'BUYER') {
            throw new AuthenticationException('OIDC_EXCHANGE_CODE_INVALID', 'The mobile sign-in request expired. Please try again.', 401);
        }

        $user = User::query()->find($grant['user_id'] ?? null);
        if ($user === null || $user->account_type !== 'BUYER' || $user->account_status !== 'ACTIVE') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot sign in to the Buyer app.', 403);
        }

        return new GoogleOidcResult($user, 'BUYER', 'MOBILE');
    }

    /** @return array<string, mixed> */
    private function verifiedClaims(string $idToken): array
    {
        $jwks = Cache::remember('google-oidc-jwks', now()->addHours(6), function (): array {
            $response = Http::timeout(10)->get((string) config('services.google_oidc.jwks_uri'));
            if (! $response->successful()) {
                throw new AuthenticationException('OIDC_KEYS_UNAVAILABLE', 'Google sign-in is temporarily unavailable.', 503);
            }

            return $response->json();
        });
        JWT::$leeway = 60;
        $claims = (array) JWT::decode($idToken, JWK::parseKeySet($jwks, 'RS256'));
        $issuer = $claims['iss'] ?? null;
        if (! in_array($issuer, ['https://accounts.google.com', 'accounts.google.com'], true)
            || ($claims['aud'] ?? null) !== config('services.google_oidc.client_id')
            || ! is_string($claims['sub'] ?? null)
            || ! is_string($claims['email'] ?? null)) {
            throw new AuthenticationException('OIDC_TOKEN_INVALID', 'Google sign-in could not be verified.', 401);
        }

        return $claims;
    }

    private function recordAgreements(User $user, string $audience): void
    {
        $versions = DB::table('agreement_versions as av')
            ->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')
            ->whereIn('ad.audience', ['ALL', $audience])
            ->whereIn('ad.code', ['TERMS_OF_SERVICE', 'PRIVACY_NOTICE'])
            ->whereNull('av.retired_at')
            ->where('av.effective_at', '<=', now())
            ->pluck('av.id');
        if ($versions->count() !== 2) {
            throw new AuthenticationException('AGREEMENTS_NOT_CONFIGURED', 'Registration is temporarily unavailable.', 503);
        }
        foreach ($versions as $versionId) {
            DB::table('agreement_acceptances')->insert([
                'id' => (string) Str::uuid7(),
                'user_id' => $user->getKey(),
                'agreement_version_id' => $versionId,
                'vendor_organization_id' => null,
                'source' => 'GOOGLE_OIDC',
                'accepted_at' => now(),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }

    /** @param array<string, mixed> $flow */
    private function createRoleFoundation(User $user, string $portal, array $flow): void
    {
        if ($portal === 'BUYER') {
            DB::table('buyer_profiles')->insert([
                'id' => (string) Str::uuid7(),
                'user_id' => $user->getKey(),
                'buyer_type' => $flow['buyer_type'],
                'company_name' => $flow['company_name'],
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            return;
        }

        $organizationId = (string) Str::uuid7();
        DB::table('vendor_organizations')->insert([
            'id' => $organizationId,
            'legal_name' => $flow['business_name'],
            'store_name' => $flow['business_name'],
            'account_status' => 'ACTIVE',
            'onboarding_status' => 'NOT_STARTED',
            'marketplace_status' => 'NOT_ACTIVE',
            'bulk_order_capable' => false,
            'lock_version' => 1,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('vendor_memberships')->insert([
            'id' => (string) Str::uuid7(),
            'vendor_organization_id' => $organizationId,
            'user_id' => $user->getKey(),
            'role' => 'OWNER',
            'can_manage_staff' => false,
            'status' => 'ACTIVE',
            'activated_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function assertConfigured(): void
    {
        foreach (['client_id', 'client_secret', 'redirect_uri'] as $key) {
            if (blank(config('services.google_oidc.'.$key))) {
                throw new AuthenticationException('OIDC_NOT_CONFIGURED', 'Google sign-in is not configured.', 503);
            }
        }
    }

    private function cacheKey(string $state): string
    {
        return 'oidc:'.hash('sha256', $state);
    }

    private function mobileExchangeCacheKey(string $code): string
    {
        return 'oidc-mobile-exchange:'.hash('sha256', $code);
    }

    private function randomToken(int $bytes): string
    {
        return rtrim(strtr(base64_encode(random_bytes($bytes)), '+/', '-_'), '=');
    }
}
