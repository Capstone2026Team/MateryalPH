# MateryalPH Implementation Phases and Codex Prompt Pack

**Plan date:** 4 September 2026; repository/UI baseline updated 5 September 2026  
**Starting point:** Existing early-stage GitHub monorepo requiring one approved path and frontend-standardization checkpoint  
**Repository model:** Monorepo  
**Deployment target:** Managed platform using Render as the reference implementation  

## How to Use This Guide in VS Code

1. Clone/open `Capstone2026Team/MateryalPH` in VS Code and confirm the intended branch.
2. Complete the one-time repository alignment below before feature work.
3. Place the four approved workflow documents under `docs/workflows/`.
4. Place `MateryalPH_Technical_System_Design.md` under `docs/architecture/` and `MateryalPH_UI_UX_Implementation_Planner.md` under `docs/design/`.
5. Copy the supplied repository-instructions template to the repository root and rename it `AGENTS.md`.
6. Install and initialize Impeccable only after reviewing the exact project-local files/hooks it adds, then approve its Codex hook through `/hooks`.
7. Open the Codex sidebar. For a complex phase, use Plan mode first, then allow implementation after reviewing the plan.
8. Paste only one phase prompt at a time. Do not ask Codex to implement several phases in one request.
9. Review the diff, UI evidence, Impeccable findings, and test output. Resolve all failures before accepting the phase.
10. Make a Git checkpoint after acceptance. Never include a real `.env` file or credential artifact.

OpenAI's official Codex guidance recommends prompts that clearly state the goal, relevant context, constraints, and definition of done. It also recommends `AGENTS.md` for durable repository rules and testing before accepting changes. See [Codex best practices](https://learn.chatgpt.com/guides/best-practices) and [AGENTS.md guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

## Rules Applied to Every Phase

Every Codex prompt below requires these behaviors:

- Read `AGENTS.md`, the technical design, UI/UX planner, the four workflows, the OpenAPI contract, and relevant Architecture Decision Records before editing.
- Inspect the current code and migration history; do not recreate completed features.
- State any material unresolved assumption and ask before implementing it.
- Keep all secrets out of code, tests, fixtures, logs, screenshots, generated clients, and Git.
- Add only blank/example names to `.env.example` files.
- Use server-side authorization, transactions, state-transition validation, idempotency, audit events, and accessible UI patterns where relevant.
- Add or update automated tests and the OpenAPI contract in the same change.
- Run the phase's validation commands and report exact results.
- Do not deploy, push, merge, rotate credentials, or use Production keys unless the prompt explicitly authorizes it and the user confirms.
- End with changed files, migrations, commands run, test results, security notes, manual verification steps, and a suggested conventional commit message.

## One-Time Repository Alignment Before Phase 1

The repository is still small enough to standardize safely. Make one reviewed Git checkpoint that:

- Moves `Flutter_Mobile_Interface_Buyer` to `apps/buyer-mobile`.
- Moves `React_Web_interface_Vendor` to `apps/vendor-web`.
- Moves `React_Web_interface_Admin` to `apps/admin-web`.
- Moves `Laravel_Main Application` to `services/api`.
- Creates `packages/api-contract`, `packages/design-tokens`, `packages/web-ui`, and `packages/shared-config`.
- Migrates the Vendor/Admin JSX scaffolds to strict TypeScript while keeping React 19 and Vite 8.
- Adds Tailwind through a shared semantic-token preset rather than raw per-page colors.
- Corrects README references to Laravel 13 and PHP 8.4.
- Verifies the intended Passport-versus-current-Sanctum authentication ADR before keeping/removing either package.
- Installs Impeccable project-locally for Codex, initializes `PRODUCT.md`/`DESIGN.md` from approved documents, adds its official ephemeral-output ignore block, and records the narrow Inter exception.

Use Git-aware moves and preserve existing files/history. Do not combine this structural checkpoint with business features. Run all existing application tests/startup checks before and after the move.

## Phase Map

| Phase | Complete increment | External credentials needed |
| ---: | --- | --- |
| 1 | Full baseline schema, authentication for all platforms, Vendor landing page | Google OIDC for complete social login; local email uses Mailpit |
| 2 | Authorization, profiles, agreements, sessions, and account administration | None |
| 3 | Vendor onboarding, verification, activation, and team accounts | Private object storage; email outside local development |
| 4 | Taxonomy, listings, media, and PS/ICC compliance | Object storage; OCR/QR services only if enabled |
| 5 | Inventory, pricing, delivery configuration, and auto-accept policies | Google Routes for final delivery estimates |
| 6 | Buyer onboarding, locations, Google map, PSGC, and directory suppliers | Google Maps, Places, Routes, and geocoding keys |
| 7 | Item-Based catalog, SRS, favorites, cart, and checkout preview | Google services already configured |
| 8 | Order core, Vendor confirmation, NRPC, reservations, and auto-accept | None |
| 9 | Real-time messaging and shared Order-from-Chat quotation engine | Reverb configuration; push optional until Phase 15 |
| 10 | Project-Based procurement, Work Packages, FMS, and budgets | Google services already configured |
| 11 | Xendit checkout, fees, webhooks, and reconciliation | Xendit Test Mode secret key and callback token |
| 12 | Fulfillment, cancellations, and automatic Cancellation Refunds | Xendit Test Mode |
| 13 | Disputes, appeals, Dispute-Conclusion Refunds, and invoice requests | Xendit Test Mode; private storage; email |
| 14 | Reviews, scores, badges, and price trends | None |
| 15 | Notifications, reminders, PDFs, and exports | Firebase service credentials; email; storage |
| 16 | Admin queues, settings, audit search, and Philippine analytics map | Map browser key; PSGC boundary data source |
| 17 | Security, privacy, accessibility, and performance hardening | reCAPTCHA keys if enabled; Sentry credentials |
| 18 | End-to-end testing, UAT, failure simulation, and recovery | All Staging/Test credentials |
| 19 | CI/CD and Staging deployment | GitHub and Render environment secrets |
| 20 | Production-readiness gate and controlled release | Production keys only after approvals |

---

# Phase 1: Database Schema, Three-Platform Authentication, and Vendor Landing Page

## Outcome

The aligned early-stage repository becomes a runnable monorepo with the complete baseline database schema, Laravel API, themed Flutter Buyer shell, React Vendor portal, React Admin portal, local Docker services, secure authentication, shared design tokens, and a responsive Vendor public landing page.

This phase is intentionally divided into five implementation portions but remains one acceptance phase:

1. Repository and secret-safety foundation.
2. Local infrastructure and application scaffolding.
3. Complete version-one database schema and ERD.
4. Shared authentication implemented in all three clients.
5. Vendor landing page and authentication navigation.

## Required Implementation

- Create `.gitignore` before any `.env` file and verify tracked files with `git status`.
- Preserve the aligned monorepo exactly as defined by the technical design; do not recreate or delete the existing scaffold.
- Create the shared design-token source, generated Flutter tokens, Tailwind semantic aliases, and accessible React primitives defined by the UI/UX planner.
- Add Docker Compose for PostgreSQL 16/PostGIS, Redis-compatible cache, Mailpit, and local S3-compatible storage.
- Enable `postgis`, `pg_trgm`, and `pgcrypto` in a controlled migration.
- Create the full baseline tables, foreign keys, checks, indexes, unique constraints, and factories listed in the technical design.
- Generate an ERD from the actual migrations and create a data-dictionary starting point.
- Install Laravel Passport, configure short-lived access tokens and refresh sessions, and load signing keys only from ignored local environment values or deployment secret configuration.
- Implement email/password registration with hashed one-time email OTP, login, refresh, logout, password recovery, session revocation, and generic account responses.
- Implement Google Authorization Code flow with PKCE and backend ID-token validation. Store `sub` in `external_identities`.
- Implement TOTP enrollment/challenge/recovery-code foundations for Vendor Owner, delegated Store Manager, and Admin.
- Buyer Flutter: Sign Up, Verify Email, Sign In, Google Sign In, Forgot Password, Reset Password, and authentication loading/error states.
- Vendor React: public landing page, Sign Up, Verify Email, Sign In, Google Sign In, Forgot/Reset Password, and initial TOTP screen.
- Admin React: Sign In, TOTP challenge, recovery start, and no public sign-up.
- Add secure-cookie configuration for web and secure-storage abstraction for Flutter.
- Create protected Super Admin invitation/seed command with no default password.
- Add OpenAPI authentication paths, generated clients, tests, rate limits, audit events, and correlation IDs.

## Phase 1 API/Key Step

Local email uses Mailpit and needs no credential. To complete Google login, follow the Google section in `MateryalPH_Environment_and_API_Key_Setup.md`; paste the Development client IDs and backend client secret into ignored local environment files, never into the Codex prompt.

## Acceptance Gate

- A clean clone starts through the documented setup without hidden manual steps.
- All migrations run from an empty database and roll back safely in Development.
- Duplicate email, expired/reused OTP, wrong password, rate limit, revoked session, stale refresh token, Google account mismatch, and invalid TOTP cases are tested.
- Buyer and Vendor can register by email; Buyer/Vendor Google flow works with Development credentials.
- Admin cannot self-register and can activate only through the protected invitation flow.
- Vendor landing page is responsive, keyboard accessible, accurately states the marketplace, and links correctly to Sign Up and Sign In.
- No real secret is tracked or printed by application tests.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 1: complete baseline database schema, authentication for the Buyer Flutter app, Vendor React portal, and Admin React portal, plus the public Vendor landing page.

Before editing, read AGENTS.md, docs/architecture/MateryalPH_Technical_System_Design.md, docs/design/MateryalPH_UI_UX_Implementation_Planner.md, and all four files under docs/workflows. Inspect the current aligned repository and present a short implementation plan grouped as 1) secret-safe repo validation, 2) local infrastructure and scaffold alignment, 3) full v1 schema and ERD, 4) backend and three-client authentication, 5) shared UI foundation, and 6) Vendor landing page. Ask before coding only if a material requirement is genuinely unresolved.

Preserve the approved monorepo: apps/buyer-mobile, apps/vendor-web, apps/admin-web, services/api, packages/api-contract, packages/design-tokens, packages/web-ui, docs, infrastructure, and GitHub workflow directories. If the one-time repository alignment is not complete, stop and propose it as a separate Git-aware checkpoint before Phase 1. Validate .gitignore before any real environment file. Add blank .env.example files only. Add Docker Compose for PostgreSQL 16/PostGIS, Redis, Mailpit, and local S3-compatible storage.

Use Laravel 13 constrained as ^13.0, PHP 8.4, PostgreSQL 16 with postgis/pg_trgm/pgcrypto, Laravel Passport installed with `php artisan install:api --passport`, React 19/TypeScript/Vite 8/Tailwind, and Flutter/Dart. Do not leave Sanctum and Passport as competing primary guards; resolve the approved authentication ADR and remove only an unused package after tests pass. Implement every baseline table group and critical constraint in the technical design, using UUIDv7 IDs, UTC timestamptz values, integer centavos, foreign keys, checks, and appropriate indexes. Produce docs/architecture/erd.md and docs/architecture/data-dictionary.md from the actual migrations. Pin the PHP version in Docker and CI, record the framework/runtime decision in an ADR, and do not silently change the major framework version.

Implement email registration and hashed six-digit OTP verification, login, refresh-token rotation and reuse detection, logout, password recovery, Google OIDC Authorization Code with PKCE and server-side ID-token validation using stable sub, risk-based step-up foundations, TOTP and recovery-code foundations for privileged users, secure web cookies, Flutter secure-storage abstraction, rate limiting, correlation IDs, and audit events. Do not use browser localStorage for tokens. Do not implement SMS OTP. Admin has no public registration; add a protected one-time Super Admin invitation command with no default password.

Implement all authentication screens and states in the three clients using the UI planner's Inter typography, semantic construction palette, responsive rules, shared states, and accessible components. Build the Vendor public landing page with truthful marketplace, onboarding, verification, zero-commission, third-party processing-fee, and limitation content. Use the Figma file only for visual direction and record intentional corrections. Run the applicable Impeccable shape/critique/harden/audit/polish workflow. Meet WCAG 2.2 AA patterns.

Define/update OpenAPI 3.1, regenerate TypeScript and Dart clients, add unit/feature/component tests, and document local startup. Do not add or reveal real credentials. Do not deploy or commit. Run every available format, lint, static-analysis, migration, API, React, and Flutter test. Phase 1 is done only when an empty-database migration and the complete authentication acceptance gate pass. End with changed files, commands/results, manual Google setup still required, risks, and a suggested commit message.
```

---

# Phase 2: Authorization, Profiles, Agreements, and Account Security

## Outcome

Every authenticated request is restricted by account type, account status, organization, fixed role, delegation, ownership, resource state, and recent-authentication requirements. Users can manage allowed profile and security functions.

## Required Implementation

- Implement Laravel policies and permission middleware from the approved matrices.
- Create Buyer, Vendor, and Admin route groups and deny cross-surface access.
- Implement versioned Terms, Privacy Notice acknowledgment, Vendor Code of Conduct, and required reacceptance.
- Implement Buyer profile, Vendor staff profile, Admin profile, session/device list, revoke-one, revoke-all, password change, email change, TOTP management, and recovery-code replacement.
- Implement Admin and Vendor staff invitation acceptance.
- Enforce Manager delegation rules and notify the Owner of delegated staff changes.
- Add authorization tests for every role/resource/action combination.

## Acceptance Gate

Forbidden API calls return safe `403` or `404` results regardless of hidden UI. Role changes revoke incompatible sessions. Historical actor attribution remains intact.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 2: server-enforced authorization, user profiles, agreements, sessions/devices, privileged reauthentication, Admin invitations, and Vendor team-account security.

Read AGENTS.md, the technical design, workflows, Phase 1 migrations, and current OpenAPI contract. Preserve one user identity per email, one fixed Vendor role per membership, and the exact Owner/Manager/Store Staff/Customer Service/Inventory/Fulfillment permission boundaries. Store Manager staff management must be off by default, limited to non-manager staff, and every delegated action must notify the Owner and create an immutable audit event.

Implement policies, middleware, form requests, actions, API resources, frontend route guards, and accessible profile/security pages. Frontend guards must never replace backend authorization. Add versioned agreement documents and acceptances, required reacceptance, session/device listing and revocation, password/email change, TOTP management, recovery-code regeneration, and recent-authentication checks for sensitive actions.

Update OpenAPI and generated clients. Add a deny-by-default authorization matrix test suite that tries cross-user, cross-Vendor, cross-role, suspended, deactivated, stale-session, and guessed-ID access. Do not deploy or commit. Run all checks and finish with evidence for the acceptance gate and a suggested commit message.
```

---

# Phase 3: Vendor Onboarding, Verification, Activation, and Team Accounts

## Outcome

A registered Vendor Owner can complete onboarding, upload private evidence, configure the store and fulfillment basics, connect a test payment-account record, invite staff, and enter the marketplace only after all mandatory requirements are approved.

## Required Implementation

- Onboarding checklist and save-as-draft behavior.
- Business information, contacts, address, classification, public profile, media, bulk capability, and fulfillment method.
- Business documents with immutable versions and Admin Approve, Return for Correction, or Reject decisions.
- Verified issue/expiration dates and scheduled expiry reminders/restrictions.
- Xendit connection state as a provider record; actual transactions wait until Phase 11.
- Team invitation, fixed roles, Manager delegation, activation readiness, restriction, and restoration.
- Private storage and signed authorized downloads.

## API/Key Step

Configure Development object storage from the environment guide. Mailpit remains adequate locally. Do not use a live Xendit key; create only the provider adapter and Test Mode connection workflow where supported.

## Acceptance Gate

The backend refuses activation if any mandatory requirement is missing. Private documents are inaccessible across Vendors and to unauthorized staff.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 3 end to end: Vendor onboarding, business verification, public store setup, activation readiness, payment-account connection status, and Vendor team invitations.

Read the authoritative workflow and existing code first. Implement the complete checklist with draft persistence and explicit NOT_STARTED, IN_PROGRESS, PENDING_VERIFICATION, CHANGES_REQUIRED, APPROVED, REJECTED, COMPLETED, and marketplace activation states as defined by the documents. Keep public store data separate from legal/private business data.

Use versioned private document uploads, content validation, checksums, scan states, authorized signed downloads, and immutable Admin review decisions. The Admin, not the Vendor, records final verified issue/expiration dates. Implement scheduled expiry warnings and the documented restriction behavior. Implement the activation gate as a backend domain service; the UI must only explain its result.

Implement fixed team roles and invitation lifecycle. Manager delegation is off by default and cannot manage Managers, ownership, payout settings, legal ownership, audit data, or its own role. Notify the Owner and audit every delegated change.

Update all three affected clients, OpenAPI, factories, seeds, and tests. Include unauthorized-document access and activation-bypass tests. Use only Development storage credentials already placed locally by the user; never display them. Do not deploy or commit. Run all checks and report acceptance evidence.
```

---

# Phase 4: Taxonomy, Listings, Media, and Product Compliance

## Outcome

Vendors can create structured materials and variants while the platform enforces category-specific fields and PS/ICC compliance before regulated products become active.

## Required Implementation

- Canonical categories, materials, aliases, `pg_trgm` search, units, conversions, tags, and technical attributes.
- Listing and variant creation with price versions, weights, dimensions, stock status, and photos.
- Three compliance input paths: photo/OCR, QR, and manual with required marking photo.
- Unified Review and Confirm, official reference adapter, Admin review queue, status history, and publication gate.
- Accessible bulk spreadsheet import with row-level errors and transactional validated rows.

## API/Key Step

Use local OCR where feasible. If Google ML Kit or another service is enabled, configure only its Development credential according to the environment guide. OCR output is never treated as approval.

## Acceptance Gate

A regulated listing cannot become Active without the applicable verified evidence. A nonmatch becomes pending review, never an automatic counterfeit accusation.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 4: taxonomy, Vendor listings and variants, listing media, price versions, and the complete PS/ICC compliance workflow.

Read AGENTS.md, the technical design, workflows, and existing migrations. Implement canonical materials, aliases with PostgreSQL pg_trgm fuzzy matching, categories, one-to-three tags, compatible units, technical attribute definitions, regulated-material mappings, products, Vendor listings, variants, price history, media, and status history.

Implement Photo/OCR, QR, and Manual Entry compliance paths that converge on Review and Confirm. Treat OCR and QR as editable extraction assistance. Store evidence privately and route uncertain/unavailable/unmatched results to PENDING_ADMIN_REVIEW. Add Admin Approve, Return for Correction, and Reject with required reasons and source/version attribution. Enforce the regulated publication gate in the backend.

Implement Vendor and Admin UI, accessible validation, draft saving, and bulk spreadsheet upload with row-specific errors. Update OpenAPI/generated clients and add permission, state, file-abuse, compliance-gate, fuzzy-search, and historical-snapshot tests. Do not deploy or commit; run all checks and report the acceptance gate.
```

---

# Phase 5: Inventory, Pricing, Delivery, and Auto-Accept Configuration

## Outcome

Vendors manage exact private stock, public availability, price history, delivery vehicles/rates, stale-stock confirmation, and safe per-variant Item-Based auto-accept rules.

## Required Implementation

- Inventory balances, movements, reconciliation, reserved and soft-held reporting.
- Optimistic concurrency for manual edits and row locks for reservations.
- Price/version management and volume tiers if defined by the listing.
- Vehicles, capacities, cargo dimensions, rates, availability, service radius, and snapshot history.
- Auto-accept enabled/paused state, allotment, unit cap, amount cap, explicit resume, and permissions.
- Day 7/12 reminders and Day 15 temporary listing hide for unconfirmed stock.

## Acceptance Gate

Buyers never receive exact stock. Inventory cannot become negative. Auto-accept configuration does not apply to Project-Based procurement or any NRPC order.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 5: exact Vendor inventory, price/version controls, vehicle and delivery configuration, stale-stock confirmation, and Item-Based auto-accept policy configuration.

Use the approved formulas and permissions. Implement quantity_on_hand, hard_reserved_quantity, soft_held_quantity, available_to_sell, auto-accept allotment, reorder level, and append-only movements. Buyers receive only In Stock, Limited Stock, or Out of Stock. Add lock_version conflict handling for manual edits and prepare deterministic row-lock helpers for later order acceptance.

Implement vehicle capacity/dimensions, availability, base fee, per-kilometer rate, maximum distance, and immutable order-time snapshots. Add auto-accept policy versions with disabled-by-default behavior, separate allotment/unit/amount safeguards, pause at zero, notification event, and deliberate authorized resume. Explicitly prohibit Project-Based and NRPC auto-accept.

Implement Day 7 and Day 12 reminders and Day 15 TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED behavior. Update Vendor UI, OpenAPI, clients, factories, and tests, including concurrent update and permission cases. Do not deploy or commit. Report all validation results.
```

---

# Phase 6: Buyer Onboarding, Locations, Maps, and Supplier Directory

## Outcome

Buyers can create profiles and saved locations, browse an accessible map/list, use manual location without GPS, select 5–50 km radii, and distinguish Verified Vendors, Directory Suppliers, and Favorite Suppliers.

## Required Implementation

- Buyer onboarding, primary location, saved locations, coordinate/PSGC resolution, consent and permissions.
- Flutter Google Maps integration and list alternative.
- Map Home layout/tokens based on Figma node `1:17996`, corrected by the UI/UX planner.
- PostGIS radius query before route/ETA requests.
- Tier 1 Places search/cache/attribution and Tier 2 Vendor serviceability.
- Ask-before-radius expansion through `5, 10, 20, 30, 40, 50 km`.
- PSGC import/versioning and unresolved-geography handling.
- Zoom-aware Vendor clusters and collision-safe labels.
- Tier 2 labels with store name plus VPS/New Vendor; Tier 1 labels with store name plus Directory.
- Selected-marker camera transition, one-route request, route-line reveal, distance/ETA, and Tier-specific preview sheet.

## API/Key Step

Create restricted Development keys for Android, iOS, browser, and backend as described in the environment guide. Never reuse the backend key in Flutter or React.

## Acceptance Gate

The Buyer can complete all discovery actions with GPS denied. Tier 1 Suppliers have no in-platform transaction action.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 6: Buyer onboarding and saved locations, PSGC-aware address storage, Flutter map/list discovery, Tier 1 directory suppliers, Tier 2 Verified Vendors, Favorite Supplier labels, radius controls, and route/ETA adapters.

Read the exact map rules and UI planner before coding. Use Figma node 1:17996 for composition only. GPS permission is optional. Implement manual address entry and pin placement as complete alternatives. Store authoritative coordinates and best resolved versioned PSGC codes. Use PostGIS for the initial radius filter and call Google Routes only for the selected Vendor or transaction-relevant result. Use exactly 5, 10, 20, 30, 40, and 50 km, default 5 km, and ask before expansion.

Implement zoom-aware clustering and collision-safe individual labels. Tier 2 labels show store name plus VPS or New Vendor; Tier 1 labels show store name plus Directory. A Tier 1 Google rating appears only in Place Details with explicit Google attribution. On Tier 2 selection, synchronize the map/list, safely move the camera, request one driving route from the active selected location, reveal the polyline, display distance/ETA, and open the preview sheet with explicit View Store. On Tier 1 selection, show only policy-permitted Place Details and public contact/map/website/share actions. Tier 1 is informational only: no marketplace message, order, review, payment, VPS, verification, or storefront action.

Use the approved motion tokens: no bounce, no moving delivery vehicle, no implication of live GPS, stale-response protection, and immediate final rendering under Reduce Motion. Implement separate restricted client/server key configuration, minimum Places/Routes field masks, compliant attribution, bounded cache records, quotas/timeouts, and fallbacks. Add an accessible synchronized list, non-color marker semantics, clear loading/denied/offline/provider-error/route-error states, and no weather widget. Run the Impeccable shape, critique, harden, animate, audit, and polish passes without allowing them to change product rules.

Update OpenAPI, generated clients, PSGC import documentation, and tests for radius edges, denied permission, unresolved PSGC, provider timeout, cache expiry, and Tier 1 restrictions. Never reveal configured keys. Do not deploy or commit.
```

---

# Phase 7: Item-Based Discovery, Ranking, Favorites, Cart, and Checkout Preview

## Outcome

Buyers search comparable active listings, understand Best Price and ranking, personalize SRS weights, maintain favorites, and prepare a cart that is split by Vendor before order submission.

## Required Implementation

- Search, filters, product/vendor detail, active-stock rules, price normalization, and pagination.
- Normalized SRS with exact default weights and separate Buyer overrides.
- Best Price only for comparable variant/unit/service radius with stock.
- Favorites and Favorites First without silently changing Best Deal.
- Cart validation, Vendor grouping, delivery/pickup choices, physical-payment eligibility, and checkout preview.
- No stock reservation at cart time.

## Acceptance Gate

Ranking is deterministic and explainable. All weight sets total 100%. A cart preview detects stale price, stock, serviceability, and Vendor status without creating an order or reservation.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 7: Item-Based marketplace search and product detail, deterministic SRS, Buyer ranking preferences, Best Price, Favorite Suppliers, cart, Vendor grouping, and checkout preview.

Use SRS Distance 30%, Price 25%, VPS 20%, Stock 15%, Product Rating 10% as a normalized weighted sum. Store Item-Based Buyer overrides separately, require 100%, reject all-zero values, show when personalization is active, and implement Reset to Default. Implement explainable component scores and deterministic tie-breaking.

Best Price must compare the same product, variant, unit, and service radius and require active available stock. Favorites First is explicit and must not silently override Best Deal. Cart placement creates no inventory hold. Checkout preview groups one child group per Vendor and revalidates listing state, price version, availability label, address/serviceability, delivery/pickup capability, and payment-method eligibility.

Implement the Flutter pages with accessible loading, empty, stale, error, offline, and retry states. Update backend queries, OpenAPI, generated client, and tests for ranking math, comparison normalization, stale data, cross-Vendor carts, and unauthorized preferences. Do not deploy or commit.
```

---

# Phase 8: Orders, Confirmation, NRPC, Atomic Reservations, and Auto-Accept

## Outcome

Item-Based order submission creates one parent checkout and Vendor child orders. Vendors manually confirm/revise/decline, may propose disclosed manual NRPC, or use safe auto-accept when every eligibility rule passes.

## Required Implementation

- Order, line, price, fee, delivery, payment-method, and policy snapshots.
- Canonical transition service and immutable history.
- Vendor confirmation, permitted revision, Buyer approval, decline/expiry.
- Manual-only NRPC reason, amount, affected lines, Terms version, Buyer acceptance/flag.
- Atomic hard reservation with deterministic row locks and all-or-nothing multi-line behavior.
- Item-Based auto-accept transaction, policy snapshot, allotment decrement, pause, and manual fallback.
- 45-minute displayed payment expiry and reservation release.

## Acceptance Gate

Concurrency tests prove no overselling. NRPC can never be introduced after Buyer acceptance/payment and never participates in auto-accept.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 8 end to end: Item-Based order submission, parent checkout and per-Vendor child orders, Vendor confirmation/revision/decline, Buyer approval, manual NRPC, atomic hard reservations, auto-accept, and 45-minute payment expiry preparation.

Use one server-side state-transition service and immutable order history. Snapshot every commercial input. Create hard reservations only at manual confirmation, quotation acceptance, or eligible auto-accept. In one PostgreSQL transaction, lock all affected inventory and policy rows in deterministic order, revalidate every line, and update all lines or none. Physical quantity_on_hand changes only at fulfillment. Release reservations on rejection, payment expiry, cancellation, or approved reduction.

NRPC is disabled by default, Vendor-determined with no platform-wide numeric cap, manual only, part of the existing order value, and requires amount, reason, affected lines, versioned Terms, and explicit Buyer acceptance before payment or preparation. Allow a separate Buyer flag without silently changing acceptance. Never enable NRPC for auto-accept.

Implement auto-accept only for eligible Item-Based orders without NRPC. Enforce per-variant allotment plus independent unit and amount safeguards. When any check fails, make no partial change and route the complete Vendor order to manual review. Pause at zero and require deliberate authorized resume. Display the exact payment-expiry time and countdown.

Update Buyer/Vendor UI, OpenAPI, generated clients, audit/outbox events, and exhaustive transaction/concurrency tests. Do not integrate real payment yet, deploy, or commit.
```

---

# Phase 9: Real-Time Messaging and Shared Order-from-Chat Engine

## Outcome

Tier 2 Buyers and Vendor staff communicate securely. Vendors create versioned Item-Based or Project-Based quotations through one engine with deadlines, counter-offers, change history, soft holds, and stale-version protection.

## Required Implementation

- Authorized conversations, participants, handlers, transfer system messages, receipts, and attachments.
- Buyer-visible store and staff identity without personal staff contact details.
- Draft/publish/revise/withdraw quotation, 1–72 hour deadline, default 24 hours, reminder, expire, accept/reject/counter.
- Immutable quotation versions, before/after audit, content hash, and plain-language change summary.
- Soft holds on publish; immediate release on counter/reject/expire/withdraw.
- Acceptance-time atomic revalidation and hard reservation.
- `ITEM_BASED` and `PROJECT_BASED` flags; no duplicated engine.

## Acceptance Gate

An old quotation version cannot be accepted after revision. Unauthorized users cannot subscribe to or retrieve another conversation.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 9: secure real-time messaging and the single shared Order-from-Chat quotation engine for ITEM_BASED and PROJECT_BASED conversations.

Implement authorized Reverb channels, conversation participants, staff handler assignment/transfer, read receipts, safe attachments, and system messages. Buyer headers show store logo/name/Verified badge plus staff avatar/display name/role and Handled by wording, but never staff login email or personal phone.

Implement quotation draft, publish, edit-as-new-version, withdraw, view, accept, reject, counter-offer, reminder, and expiry. Default Buyer deadline is 24 hours; Vendor may choose 1–72 hours. Every published edit supersedes the old immutable version, resets the deadline, creates before/after and plain-language changes, and makes stale acceptance return a safe 409. Add products, quantities, units, prices, fulfillment, payment method, delivery calculations, NRPC fields, actor, content hash, and audit events.

Publishing creates only a soft hold that does not reduce available_to_sell or the auto-accept pool. Counter, rejection, expiry, or withdrawal releases it. Acceptance must atomically revalidate current stock and convert to hard reservations; insufficient stock produces STOCK_REVALIDATION_REQUIRED and no payment/order acceptance.

Update Flutter/Vendor UI, OpenAPI, generated clients, Reverb authorization tests, quotation-version tests, deadline tests using a fake clock, and stock-contention tests. Do not deploy or commit.
```

---

# Phase 10: Project-Based Procurement, Work Packages, FMS, and Budgets

## Outcome

Buyers manage Projects and versioned Work Packages, receive compiled one-Vendor estimates, message each eligible Vendor with locked/editable copies, compare change summaries, select one Vendor, and monitor budgets.

## Required Implementation

- Project/site/budget and Work Package draft/activate/version lifecycle.
- BOM/BOQ line validation and CSV import.
- Tier 2 scan, one-Vendor completeness, missing lines, estimate snapshots, and 48-hour validity.
- FMS exact weights, Buyer overrides, comparison, and budget labels.
- Inquiry attachments: locked Buyer original plus Vendor-editable duplicate.
- Optional informational Note for direct selection.
- Accepting one Vendor expires competing quotation requests while preserving history.
- Project/work-package budget metrics, 90% warning, and reasoned override over 100%.
- Project Vendor Map based visually on Figma node `1:18108`, using Project site origin and the shared map/route engine.

## Acceptance Gate

The locked original never changes. Every Vendor change is visible before acceptance. A Work Package ends with one selected Vendor, not split competitive awards.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 10: Projects, project sites, versioned Work Packages, system-compiled Vendor estimates, FMS comparison, multi-Vendor inquiries, one-Vendor selection, and budget monitoring.

Implement Draft, Active, Quotation Inquiry, Vendor Selected, Awaiting Payment, In Progress, Completed, and Cancelled behavior exactly as documented. Lock an Active Work Package version. Scan active Tier 2 inventory within the confirmed radius, favor a complete single-Vendor match, show missing lines explicitly, snapshot prices/availability/delivery estimate, and expire system estimates after 48 hours.

Use FMS Material Match 40%, Budget Fit 25%, Distance 20%, VPS 15% as a normalized weighted sum with separate Project-Based Buyer preferences, 100% validation, active indicator, and Reset to Default. Show Under/Within/Over Budget with exact cost components.

From the compiled Vendor list and synchronized Project Vendor Map, allow the Buyer to message each Vendor. Use Figma node 1:18108 for map composition and the UI planner for behavior. The Project site is the route origin; candidates are eligible Tier 2 Vendors only. Reuse Phase 6 SupplierMarker/SupplierCluster/RouteOverlay/PreviewSheet components with a PROJECT_BASED context flag. Individual labels show store name plus VPS/New Vendor; selected details add FMS, match completeness, budget result, distance/ETA, fulfillment, quotation state, comparison, Add Note, Message Vendor, and View Store.

Attach the locked Buyer original and a Vendor-editable duplicate to the shared Phase 9 quotation engine. Track every proposed field change and show a plain-language summary before acceptance. Direct selection may include an optional informational Note that requires no Vendor response. Selecting/accepting one Vendor expires other active quotations but retains histories. Protect against stale route/quotation results and support the synchronized accessible list and reduced motion.

Implement project/work-package budget metrics, 90% warning, and a written Buyer override when a purchase exceeds 100%. Update UI, OpenAPI, clients, PDFs placeholders, and tests for version integrity, expiry, ranking, missing lines, one-Vendor enforcement, and budget calculations. Do not deploy or commit.
```

---

# Phase 11: Xendit Checkout, Payments, Fees, Webhooks, and Reconciliation

## Outcome

Buyers pay in Xendit Test Mode through Vendor sub-accounts. The platform records transparent fee snapshots, trusts only verified provider events, handles duplicates, and reconciles uncertain transactions.

## Required Implementation

- Payment adapter and fake adapter for automated tests.
- Xendit sub-account capability/connection checks.
- Payment methods from actual configuration; refund-incompatible channels disabled for MVP.
- Server-side payable amount and processing-fee snapshot.
- Full-order, NRPC-assurance, and order-balance purposes.
- 45-minute expiry and callback/return pages that show pending until webhook confirmation.
- Authenticated, idempotent Xendit webhook inbox and asynchronous processor.
- Scheduled reconciliation, exception queue, and technical compensation trigger when capture occurred after application failure.

## API/Key Step

Follow the Xendit Test Mode section in the environment guide. Paste the secret key and callback token only into the backend Development/Staging environment. Never expose them in React, Flutter, logs, or screenshots.

## Acceptance Gate

A forged, duplicate, reordered, mismatched-amount, or unknown webhook cannot create a paid order. Browser redirect alone never marks `PAID`.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 11 using Xendit Test Mode: checkout payment creation for Vendor sub-accounts, payment-processing-fee snapshots, payment purposes, verified webhooks, idempotency, expiry, reconciliation, and safe client return pages.

Read the current Xendit documentation linked in the technical design before choosing request fields. Put all provider code behind PaymentGateway and include a deterministic fake. Use only backend environment variables already entered by the user; never print them. Determine enabled methods from configured capabilities and keep refund-incompatible MVP channels disabled.

Calculate the payable amount on the server from immutable order snapshots. Store materials, delivery, actual configured Payment Processing Fee, total, channel/rate snapshot, Vendor sub-account, idempotency key, provider IDs, purpose, and expiry. Support FULL_ORDER_PAYMENT, NRPC_ASSURANCE_PAYMENT, and ORDER_BALANCE_PAYMENT without double charging NRPC.

Implement /api/v1/webhooks/xendit as a fast webhook inbox: verify callback token/signature with constant-time comparison, store the raw event safely once by provider event ID, acknowledge, then process asynchronously. Recheck provider transaction ID, amount, currency, reference, sub-account, and allowed transition. Redirect/callback UI remains Pending until a verified event or authoritative reconciliation sets PAID. Add scheduled reconciliation and an idempotent technical-compensation path only when capture is proven after an application failure.

Update OpenAPI, clients, Buyer/Vendor/Admin payment views, audit/outbox events, and integration tests for success, pending, failed, expired, forged, duplicate, reordered, mismatch, timeout, and reconciliation. Do not use live keys, deploy, or commit.
```

---

# Phase 12: Fulfillment, Cancellation, and Automatic Cancellation Refunds

## Outcome

Vendors process orders through pickup or delivery milestones with proof. Permitted paid cancellations calculate the correct amount and automatically initiate the separate Cancellation Refund.

## Required Implementation

- `CONFIRMED → PROCESSING → READY_FOR_PICKUP/OUT_FOR_DELIVERY → PICKED_UP/DELIVERED → COMPLETED`.
- Expected date, vehicle/trip confirmation, staff assignment, proof, receiver, and audit history.
- Buyer two-day receipt confirmation and paused auto-completion when an issue is open.
- Cancellation withdrawal/request/finalization rules and cutoff.
- Vendor cancellation: full Buyer-paid refund, NRPC forfeiture, NFR event, and reservation release.
- Buyer cancellation in Processing: documented NRPC evidence/retention where eligible.
- Automatic idempotent Cancellation Refund to original method; status follows webhook/reconciliation.

## Acceptance Gate

Cancellation is blocked at Ready for Pickup or Out for Delivery while Report a Problem and statutory remedies remain accessible. Refund initiation and refund success are distinct.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 12: fulfillment milestones and evidence, delivery/pickup tracking without live GPS, Buyer receipt confirmation, cancellation rules, reservation release, and automatic Cancellation Refunds for already-paid finalized cancellations.

Enforce all transitions through the shared server state machine. Implement expected fulfillment date, assigned staff, confirmed vehicle/trips, preparation, ready, dispatch, delivery/pickup proof, receiver, Buyer confirmation, and two-calendar-day auto-confirmation that pauses for an open issue/dispute. Keep live GPS outside scope.

Allow withdrawal before Vendor confirmation and reasoned cancellation requests from CONFIRMED through PROCESSING. Disable cancellation at READY_FOR_PICKUP and OUT_FOR_DELIVERY while preserving Report a Problem, dispute, return, warranty, and statutory-remedy actions. Vendor cancellation forfeits NRPC, refunds all Buyer-paid order amounts, releases reservations, and creates the applicable NFR event. Eligible Buyer cancellation may retain only accepted, evidenced NRPC under the documented rules.

When a paid cancellation becomes final, create exactly one CANCELLATION refund record and immediately submit the idempotent provider request. Set REFUND_PENDING on successful initiation; wait for verified provider events/reconciliation before REFUNDED or REFUND_FAILED. Return only to the original supported method. Never open a dispute automatically.

Update all clients, OpenAPI, notifications, audit history, and tests for each actor/state/cause/payment combination, provider timeouts, duplicate cancellation, duplicate webhooks, and reservation release. Use Xendit Test Mode only. Do not deploy or commit.
```

---

# Phase 13: Disputes, Appeals, Dispute-Conclusion Refunds, and Invoices

## Outcome

Buyers and Vendors can resolve documented cases through timed steps. A refund is created only when a concluded decision awards it. Buyers can request Vendor-issued BIR-compliant invoice PDFs without MateryalPH pretending to issue tax invoices.

## Required Implementation

- Structured dispute/refund-request form, evidence, Case ID, masked original method, no alternative destination.
- 48-hour response, 72-hour mutual resolution, 24-hour clarification, five-business-day appeal.
- Admin decision and remedy tracking.
- Separate Dispute-Conclusion Refund linked to decision version and case.
- Review-withholding and order auto-completion pause.
- Invoice request, Vendor upload, three-business-day service target, authorized access, and audit.

## Acceptance Gate

Filing a dispute never creates `REFUND_PENDING`. A concluded refund award creates exactly one linked refund and the case remains open until the remedy reaches a terminal state.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 13: transaction disputes, mutual resolution, Admin clarification/decision, one appeal, remedy tracking, Dispute-Conclusion Refunds, returns, and Vendor invoice-request/upload workflow.

Implement the documented states and Asia/Manila deadlines using exact stored instants and visible countdown plus date/time. The filing form includes issue type, affected lines, remedy, requested partial amount, description, evidence, and masked original payment method for information. It must never collect a different refund destination. Filing creates a Case ID and dispute state only.

Implement 48 calendar hours for response, 72 calendar hours for mutual resolution after response, 24 calendar hours for requested clarification, and one appeal within five business days with new evidence or material process error. Preserve all evidence and decisions immutably. Implement Dismissed, Replacement, Full/Partial Refund, Warning, metric event, Restriction, Suspension, Ban, and Inconclusive outcomes within role permissions.

Only a concluded decision awarding money creates one idempotent DISPUTE_CONCLUSION refund linked to Case ID and decision version. Keep it separate from CANCELLATION. Track REFUND_PENDING through provider events and do not resolve the case until the remedy completes.

Implement invoice request and private Vendor-uploaded BIR-compliant PDF with invoice metadata, three-business-day service target, reminders, and audit. Label MateryalPH PO/payment files as not tax invoices. Update clients, OpenAPI, notifications, and exhaustive timeline/authorization/refund tests. Use Test Mode only. Do not deploy or commit.
```

---

# Phase 14: Reviews, Scores, Badges, and Price Insights

## Outcome

Verified completed purchases produce controlled reviews, daily Vendor scores, automatic badges, and local price insights without misleading small samples.

## Required Implementation

- 14-day review window, double-blind reveal, 24-hour edit, dispute withholding, moderation.
- MQS/VCS 90-day windows, OHS 30-day window, sample gates, and daily VPS calculation.
- CRR, FRR, and NFR event definitions from verified source events.
- Exact badge triggers and automatic removal; Admin suppression only for documented fraud/compliance findings.
- Comparable 7/30-day price observations from active snapshots and completed eligible orders.

## Acceptance Gate

Canceled, test, duplicate, fraudulent, or otherwise ineligible activity cannot affect scores. Low samples show “New Vendor — Building Track Record.”

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 14: verified-purchase reviews, moderation, MQS/VCS/OHS/VPS and operational metrics, automatic badges, and local price-trend insights.

Use the exact windows, minimum samples, formulas, exclusions, and badge thresholds in the System Workflow. Implement a 14-calendar-day rating window, hidden-until-both-or-expiry publication, 24-hour edit lock, dispute withholding, immutable moderation history, and product/vendor rating separation. Never permit a Vendor to delete a Buyer review.

Generate metric events from authoritative order/fulfillment/dispute facts and calculate daily snapshots. Display New Vendor — Building Track Record below minimum samples. Automatically award/remove performance badges; Admin may suppress for a documented fraud/compliance case but may not manually award them.

Implement 7-day and 30-day comparable price insights normalized by product, variant, unit, and radius. Exclude drafts, rejected/expired quotations, canceled/test orders, and noncomparable units. Show Insufficient Local Data when the sample rule fails and never label the result an official market price.

Update Buyer/Vendor/Admin UI, OpenAPI, jobs, audit events, and deterministic fake-clock tests for every threshold/window edge. Do not deploy or commit.
```

---

# Phase 15: Notifications, Reminders, PDFs, and Exports

## Outcome

Users receive reliable in-app, push, and email notices. The system produces authorized Purchase Orders, confirmations, budget reports, summaries, and operational exports.

## Required Implementation

- Notification templates, preferences, mandatory classes, device tokens, delivery attempts, deep links, and retry rules.
- FCM for Buyer push and Web Push where supported.
- Email provider adapter; Mailpit locally.
- Scheduled deadline/reminder jobs.
- Purchase Order, payment confirmation, procurement summary, budget PDF/CSV, and internal operational reports.
- Private export storage, expiry, access logs, and data minimization.

## API/Key Step

Configure Firebase Development credentials and nonlocal email credentials from the environment guide. Keep the Firebase service account only on the backend.

## Acceptance Gate

Notification-provider failure does not roll back a committed order. Deep links recheck authorization. Mandatory notices cannot be disabled.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 15: authoritative in-app notifications, FCM Buyer push, web push where approved, email delivery, mandatory reminders, PDFs, CSV exports, and authorized deep links.

Store the notification before dispatching channels. Queue every external delivery, record attempts, use bounded retries, and expose failed operational jobs without rolling back the original business transaction. Implement user preferences, but never allow security, legal, suspension, payment, refund, or dispute notices to be disabled. No SMS.

Use Firebase service credentials only in the Laravel backend and environment-specific public configuration in clients. Register/revoke device tokens securely and request notification permission contextually. Deep links must resolve only after fresh authentication/authorization.

Generate immutable-snapshot Purchase Orders, payment confirmations, project procurement summaries, budget reports, and permitted operational exports. Clearly mark MateryalPH documents that are not tax invoices. Store exports privately with expiry, checksum, actor, filters, purpose, and access audit.

Implement fake providers for tests. Update OpenAPI, clients, templates, accessibility, and tests for retry, duplicate, disabled optional channel, mandatory channel, revoked device, unauthorized deep link, and expired export. Do not deploy or commit.
```

---

# Phase 16: Admin Operations and Philippine Geographic Analytics

## Outcome

Authorized Admin roles operate all review queues and see privacy-controlled supply, demand, GMV, performance, and active-user trends on a drillable Philippines map and synchronized table.

## Required Implementation

- Vendor verification, product compliance, dispute/appeal, review moderation, user enforcement, invoice, privacy, job health, and refund-monitoring queues.
- Non-secret Platform Settings with versioning and validation.
- Searchable append-only audit log and access logging.
- PSGC map: Philippines → Region → Province or independent/highly urbanized city → City or municipality.
- Global geography/date/procurement/category/fulfillment/payment/state filters.
- Gross/net GMV, order volume, fulfillment/cancellation/dispute rates, response distribution, demand heatmap, Buyer/Vendor DAU/WAU/MAU.
- Small-cell suppression, unresolved geography, accessible table, and export controls.

## Acceptance Gate

Aggregate permission never exposes exact Buyer coordinates. Auto-accept and app opens alone do not count as human Vendor activity.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 16: all Admin operational queues, non-secret Platform Settings, append-only audit search, integration/job health, and the privacy-controlled Philippine geographic analytics dashboard.

Read the Admin Workflow closely. Implement role-specific queues for Vendor documents/activation, product compliance, disputes/appeals/remedies, Buyer/Vendor enforcement, review moderation, invoices, privacy requests, payment/refund monitoring, and failed jobs. Every decision requires the documented authorization, reason, before/after state, actor, correlation ID, and notification. Never expose integration secrets, balances, withdrawal controls, or audit-edit actions.

Implement versioned Platform Settings for only the approved non-secret defaults with validation, including SRS/FMS totals. Do not add an NRPC cap or editable VPS weights.

Build daily aggregate facts and a drillable PSGC-aware map/table: Philippines to Region to Province or independent/highly urbanized city to City or Municipality. Geography filters the whole dashboard. Add Buyer/Vendor counts, gross/net GMV and order volume trends, fulfillment/cancellation/dispute rates, mean/median/p90 response time, category/material demand, and meaningful Buyer/Vendor DAU/WAU/MAU exactly as defined. Apply configured small-cell suppression/generalization, separate unresolved geography, and never expose exact Buyer coordinates through aggregate permission.

Implement accessible keyboard selection, breadcrumbs, legend, exact focused values, non-color meaning, synchronized sortable table, and authorized exports. Update OpenAPI, queries/materialized aggregates, jobs, tests, and performance indexes. Do not deploy or commit.
```

---

# Phase 17: Security, Privacy, Accessibility, and Performance Hardening

## Outcome

The complete feature system is hardened against common abuse, privacy leaks, authorization failure, inaccessible interaction, dependency risk, and predictable load.

## Required Implementation

- Threat model and data-flow review.
- Secure headers/CSP, CORS/CSRF, cookie flags, mobile certificate/network configuration, rate-limit tuning, and account-abuse defenses.
- Secret scan, dependency scan, SAST, container scan, upload-malware gate, and log redaction tests.
- Privacy-request workflow, retention classes, legal hold, minimization, export authorization, and deletion/anonymization jobs subject to approved policy.
- WCAG 2.2 AA audit for all pages.
- Database/query profiling, indexes, caching rules, N+1 elimination, pagination, and provider quotas.
- Sentry/error monitoring with personal-data filtering.

## API/Key Step

If risk-based reCAPTCHA and Sentry are approved, create separate Development/Staging projects and paste only their environment-specific values as directed in the environment guide.

## Acceptance Gate

Critical/high security findings are fixed or formally blocked from release. No accessibility blocker exists on a critical journey.

## Copy-Paste Codex Prompt

```text
Implement and verify MateryalPH Phase 17: security, privacy, accessibility, observability, and performance hardening across Laravel, both React portals, Flutter, containers, CI, and deployment configuration.

Begin with a concrete threat model and data-flow review for authentication, authorization, documents, locations, conversations, inventory, checkout, Xendit, refunds, disputes, Admin exports, and analytics. Test deny-by-default policies and cross-tenant isolation. Harden cookies, CSRF, CORS, CSP/headers, rate limits, account enumeration defenses, session rotation/reuse detection, webhook replay protection, file validation/malware state, signed URLs, and log redaction. Add secret/dependency/SAST/container scans.

Implement the approved privacy-request states, retention classes, legal holds, minimization, authorized exports, and auditable deletion/anonymization actions without deleting records that must legally or operationally remain. Do not invent legal retention periods; expose them as reviewed policy configuration with safe defaults marked non-production until approved.

Audit every critical page against WCAG 2.2 AA: labels, errors, keyboard/focus, screen-reader semantics, contrast, reflow, target size, timers, map alternative, and non-color statuses. Run the UI planner's Impeccable critique, harden, animate, audit, and polish workflow on each critical React surface; run deterministic detection on both React source trees and supported rendered previews. Keep the approved narrow Inter exception and document any other exception with a specific reason. Use Flutter semantics, widget/golden tests, device testing, and native accessibility inspection for Buyer; do not claim the web detector proves native Flutter accessibility. Profile API/database queries, add justified indexes/caches, remove N+1 queries, verify pagination, and protect provider quotas. Configure Sentry only through environment values and filter personal/payment data.

Produce docs/security/threat-model.md and a traceable findings report. Fix critical/high issues and test regressions. Do not deploy or commit.
```

---

# Phase 18: End-to-End Testing, UAT, Failure Simulation, and Recovery

## Outcome

The complete system is proven through repeatable automated and manual scenarios, including concurrency, outages, duplicates, reconciliation, backups, and role boundaries.

## Required Implementation

- Cross-client end-to-end suite for Buyer, Vendor roles, and Admin roles.
- Seeded deterministic Development/UAT dataset labeled as test.
- Xendit test scenarios, Google/FCM/email/storage failure adapters, fake time, and duplicate webhook replay.
- Inventory concurrency/load tests.
- UAT scripts for Item-Based, Project-Based, Order-from-Chat, NRPC, cancellation, dispute, and refund paths.
- Backup, restore, rollback, migration, and failed-job replay drills.
- Requirements traceability matrix from workflow rule to test ID.

## Acceptance Gate

All critical journeys pass. There is no unresolved Severity 1 or Severity 2 defect. Restore and rollback are demonstrated, not assumed.

## Copy-Paste Codex Prompt

```text
Implement MateryalPH Phase 18: complete automated end-to-end coverage, deterministic UAT data and scripts, provider failure simulation, concurrency/load checks, backup/restore validation, and requirements-to-test traceability.

Build tests for the complete Buyer, each Vendor role, and each Admin role. Cover email and Google auth, TOTP, onboarding/activation, listings/compliance, inventory, map discovery, Item-Based checkout, auto-accept, NRPC manual review, messaging/quotation versions/counter-offers, Project Work Packages, Xendit Test Mode, fulfillment, allowed/blocked cancellation, automatic Cancellation Refund, disputes, Dispute-Conclusion Refund, reviews/scores, notifications, analytics privacy, and exports.

Use fake clocks and deterministic providers where possible. Use Xendit Test Mode error simulation for integration tests. Replay duplicate/reordered webhooks, timeouts, queue crashes, email/push/storage/Google failures, expired payments, stale quotations, concurrent stock acceptance, and captured-payment/application-failure reconciliation. Confirm no overselling and no duplicate charges/refunds.

Create docs/test-plans/uat.md, recovery-drill.md, release-smoke-test.md, and requirements-traceability-matrix.md. Seed only obvious test users/data and add a production guard that refuses test seeders. Run the entire CI-equivalent suite and report failures by severity. Do not deploy or commit.
```

---

# Phase 19: CI/CD and Staging Deployment

## Outcome

GitHub Actions validates every change, and a fully isolated Staging environment is deployed on Render in Singapore using managed PostgreSQL, Redis-compatible key value, API, worker, scheduler, Reverb, and two static sites. The Buyer app produces a signed internal-test build without committing signing secrets.

## Required Implementation

- GitHub Actions path-aware Laravel, React, Flutter, contract, security, and container jobs.
- Protected `staging` and `production` GitHub environments.
- `render.yaml` defining Staging resources with `sync: false` or secret environment references.
- Docker production image, health checks, non-root runtime, immutable build, and graceful shutdown.
- Pre-deploy migration and safe post-deploy smoke tests.
- Staging domains/URLs, CORS/cookies/OIDC callbacks, Google restrictions, Xendit webhooks, FCM, storage, email, and Sentry.
- Flutter internal Android/iOS build procedure; store release remains Phase 20.

## API/Key Step

Enter Staging secrets directly into GitHub/Render/Firebase/Google/Xendit provider dashboards following the environment guide. Do not paste secrets into Codex. Use Xendit Test Mode only.

## Acceptance Gate

Staging deploys only after CI passes. Migration, health, worker, scheduler, Reverb, payment webhook, private storage, and critical smoke tests succeed. A rollback is rehearsed.

## Copy-Paste Codex Prompt

```text
Prepare MateryalPH Phase 19: production-grade CI/CD configuration and the isolated Staging deployment on Render Singapore. Do not perform an external deployment until I explicitly authorize it after reviewing the diff and required secret checklist.

Read AGENTS.md, technical design, environment guide, and complete test plan. Create path-aware GitHub Actions for Laravel formatting/static analysis/tests with PostgreSQL/PostGIS and Redis, both React lint/test/build jobs, Flutter analyze/test/build checks, OpenAPI validation/client drift, secret scan, dependency audit, and container scan. Use least-privilege workflow permissions and protected staging/production environments.

Create a root render.yaml for isolated Staging services: Laravel API Docker web service, queue worker, Reverb web service, scheduler cron, PostgreSQL 16, managed Redis-compatible key value, Vendor static site, and Admin static site. Use Singapore region for stateful/backend resources. Reference secrets without values. Add health checks, pre-deploy migrations, non-root image, optimized Laravel caches, graceful shutdown, and safe worker retry settings.

Document exact dashboard-only steps for entering Staging secrets, Google callback/host restrictions, Xendit Test Mode webhook URL/token, Firebase, email, private storage, and Sentry. Add post-deploy smoke checks and rollback commands. Add internal Flutter build instructions with ignored signing files and protected CI secrets.

Validate YAML/Docker/builds locally where possible. Stop before external creation/deployment and present the required approvals, costs to verify, secret checklist, and acceptance steps. Do not commit or push.
```

---

# Phase 20: Production Readiness and Controlled Release

## Outcome

The system moves from tested Staging to Production only after provider, legal, privacy, security, operational, backup, and business approvals. Production secrets and data remain isolated.

## Required Implementation

- Formal go/no-go checklist and named approval owners.
- Xendit live verification, enabled/refundable channels, contract-confirmed fee treatment, and webhook configuration.
- Production Google project/keys/quotas, domains, app identifiers, and OAuth verification as required.
- Production database/backups, storage lifecycle, email domain, FCM, monitoring, alerts, and on-call ownership.
- Migration rehearsal, deployment, smoke tests, rollback trigger, status communication, and incident response.
- Android/iOS signing and store submission where included in the approved release.
- 90-day secret rotation calendar and first rotation owner.

## Acceptance Gate

No Production release occurs with unresolved critical/high findings, debug/test data, default credentials, test keys, unapproved legal wording, unverified refunds, or untested restore/rollback.

## Copy-Paste Codex Prompt

```text
Prepare MateryalPH Phase 20 production release. Start with a read-only readiness audit. Do not create Production infrastructure, enter/rotate keys, run migrations, publish mobile builds, change DNS, or deploy until I explicitly approve the final go/no-go checklist.

Audit all workflow requirements, Phase 18 results, Staging evidence, security/privacy/accessibility findings, dependency status, backup/restore proof, rollback proof, monitoring, support ownership, and incident runbooks. Verify that Xendit live account approval, sub-account capabilities, enabled payment/refund channels, processing-fee treatment, and webhook configuration have written confirmation. Verify legal/tax/privacy approval for Terms, NRPC, cancellation/refund disclosures, invoice wording, retention, and processor arrangements.

Generate a Production environment checklist with new non-reused credentials, least privileges, restricted Google keys, protected GitHub/Render secrets, debug off, test seeders blocked, backups enabled, alerts tested, domains/TLS/CORS/cookies/OIDC callbacks exact, and a 90-day rotation register. Generate the migration/release/smoke/rollback sequence with decision points and responsible owner placeholders.

If and only if I later authorize deployment, execute one controlled step at a time, report each result, stop on any failed gate, never print secrets, and never mark payment/refund successful from a browser redirect. Finish with release evidence, known limitations, operations handoff, and next rotation date. Do not commit or push unless asked.
```

## Recommended Git Checkpoints

After each accepted phase, create one reviewed commit such as:

```text
feat(phase-01): establish schema auth and vendor landing
feat(phase-02): enforce authorization and account security
feat(phase-03): implement vendor onboarding and activation
```

Use a protected main branch. Feature branches should be named `phase/01-foundation-auth`, `phase/02-authorization`, and so on. Do not squash away migration or security history until the team has reviewed it.

## Completion Principle

A phase is not complete merely because its screens appear. It is complete only when its backend rules, database constraints, permissions, error paths, external-provider behavior, audit records, accessibility states, OpenAPI contract, automated tests, and manual acceptance checks agree with the approved workflows.
