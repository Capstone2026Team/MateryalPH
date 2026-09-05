# ADR 0001: Use Laravel Passport for API authentication

- Status: Accepted
- Date: 2026-09-05
- Scope: API authentication architecture; implementation begins in Phase 1

## Context

The approved MateryalPH workflows require OAuth 2.0 Authorization Code with PKCE, short-lived signed access tokens, rotating and revocable refresh-token sessions, device/session revocation, and secure client-specific storage. Vendor and Admin web tokens must be delivered through `Secure`, `HttpOnly` cookies with CSRF protection; Buyer mobile tokens must use operating-system secure storage.

The early Laravel scaffold currently declares `laravel/sanctum`. That dependency predates the approved technical design and does not make Sanctum the primary MateryalPH authentication architecture.

## Decision

Laravel Passport is the single approved primary API authentication system. Phase 1 will install and configure Passport using the Laravel 13-supported path, explicitly configure the API guard, load signing keys from protected environment configuration, and add authorization-code/PKCE, expiry, refresh rotation, reuse detection, and revocation tests.

This repository-alignment checkpoint does not install Passport or remove Sanctum. Removing the existing package before Passport is installed and equivalently tested would leave the scaffold in a partially migrated dependency state. Sanctum must not be configured as a competing primary API guard during the transition.

## Consequences

- Phase 1 owns the tested package transition and removal of the obsolete Sanctum dependency.
- Only Passport may become the primary protected API guard.
- Browser redirects never establish authentication or payment success by themselves.
- Passport private keys and refresh/access tokens must never be committed, logged, or exposed to web/mobile bundles.
- Authentication endpoints, database tables, and business behavior are intentionally outside this checkpoint.
