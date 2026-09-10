<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\GoogleOidcService;
use App\Domain\Identity\MfaChallengeService;
use App\Domain\Identity\TokenSessionService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\AuthTransport;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\GoogleMobileExchangeRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;

final class GoogleOidcController extends Controller
{
    /** @var list<string> */
    private const WEB_REDIRECT_ERROR_CODES = [
        'PORTAL_ACCESS_DENIED',
        'ACCOUNT_NOT_FOUND',
        'ADMIN_INVITE_REQUIRED',
        'CONSENT_REQUIRED',
    ];

    public function start(Request $request, GoogleOidcService $oidc): JsonResponse
    {
        $transport = AuthTransport::fromRequest($request);
        $portal = $transport === AuthTransport::MOBILE
            ? 'BUYER'
            : strtoupper((string) $request->input('portal'));
        $input = $request->validate([
            'portal' => $transport === AuthTransport::WEB
                ? ['required', Rule::in(['VENDOR', 'ADMIN'])]
                : ['prohibited'],
            'client_kind' => ['prohibited'],
            'mode' => ['required', Rule::in(['SIGN_IN', 'SIGN_UP'])],
            'mobile_e164' => ['required_if:mode,SIGN_UP', 'nullable', 'regex:/^\+[1-9]\d{7,14}$/'],
            'buyer_type' => [Rule::requiredIf(fn (): bool => $request->input('mode') === 'SIGN_UP' && $portal === 'BUYER'), 'nullable', 'string', 'max:32'],
            'company_name' => [Rule::requiredIf(fn (): bool => $request->input('mode') === 'SIGN_UP' && $portal === 'BUYER' && $request->input('buyer_type') === 'BUSINESS'), 'nullable', 'string', 'max:180'],
            'business_name' => [Rule::requiredIf(fn (): bool => $request->input('mode') === 'SIGN_UP' && $portal === 'VENDOR'), 'nullable', 'string', 'max:180'],
            'terms_accepted' => ['sometimes', 'boolean'],
            'privacy_accepted' => ['sometimes', 'boolean'],
        ]);

        return ApiResponse::success(['authorization_url' => $oidc->authorizationUrl(
            $portal,
            $transport->value,
            (bool) ($input['terms_accepted'] ?? false),
            (bool) ($input['privacy_accepted'] ?? false),
            $input['mode'],
            $input['mobile_e164'] ?? null,
            $input['buyer_type'] ?? null,
            $input['company_name'] ?? null,
            $input['business_name'] ?? null,
        )]);
    }

    public function callback(
        Request $request,
        GoogleOidcService $oidc,
        TokenSessionService $sessions,
        AuthCookieFactory $cookies,
        AuditRecorder $audit,
        MfaChallengeService $mfa,
    ): Response {
        $input = $request->validate(['state' => ['required', 'string'], 'code' => ['required', 'string']]);
        $webContext = $oidc->webCallbackContext($input['state']);
        try {
            $result = $oidc->complete($input['state'], $input['code']);
        } catch (AuthenticationException $exception) {
            if ($webContext === null || ! in_array($exception->errorCode, self::WEB_REDIRECT_ERROR_CODES, true)) {
                throw $exception;
            }

            $audit->record($request, 'GOOGLE_OIDC_CALLBACK_FAILED', false, safeContext: [
                'error_code' => $exception->errorCode,
                'portal' => $webContext['portal'],
            ]);

            return redirect()->away($this->webCallbackDestination($webContext['portal'], [
                'status' => 'error',
                'code' => $exception->errorCode,
            ]));
        }
        if ($result->clientKind === 'MOBILE') {
            $exchangeCode = $oidc->issueMobileExchangeCode($result);
            $audit->record($request, 'GOOGLE_OIDC_CALLBACK_SUCCEEDED', true, $result->user, ['client_kind' => 'MOBILE']);
            $destination = (string) config('app.buyer_redirect_uri');
            $separator = str_contains($destination, '?') ? '&' : '?';

            return redirect()->away($destination.$separator.http_build_query([
                'exchange_code' => $exchangeCode,
            ], '', '&', PHP_QUERY_RFC3986));
        }

        $destination = $result->portal === 'ADMIN'
            ? (string) config('app.admin_frontend_url')
            : (string) config('app.vendor_frontend_url');
        if ($mfa->requiredFor($result->user)) {
            $challenge = $mfa->begin($result->user, $result->clientKind, null);
            $audit->record($request, 'MFA_CHALLENGE_REQUIRED', true, $result->user, ['source' => 'GOOGLE_OIDC']);

            return redirect()->away(rtrim($destination, '/').'/auth/mfa?source=google')
                ->withCookie($cookies->mfaChallenge($challenge));
        }

        $tokens = $sessions->start($result->user, $result->clientKind, null, $request->ip(), $request->userAgent());
        $audit->record($request, 'GOOGLE_OIDC_LOGIN_SUCCEEDED', true, $result->user);

        return redirect()->away(rtrim($destination, '/').'/auth/callback?status=success')
            ->withCookie($cookies->access($tokens))
            ->withCookie($cookies->refresh($tokens));
    }

    public function exchangeMobile(
        GoogleMobileExchangeRequest $request,
        GoogleOidcService $oidc,
        TokenSessionService $sessions,
        AuditRecorder $audit,
    ): JsonResponse {
        $result = $oidc->consumeMobileExchangeCode((string) $request->validated('exchange_code'));
        $tokens = $sessions->start(
            $result->user,
            'MOBILE',
            $request->validated('device_id'),
            $request->ip(),
            $request->userAgent(),
        );
        $audit->record($request, 'GOOGLE_OIDC_LOGIN_SUCCEEDED', true, $result->user, ['client_kind' => 'MOBILE']);

        return ApiResponse::success([
            'user' => [
                'id' => $result->user->public_id,
                'name' => $result->user->name,
                'email' => $result->user->email,
                'account_type' => $result->user->account_type,
            ],
            'session_id' => $tokens->sessionId,
            'access_token' => $tokens->accessToken,
            'refresh_token' => $tokens->refreshToken,
            'access_expires_in' => $tokens->accessExpiresIn,
            'refresh_expires_in' => $tokens->refreshExpiresIn,
            'mfa_setup_required' => false,
        ]);
    }

    /** @param array<string, string> $query */
    private function webCallbackDestination(string $portal, array $query): string
    {
        $destination = match ($portal) {
            'ADMIN' => (string) config('app.admin_frontend_url'),
            'VENDOR' => (string) config('app.vendor_frontend_url'),
            default => throw new \LogicException('Unsupported web callback portal.'),
        };

        return rtrim($destination, '/').'/auth/callback?'.http_build_query($query, '', '&', PHP_QUERY_RFC3986);
    }
}
