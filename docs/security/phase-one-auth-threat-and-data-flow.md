# Phase 1 authentication threat and data flow

## Scope

This document covers Buyer and Vendor email registration, password login and
password recovery; Buyer/Vendor Google OIDC; Admin invitation-only access;
email OTP; TOTP; Vendor web reCAPTCHA Enterprise checkbox verification; and
server-driven Buyer email risk verification. Buyer, Admin, and Google OIDC
requests do not use reCAPTCHA.

## Data flow

Authentication transport is selected by server-owned routing. Browser clients use
`/api/v1/auth/*`; every state-changing browser route requires the matching
`mp_csrf` cookie and `X-CSRF-Token` header, and protected browser routes may
promote the HttpOnly access cookie to a Bearer credential. Native Buyer clients
use `/api/v1/mobile/auth/*`; those routes do not run browser CSRF or cookie-auth
middleware and return Passport access and refresh tokens in the native response.
`X-Client-Kind`, request-body `client_kind`, User-Agent, Origin, and embedded app
secrets are not transport trust signals.

1. Vendor web explicitly renders an Enterprise checkbox for each protected
   email-auth operation. The checkbox token is sent only to Laravel.
2. Laravel selects the expected Vendor action and site key, then calls Google using the
   backend API key in `x-goog-api-key`.
3. Laravel checks validity, action, configured Vendor key, and allowed hostname.
   No score threshold or mobile application binding is used.
4. Passing requests continue. Invalid assessment, accessible fallback,
   or temporary provider failure creates an email risk challenge. Missing provider
   configuration fails closed with `503`.
5. Challenge creation, hashed risk OTP creation, and encrypted outbox publication
   commit in one PostgreSQL transaction. The queue worker delivers mail; the
   scheduler recovers eligible pending outbox events.
6. Verification locks the challenge. Laravel stores only a proof hash. Vendor web
   receives the proof in a secure HttpOnly auth-path cookie. Buyer can receive a
   separate server-issued email risk proof once and retain it only in memory. The
   proof expires after five minutes and is single-use.
7. The retried operation consumes the proof while holding a row lock. Existing
   account-verification or password-reset OTPs remain separate.

## Threat controls

| Threat | Required control |
|---|---|
| Token theft or replay | Checkbox reset after submission/error/expiry, backend assessment, single-use five-minute proof |
| Cross-action or cross-client proof use | Proof binding to hashed email, portal, server action and internal server-owned channel |
| Secret exposure | Backend API key only in protected environment; no tokens, keys, OTPs, invitation URLs or raw provider responses in logs/storage |
| Email abuse | Validate login credentials before risk mail; recovery anti-enumeration sends no mail for unmatched accounts; OTP cooldown and attempt limits |
| Provider outage | Separate email risk step-up; configuration errors fail closed |
| Duplicate delivery | Encrypted transactional outbox, distributed processing lock, processed marker, bounded retry/backoff and exhausted-event filtering |
| Concurrent proof use | PostgreSQL transaction plus challenge row lock and consumed timestamp |
| Portal escalation | Server-selected portal/action, invitation-only Admin, mandatory privileged TOTP, deny-by-default authorization |

Audit records contain correlation IDs, coarse outcomes and hashed identifiers
only. They must never contain plaintext email addresses, credentials, OTPs,
proofs, provider tokens, or raw provider payloads.
