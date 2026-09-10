# ADR-002: Phase 1 runtime, identity, and finance boundaries

- Status: Accepted for Phase 1
- Date: 2026-09-08
- Decision owners: MateryalPH project team

## Context

Phase 1 must establish a deployable foundation without implying that later commerce, analytics, compliance, or operational workflows are production-ready. The approved workflows require one versioned REST boundary, explicit portal isolation, mandatory high-privilege MFA, auditable finance records, and no direct client access to infrastructure or provider secrets.

## Decision

MateryalPH uses a Laravel 13 modular monolith on PHP 8.4. All Buyer, Vendor, and Admin clients call `/api/v1`; PostgreSQL 16 with PostGIS, `pg_trgm`, and `pgcrypto` is the source of record; Redis supports cache and queues; and Laravel Passport provides first-party access and refresh tokens.

Browser sessions use Secure, HttpOnly cookies with CSRF protection. Buyer mobile tokens use OS secure storage. Refresh tokens rotate, and reuse revokes the affected session family. Email OTP and password-recovery codes are short-lived, attempt-limited, single-use, and stored only as keyed hashes. Admin accounts are invitation-only. TOTP enrollment and challenge are mandatory for Admin users and for Vendor Owner and Store Manager roles, with one-time hashed recovery codes.

OTP issuance and initial Admin invitations use the transactional outbox. Credential invalidation or invitation creation and outbox publication commit together. Recipient addresses, plaintext OTPs, and invitation URLs exist in the outbox only as one application-encrypted sealed payload. After commit, queued jobs deliver supported event types; the scheduler recovers eligible pending rows with `materyalph:outbox-dispatch`. Processing is guarded by a distributed lock and a `processed_at` marker, uses bounded backoff, and stops automatic retries after five recorded failures so poison events require explicit operational investigation.

OpenAPI 3.1 is the canonical transport contract. TypeScript and Dart clients are generated and checked for drift in CI. Business rules remain in domain actions and services; controllers handle transport validation and authorization only.

Finance is restricted to `TEST` or `DEMO` mode in Phase 1. Live commerce is disabled. The approved Vendor-paid commission is 2% of completed materials after Vendor discounts and excluding included Vendor VAT, billed on the monthly cycle. Provider processing fees, tax or withholding scenarios, refunds, disputes, physical-payment records, and ledger postings remain separate evidence-backed records. Xendit is used only when explicitly configured in test mode. There is no BIR API integration.

Non-secret finance and analytics switches are read only by the backend through `config/finance.php`. Local setup selects `DEMO`, `DEMO_PLATFORM_WITHHOLDER`, and `DEMO_NONVAT`, keeps live commerce off, and identifies the isolated demo dataset; `.env.example` deliberately leaves those decision values blank.

Materials analytics is disabled by default and limited to approved public-listing evidence and explicitly versioned demonstration datasets. It must not expose exact private inventory, Buyer coordinates, private Vendor documents, or claim government verification.

## Consequences

- Portal role isolation and deny-by-default authorization apply at every protected API boundary.
- Financial snapshots, published quotations, compliance decisions, payment and refund events, and audit records are immutable; corrections use versions or compensating records.
- Local and CI infrastructure must use PostGIS rather than a simplified database substitute.
- Provider secrets stay server-side and are supplied only through ignored environment files or protected deployment secret fields.
- API, queue-worker, and scheduler processes are all required for OTP and Admin-invitation delivery; a committed outbox row remains recoverable when queue publication is temporarily unavailable.
- Email delivery is an external at-least-once boundary. The processed marker prevents ordinary duplicate job handling, while single-use OTP and invitation records remain the authority if a provider accepted mail immediately before a worker interruption.
- Operational dashboards and live provider actions are intentionally deferred until their approved workflow phases.

## Production gates

Production remains blocked until final legal text is approved, provider credentials and webhook validation are configured in protected environments, release and recovery checks pass, a production security review is complete, and live-commerce enablement receives explicit approval.
