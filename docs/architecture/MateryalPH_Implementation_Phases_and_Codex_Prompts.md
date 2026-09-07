# MateryalPH Implementation Phases and Codex Prompt Pack

**Plan date:** 4 September 2026; tax and Materials Analytics baseline updated 6 September 2026  
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

The user has approved FIN-01–FIN-12 and MAT-01–MAT-07. Treat these revised workflows and the technical design as the shared implementation contract, including 2% Vendor commission, withholding simulation, direct physical payments, aggregate-only competitor analytics and daily public-price history. Earlier zero-commission or mixed listing/transaction-price instructions are superseded. Preserve the UI planner's visual direction; reconcile stale behavioral text in repository reference copies during alignment. Keep security rules intact. Do not silently change the approved formulas, thresholds, access rules or radius choices.

For an existing implementation, audit phase completion and add migrations/tests for the delta; do not restart Phase 1, delete working features, reset real data or rewrite applied migrations. New Finance/Analytics tables are included in the complete new-install baseline, with additive migrations for prior installations. Each phase must remain usable: unfinished material-analysis entry points stay behind a disabled feature flag until Phase 14 supplies the working feature, and LIVE always remains blocked in this capstone. No new BIR or market-data API key is needed.

Financial implementation uses one Finance domain; market analysis uses one Analytics domain. Keep `PLATFORM_FEE_PAYMENT` distinct from Buyer order payments, physical evidence distinct from Xendit success, and material averages distinct from financial snapshots. Each phase prompt incorporates the additional required implementation and acceptance contract in its section; copy the entire prompt block. When claiming completion, report actual test results, not merely generated tests or document checks.

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
| 7 | Item-Based catalog, Explore counts, SRS, favorites, cart and tax-aware checkout preview | Google services already configured |
| 8 | Order core, Vendor confirmation, NRPC, reservations, and auto-accept | None |
| 9 | Real-time messaging and shared Order-from-Chat quotation engine | Reverb configuration; push optional until Phase 15 |
| 10 | Project-Based procurement, Work Packages, FMS, and budgets | Google services already configured |
| 11 | Xendit TEST, tax assessment, commission billing, webhooks and ledger reconciliation | Xendit Test Mode secret key and callback token |
| 12 | Fulfillment, cancellations, and automatic Cancellation Refunds | Xendit Test Mode |
| 13 | Disputes, appeals, Dispute-Conclusion Refunds, and invoice requests | Xendit Test Mode; private storage; email |
| 14 | Reviews/scores/badges and shared Materials Analytics for Buyer and Vendor | None |
| 15 | Notifications, fee/tax deadlines, sample tax/invoice packages and protected exports | Firebase service credentials; email; storage |
| 16 | Admin finance/market controls, audit and Philippine geographic analytics | Map browser key; PSGC boundary data source |
| 17 | Security, privacy, accessibility, and performance hardening | reCAPTCHA keys if enabled; Sentry credentials |
| 18 | End-to-end testing, UAT, failure simulation, and recovery | All Staging/Test credentials |
| 19 | CI/CD and Staging deployment | GitHub and Render environment secrets |
| 20 | Capstone demo release; record separate future LIVE readiness gate | Existing TEST credentials; no live keys for capstone |

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

**Approved tax and Materials Analytics integration.** Create the Finance and Materials Analytics table extensions and constraints from Technical Design Section 8, including profile/evidence/rules, immutable amounts/allocations, assessments/accumulators, fees/statements, ledger/documents and comparable groups/observations/runs. Reuse existing tables, add environment/dataset boundaries and model physical-payment states separately. Include PLATFORM_FEE_PAYMENT and PLATFORM_FEE/FEE_CREDIT target semantics. Landing-page fee copy must match FIN-03; no live tax or payment claim.

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

**Additional acceptance evidence.** Fresh-install and additive-upgrade migrations preserve existing identities/history. Landing copy discloses the 2% Vendor fee and TEST nature. No secret/sample taxpayer is seeded into a live dataset.

- A clean clone starts through the documented setup without hidden manual steps.
- All migrations run from an empty database and roll back safely in Development.
- Duplicate email, expired/reused OTP, wrong password, rate limit, revoked session, stale refresh token, Google account mismatch, and invalid TOTP cases are tested.
- Buyer and Vendor can register by email; Buyer/Vendor Google flow works with Development credentials.
- Admin cannot self-register and can activate only through the protected invitation flow.
- Vendor landing page is responsive, keyboard accessible, accurately states the marketplace, and links correctly to Sign Up and Sign In.
- No real secret is tracked or printed by application tests.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Include all revised Finance/Analytics schema groups and database uniqueness/balance/foreign-key constraints. Preserve existing migrations on an already built database. Generate ERD/data dictionary from the actual schema. Use blank .env.example entries for FINANCE_MODE, WITHHOLDING_SCENARIO, PLATFORM_TAX_PROFILE, LIVE_COMMERCE_ENABLED, MATERIALS_ANALYTICS_ENABLED and demo dataset identity; set local safe values only in ignored backend configuration. Do not create a BIR API integration. Reconcile stale fee/analytics wording in repository guidance against the newly approved workflows while preserving security and the existing UI tokens.

Implement MateryalPH Phase 1: complete baseline database schema, authentication for the Buyer Flutter app, Vendor React portal, and Admin React portal, plus the public Vendor landing page.

Before editing, read AGENTS.md, docs/architecture/MateryalPH_Technical_System_Design.md, docs/design/MateryalPH_UI_UX_Implementation_Planner.md, and all four files under docs/workflows. Inspect the current aligned repository and present a short implementation plan grouped as 1) secret-safe repo validation, 2) local infrastructure and scaffold alignment, 3) full v1 schema and ERD, 4) backend and three-client authentication, 5) shared UI foundation, and 6) Vendor landing page. Ask before coding only if a material requirement is genuinely unresolved.

Preserve the approved monorepo: apps/buyer-mobile, apps/vendor-web, apps/admin-web, services/api, packages/api-contract, packages/design-tokens, packages/web-ui, docs, infrastructure, and GitHub workflow directories. If the one-time repository alignment is not complete, stop and propose it as a separate Git-aware checkpoint before Phase 1. Validate .gitignore before any real environment file. Add blank .env.example files only. Add Docker Compose for PostgreSQL 16/PostGIS, Redis, Mailpit, and local S3-compatible storage.

Use Laravel 13 constrained as ^13.0, PHP 8.4, PostgreSQL 16 with postgis/pg_trgm/pgcrypto, Laravel Passport installed with `php artisan install:api --passport`, React 19/TypeScript/Vite 8/Tailwind, and Flutter/Dart. Do not leave Sanctum and Passport as competing primary guards; resolve the approved authentication ADR and remove only an unused package after tests pass. Implement every baseline table group and critical constraint in the technical design, using UUIDv7 IDs, UTC timestamptz values, integer centavos, foreign keys, checks, and appropriate indexes. Produce docs/architecture/erd.md and docs/architecture/data-dictionary.md from the actual migrations. Pin the PHP version in Docker and CI, record the framework/runtime decision in an ADR, and do not silently change the major framework version.

Implement email registration and hashed six-digit OTP verification, login, refresh-token rotation and reuse detection, logout, password recovery, Google OIDC Authorization Code with PKCE and server-side ID-token validation using stable sub, risk-based step-up foundations, TOTP and recovery-code foundations for privileged users, secure web cookies, Flutter secure-storage abstraction, rate limiting, correlation IDs, and audit events. Do not use browser localStorage for tokens. Do not implement SMS OTP. Admin has no public registration; add a protected one-time Super Admin invitation command with no default password.

Implement all authentication screens and states in the three clients using the UI planner's Inter typography, semantic construction palette, responsive rules, shared states, and accessible components. Build the Vendor public landing page with truthful marketplace, onboarding, verification, the approved 2% Vendor-paid commission billed monthly on completed materials excluding included Vendor VAT, disclosed third-party processing fees, TEST-only demonstration, and limitation content. Use the Figma file only for visual direction and record intentional corrections. Run the applicable Impeccable shape/critique/harden/audit/polish workflow. Meet WCAG 2.2 AA patterns.

Define/update OpenAPI 3.1, regenerate TypeScript and Dart clients, add unit/feature/component tests, and document local startup. Do not add or reveal real credentials. Do not deploy or commit. Run every available format, lint, static-analysis, migration, API, React, and Flutter test. Phase 1 is done only when an empty-database migration and the complete authentication acceptance gate pass. End with changed files, commands/results, manual Google setup still required, risks, and a suggested commit message.
```

---

# Phase 2: Authorization, Profiles, Agreements, and Account Security

## Outcome

Every authenticated request is restricted by account type, account status, organization, fixed role, delegation, ownership, resource state, and recent-authentication requirements. Users can manage allowed profile and security functions.

## Required Implementation

**Approved tax and Materials Analytics integration.** Add the exact finance and MAT-05 permission grants, Owner legal/fee-payment authority, Manager draft/view limitations, three distinct API audiences and separately approved Admin source inspection. Add data-scope policies for tax evidence, statements, certificates, observations, caches and exports.

- Implement Laravel policies and permission middleware from the approved matrices.
- Create Buyer, Vendor, and Admin route groups and deny cross-surface access.
- Implement versioned Terms, Privacy Notice acknowledgment, Vendor Code of Conduct, and required reacceptance.
- Implement Buyer profile, Vendor staff profile, Admin profile, session/device list, revoke-one, revoke-all, password change, email change, TOTP management, and recovery-code replacement.
- Implement Admin and Vendor staff invitation acceptance.
- Enforce Manager delegation rules and notify the Owner of delegated staff changes.
- Add authorization tests for every role/resource/action combination.

## Acceptance Gate

**Additional acceptance evidence.** Other Vendor staff cannot call competitor analytics; Vendor tokens cannot obtain Buyer offer serialization; finance and aggregate/source inspection are independent permissions. Preparer cannot approve their own tax package/adjustment.

Forbidden API calls return safe `403` or `404` results regardless of hidden UI. Role changes revoke incompatible sessions. Historical actor attribution remains intact.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement materials_analytics.view_competitors for Owner/Manager only; analytics.view_aggregates, materials_analytics.inspect_sources and the FIN-10 finance permissions as independent grants. Enforce ownership and authenticated platform scope on every route and cached/exported resource. Add meaningful denial and self-review tests, including two named demo reviewer identities without default passwords.

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

**Approved tax and Materials Analytics integration.** Implement versioned tax profile/evidence capture and review: synthetic TEST taxpayer key, entity class, TIN/COR metadata, VAT/classification, taxable-year boundaries, prior-year amounts, declaration/receipt/validity and outside-platform amount/overlap. Owner attests; Manager drafts. Record 2% fee Terms acceptance and DEMO withholding assignment; TEST evidence cannot authorize LIVE.

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

**Additional acceptance evidence.** Missing or expired relief evidence never implies zero CWT. TEST activation accepts only explicitly labeled test capabilities/fixtures; registration/assignment/funding remain mandatory future LIVE gates.

The backend refuses activation if any mandatory requirement is missing. Private documents are inaccessible across Vendors and to unauthorized staff.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement FIN-01/FIN-04/FIN-09 onboarding fields, evidence review and effective versions, distinct individual/corporate and VAT categories, plus invoicing-method/coverage review. Do not infer VAT status or withholding exemptions from an unchecked box or an 8% income-tax election. Record current approval scope and sample evidence origin. Preserve last-facility responsibility as UNCONFIRMED for LIVE, with approved DEMO_PLATFORM_WITHHOLDER and alternate DEMO_PROVIDER_WITHHOLDER fixtures.

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

**Approved tax and Materials Analytics integration.** Add comparable material/group mapping using exact brand/model/specification/variant/unit, versioned authorized unit conversions, immutable ordinary public price and tax-category records. Keep custom unmapped listings Not Yet Comparable. Do not average fuzzy material names or private quotations.

- Canonical categories, materials, aliases, `pg_trgm` search, units, conversions, tags, and technical attributes.
- Listing and variant creation with price versions, weights, dimensions, stock status, and photos.
- Three compliance input paths: photo/OCR, QR, and manual with required marking photo.
- Unified Review and Confirm, official reference adapter, Admin review queue, status history, and publication gate.
- Accessible bulk spreadsheet import with row-level errors and transactional validated rows.

## API/Key Step

Use local OCR where feasible. If Google ML Kit or another service is enabled, configure only its Development credential according to the environment guide. OCR output is never treated as approval.

## Acceptance Gate

**Additional acceptance evidence.** Different grades/diameters/brands/pack units cannot merge without validated equivalence. Unknown payable tax classification blocks payable publication. Unmapped but otherwise eligible listings remain usable outside aggregates.

A regulated listing cannot become Active without the applicable verified evidence. A nonmatch becomes pending review, never an automatic counterfeit accusation.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement MAT-03 comparable groups, versioned mapping and normalized ordinary VAT-inclusive public prices. Exclude promo/volume-tier/negotiated amounts from the analytics source. Retain financial classifications VAT_12, VAT_ZERO, VAT_EXEMPT and NON_VAT distinctly under FIN-02. Price, mapping, tax and publication changes must preserve source versions for later snapshots and accepted orders.

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

**Approved tax and Materials Analytics integration.** Implement EligibleOfferQuery shared by Explore counts/current offers and daily capture: active approved Tier 2 listing/variant, valid ordinary price/category/compliance, confirmed non-stale inventory and positive sellable quantity. Current count/cache invalidation follows stock, reservation, listing, price and Vendor eligibility changes. Exact stock stays private.

- Inventory balances, movements, reconciliation, reserved and soft-held reporting.
- Optimistic concurrency for manual edits and row locks for reservations.
- Price/version management and volume tiers if defined by the listing.
- Vehicles, capacities, cargo dimensions, rates, availability, service radius, and snapshot history.
- Auto-accept enabled/paused state, allotment, unit cap, amount cap, explicit resume, and permissions.
- Day 7/12 reminders and Day 15 temporary listing hide for unconfirmed stock.

## Acceptance Gate

**Additional acceptance evidence.** A listing with multiple variants counts once; unavailable/stale variants contribute neither current count nor a new eligible daily observation. Duplicate source offers cannot give one Vendor more aggregate weight.

Buyers never receive exact stock. Inventory cannot become negative. Auto-accept configuration does not apply to Project-Based procurement or any NRPC order.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Add the shared MAT-02 eligibility predicate and MAT-03 source version fields to the existing inventory/pricing service. Preserve historical observation sources rather than updating old prices in place. Wire bounded current-count invalidation to existing outbox events; do not add a Google market-data call or expose quantity_on_hand through analytics.

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

**Approved tax and Materials Analytics integration.** Carry the active Buyer location and selected exact radius into Explore and future Materials Analytics; Project origin is explicit. Support own-store-centered Vendor scope and PSGC Admin scope in shared Geography queries. Snapshot records retain the captured address/geography version.

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

**Additional acceptance evidence.** 50 km is the maximum Buyer/Vendor scope, not automatic expansion from 5 km and not an Admin national limit. Exact boundary and just-outside results are tested using PostGIS geography.

The Buyer can complete all discovery actions with GPS denied. Tier 1 Suppliers have no in-platform transaction action.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement MAT-01 scope resolution and stable origin/radius context. Use ST_DWithin on geography in meters; never use route distance for membership. Vendor market requests cannot select a competitor origin. Keep location ownership, privacy and optional GPS rules, and reject unsupported radius values on the backend.

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

**Approved tax and Materials Analytics integration.** Add Nearby Verified Vendors and Available Products above Explore categories using current distinct eligible organization/listing counts, before category filters. Prepare the View Materials Analytics entry point with explicit availability gating until Phase 14. Checkout preview follows FIN-02 included VAT, M/D/F/N and excludes Vendor commission/CWT.

- Search, filters, product/vendor detail, active-stock rules, price normalization, and pagination.
- Normalized SRS with exact default weights and separate Buyer overrides.
- Best Price only for comparable variant/unit/service radius with stock.
- Favorites and Favorites First without silently changing Best Deal.
- Cart validation, Vendor grouping, delivery/pickup choices, physical-payment eligibility, and checkout preview.
- No stock reservation at cart time.

## Acceptance Gate

**Additional acceptance evidence.** Counts handle variants, duplicate materials across stores, stale stock and radius changes correctly. No broken analytics navigation ships before its feature is enabled. Buyer totals never include 2% commission or merchant CWT.

Ranking is deterministic and explainable. All weight sets total 100%. A cart preview detects stale price, stock, serviceability, and Vendor status without creating an order or reservation.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Build the Explore dashboard with current_as_of, visible scope and accessible summary cards. Use one server request snapshot for both counts, label Product count as Vendor listings, and show no false zero while loading. Preserve filters/scroll and reject stale async responses. Keep Materials Analytics disabled until the Phase 14 end-to-end feature is installed. Use FinancialSnapshotService-compatible included-VAT preview; never normalize market averages into an order price.

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

**Approved tax and Materials Analytics integration.** Snapshot FIN-02 amounts, line discounts/VAT, fee-policy version, NRPC affected-line allocation and accepted version/hash. Add immutable ESTIMATED fee assessment and audited completion-event contract. Physical obligations are separate from online payment state; all-or-none stock remains atomic.

- Order, line, price, fee, delivery, payment-method, and policy snapshots.
- Canonical transition service and immutable history.
- Vendor confirmation, permitted revision, Buyer approval, decline/expiry.
- Manual-only NRPC reason, amount, affected lines, Terms version, Buyer acceptance/flag.
- Atomic hard reservation with deterministic row locks and all-or-nothing multi-line behavior.
- Item-Based auto-accept transaction, policy snapshot, allotment decrement, pause, and manual fallback.
- 45-minute displayed payment expiry and reservation release.

## Acceptance Gate

**Additional acceptance evidence.** Largest-remainder discounts and partial principal VAT allocation sum exactly. NRPC reduces only principal once. An accepted order retains original prices/tax/fee policy when a listing or market average changes.

Concurrency tests prove no overselling. NRPC can never be introduced after Buyer acceptance/payment and never participates in auto-accept.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement FIN-02 centavo Money and immutable financial snapshots, including VAT_12 included tax L*12/112, E=M-V and the full Online/direct cash/mixed NRPC amount matrix. Validate 0<N<=eligible prepared-material subtotal without introducing a numeric platform NRPC cap. Prepare unique fee estimation and completion events for FIN-03 without earning a fee on payment or confirmation. Add allocation/rounding and snapshot-version tests.

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

**Approved tax and Materials Analytics integration.** Use the same financial snapshot calculator for Item/Project quotation publication/acceptance. The accepted version records line tax/discount/NRPC and estimated fee-policy version. Public market analytics must not ingest quotation prices or Work Package contents.

- Authorized conversations, participants, handlers, transfer system messages, receipts, and attachments.
- Buyer-visible store and staff identity without personal staff contact details.
- Draft/publish/revise/withdraw quotation, 1–72 hour deadline, default 24 hours, reminder, expire, accept/reject/counter.
- Immutable quotation versions, before/after audit, content hash, and plain-language change summary.
- Soft holds on publish; immediate release on counter/reject/expire/withdraw.
- Acceptance-time atomic revalidation and hard reservation.
- `ITEM_BASED` and `PROJECT_BASED` flags; no duplicated engine.

## Acceptance Gate

**Additional acceptance evidence.** Private negotiated quotation price changes do not alter any public market average; quotation acceptance still requires latest version and atomic stock validation.

An old quotation version cannot be accepted after revision. Unauthorized users cannot subscribe to or retrieve another conversation.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Integrate FIN-02 into the shared quotation engine and preserve source tax/price versions in the accepted order. Reject unknown payable tax category before publication. Mark quotation and completed transaction prices as private transaction sources; exclude them from MAT snapshot queries and competitor payloads. Preserve the existing deadline/counter-offer/NRPC audit logic.

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

**Approved tax and Materials Analytics integration.** Apply FIN-11 disjoint budget buckets: pending incomplete obligations, completed/retained actual cost, and paid cancelled amounts awaiting recovery. Committed Spend is their sum; Remaining Budget=Budget-Committed Spend. Include actual materials VAT/delivery/Buyer fees and count NRPC once. Analytics planning does not mutate a Project budget.

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

**Additional acceptance evidence.** Paid cancellation releases refundable budget only after successful recovery; unpaid obligations release at cancellation. Vendor CWT/commission/fee payment cannot affect Buyer budgets.

The locked original never changes. Every Vendor change is visible before acceptance. A Work Package ends with one selected Vendor, not split competitive awards.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement FIN-11 using Committed Spend = Pending incomplete order cost + Actual completed/retained cost + Paid cancelled amount awaiting recovery, and Remaining Budget = Budget - Committed Spend. Keep these buckets disjoint and never subtract Actual Spend twice. Link market-analysis navigation to the explicitly selected Project site only; do not replace accepted quotes or set project costs from historical averages.

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

**Approved tax and Materials Analytics integration.** Implement FIN-01–FIN-06/FIN-10 in Finance: exact amounts, tax profiles/threshold locks, canonical remittance groups, simulated responsibility adapter, 0.5% qualified base, 2% completed-material commission service, monthly statements, platform fee payments, separate ledgers, physical collection records and reconciliation. Add APIs for review/approval; later Admin pages use these APIs.

- Payment adapter and fake adapter for automated tests.
- Xendit sub-account capability/connection checks.
- Payment methods from actual configuration; refund-incompatible channels disabled for MVP.
- Server-side payable amount and processing-fee snapshot.
- Full-order, NRPC-assurance, order-balance and separate platform-fee payment purposes with account/ledger validation.
- 45-minute expiry and callback/return pages that show pending until webhook confirmation.
- Authenticated, idempotent Xendit webhook inbox and asynchronous processor.
- Scheduled reconciliation, exception queue, and technical compensation trigger when capture occurred after application failure.

## API/Key Step

Follow the Xendit Test Mode section in the environment guide. Paste the secret key and callback token only into the backend Development/Staging environment. Never expose them in React, Flutter, logs, or screenshots.

## Acceptance Gate

**Additional acceptance evidence.** Execute all FIN-06 exact arithmetic cases plus concurrent crossing, missing declaration, year rollover, duplicate group, external-total overlap, mismatched account/purpose, balance constraints and paid-fee credit. Payment success alone cannot prove withheld tax or fee earning.

A forged, duplicate, reordered, mismatched-amount, or unknown webhook cannot create a paid order. Browser redirect alone never marks `PAID`.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement the full embedded FIN contract in Technical Design 13.2. G=C-R-D_r-V_r-P; W=half-up(G*0.005); expected Vendor cash=C-R-P-W; commission_deducted_in_remittance=0. Tax the full crossing remittance; missing declaration is subject unless valid other relief; retain prior-year/breach evidence and do not double count external declarations. Lock taxpayer/year and unique group/obligation, then post/outbox without network calls under the lock. DEMO tax adapter is separate from actual Xendit TEST payment evidence, including the provider-withholder alternate that never deducts twice. EARNED fee is 2% of completed nonrefunded exclusive materials; implement ESTIMATED/EARNED and original-target credits without premature earning. Draft monthly statements at 00:05 first day, approved by third, due fifteenth or twelve days after late issue. Owner pays positive bills to platform TEST account with PLATFORM_FEE_PAYMENT, 45-minute attempts, no auto debit/splits, and platform absorbs its bill processing fees. Persist FIN-10 states/ledger accounts, physical-payment evidence, installment allocation and reconciliation exceptions. Execute FIN-06/FIN-12 unit/feature/concurrency fixtures using fictional processor rates, explicitly separate from real provider-price claims.

Implement MateryalPH Phase 11 using Xendit Test Mode: checkout payment creation for Vendor sub-accounts, payment-processing-fee snapshots, payment purposes, verified webhooks, idempotency, expiry, reconciliation, and safe client return pages.

Read the current Xendit documentation linked in the technical design before choosing request fields. Put all provider code behind PaymentGateway and include a deterministic fake. Use only backend environment variables already entered by the user; never print them. Determine enabled methods from configured capabilities and keep refund-incompatible MVP channels disabled.

Calculate the payable amount on the server from immutable order snapshots. Store materials, delivery, actual configured Payment Processing Fee, total, channel/rate snapshot, Vendor sub-account, idempotency key, provider IDs, purpose, and expiry. Support FULL_ORDER_PAYMENT, NRPC_ASSURANCE_PAYMENT and ORDER_BALANCE_PAYMENT without double charging NRPC, plus PLATFORM_FEE_PAYMENT to the separate platform TEST account without treating it as a Vendor remittance.

Implement /api/v1/webhooks/xendit as a fast webhook inbox: verify callback token/signature with constant-time comparison, store the raw event safely once by provider event ID, acknowledge, then process asynchronously. Recheck provider transaction ID, amount, currency, reference, sub-account, and allowed transition. Redirect/callback UI remains Pending until a verified event or authoritative reconciliation sets PAID. Add scheduled reconciliation and an idempotent technical-compensation path only when capture is proven after an application failure.

Update OpenAPI, clients, Buyer/Vendor/Admin payment views, audit/outbox events, and integration tests for success, pending, failed, expired, forged, duplicate, reordered, mismatch, timeout, and reconciliation. Do not use live keys, deploy, or commit.
```

---

# Phase 12: Fulfillment, Cancellation, and Automatic Cancellation Refunds

## Outcome

Vendors process orders through pickup or delivery milestones with proof. Permitted paid cancellations calculate the correct amount and automatically initiate the separate Cancellation Refund.

## Required Implementation

**Approved tax and Materials Analytics integration.** Wire COMPLETED to one fee earning and finalized cancellation to immediate online refund outbox, unpaid-physical release or evidenced cash reimbursement, fee cancellation/credit and tax-review reference. Tax and commission do not reduce Buyer refund targets. Add own-platform fee credit refund target separate from order refunds.

- `CONFIRMED → PROCESSING → READY_FOR_PICKUP/OUT_FOR_DELIVERY → PICKED_UP/DELIVERED → COMPLETED`.
- Expected date, vehicle/trip confirmation, staff assignment, proof, receiver, and audit history.
- Buyer two-day receipt confirmation and paused auto-completion when an issue is open.
- Cancellation withdrawal/request/finalization rules and cutoff.
- Vendor cancellation: full Buyer-paid refund, NRPC forfeiture, NFR event, and reservation release.
- Buyer cancellation in Processing: documented NRPC evidence/retention where eligible.
- Automatic idempotent Cancellation Refund to original method; status follows webhook/reconciliation.

## Acceptance Gate

**Additional acceptance evidence.** A Vendor cancellation of mixed paid NRPC refunds the original online payment including disclosed processor fee, forfeits NRPC and earns no commission. No cash Refund API is invented. Failed funding remains visible. Completion replay does not earn twice.

Cancellation is blocked at Ready for Pickup or Out for Delivery while Report a Problem and statutory remedies remain accessible. Refund initiation and refund success are distinct.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Apply FIN-07 with target-type-aware refunds and FIN-03 completion earning. Use original line/discount/VAT allocations, cap successful/in-flight refund totals, and separate VENDOR_REIMBURSEMENT_PENDING/REIMBURSEMENT_CONFIRMED from provider states. Queue the supported online Refund API immediately after commit. Create ADJUSTMENT_REQUIRED for posted CWT instead of automatically recovering tax from BIR. Preserve cancellation cutoff and statutory remedies. For a paid fee credit use PLATFORM_FEE/FEE_CREDIT tied to original fee capture; never take unrelated Buyer funds.

Implement MateryalPH Phase 12: fulfillment milestones and evidence, delivery/pickup tracking without live GPS, Buyer receipt confirmation, cancellation rules, reservation release, and automatic Cancellation Refunds for already-paid finalized cancellations.

Enforce all transitions through the shared server state machine. Implement expected fulfillment date, assigned staff, confirmed vehicle/trips, preparation, ready, dispatch, delivery/pickup proof, receiver, Buyer confirmation, and two-calendar-day auto-confirmation that pauses for an open issue/dispute. Keep live GPS outside scope.

Allow withdrawal before Vendor confirmation and reasoned cancellation requests from CONFIRMED through PROCESSING. Disable cancellation at READY_FOR_PICKUP and OUT_FOR_DELIVERY while preserving Report a Problem, dispute, return, warranty, and statutory-remedy actions. Vendor cancellation forfeits NRPC, refunds all Buyer-paid order amounts, releases reservations, and creates the applicable NFR event. Eligible Buyer cancellation may retain only accepted, evidenced NRPC under the documented rules.

When a paid cancellation becomes final, create exactly one CANCELLATION refund record and immediately submit the idempotent provider request. Set REFUND_PENDING on successful initiation; wait for verified provider events/reconciliation before REFUNDED or REFUND_FAILED. Return only to the original supported method. Never open a dispute automatically.

Update all clients, OpenAPI, notifications, audit history, and tests for each actor/state/cause/payment combination, provider timeouts, duplicate cancellation, duplicate webhooks, and reservation release. Use Xendit Test Mode only. Do not deploy or commit.
```

---

# Phase 13: Disputes, Appeals, Dispute-Conclusion Refunds, and Invoices

## Outcome

Buyers and Vendors can resolve documented cases through timed steps. A refund is created only when a concluded decision awards it. Buyers can access Vendor-issued invoice records and request copies/corrections; the Vendor must issue through its registered process when legally due, while MateryalPH provides separately labeled operational/demo files.

## Required Implementation

**Approved tax and Materials Analytics integration.** At an enforceable dispute conclusion, apply the awarded online/physical components, original VAT/discount allocations, commission target credit and reviewed tax correction. Separate Vendor goods invoice, platform service invoice, processor invoice and 2307. Invoice copy requests do not postpone legally due issuance.

- Structured dispute/refund-request form, evidence, Case ID, masked original method, no alternative destination.
- 48-hour response, 72-hour mutual resolution, 24-hour clarification, five-business-day appeal.
- Admin decision and remedy tracking.
- Separate Dispute-Conclusion Refund linked to decision version and case.
- Review-withholding and order auto-completion pause.
- Invoice request, Vendor upload, three-business-day service target, authorized access, and audit.

## Acceptance Gate

**Additional acceptance evidence.** Filing a dispute cannot trigger a refund. An awarded partial refund cannot exceed original lines or refund twice; a dispute hold does not overwrite earned-fee state. A generic PDF is not labeled structured e-invoicing compliance.

Filing a dispute never creates `REFUND_PENDING`. A concluded refund award creates exactly one linked refund and the case remains open until the remedy reaches a terminal state.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement FIN-07/FIN-09 dispute and invoice details. Make invoice records available when received/legally due rather than only after completion or Buyer request; the three-business-day copy target is not an issuance extension. Validate issuer/type and reconcile document differences without changing accepted Buyer totals. Refund awards create linked fee adjustments and tax review; no automatic filed-return amendment, alternate online refund destination or removal of statutory remedies.

Implement MateryalPH Phase 13: transaction disputes, mutual resolution, Admin clarification/decision, one appeal, remedy tracking, Dispute-Conclusion Refunds, returns, and Vendor invoice-request/upload workflow.

Implement the documented states and Asia/Manila deadlines using exact stored instants and visible countdown plus date/time. The filing form includes issue type, affected lines, remedy, requested partial amount, description, evidence, and masked original payment method for information. It must never collect a different refund destination. Filing creates a Case ID and dispute state only.

Implement 48 calendar hours for response, 72 calendar hours for mutual resolution after response, 24 calendar hours for requested clarification, and one appeal within five business days with new evidence or material process error. Preserve all evidence and decisions immutably. Implement Dismissed, Replacement, Full/Partial Refund, Warning, metric event, Restriction, Suspension, Ban, and Inconclusive outcomes within role permissions.

Only a concluded decision awarding money creates one idempotent DISPUTE_CONCLUSION refund linked to Case ID and decision version. Keep it separate from CANCELLATION. Track REFUND_PENDING through provider events and do not resolve the case until the remedy completes.

Implement FIN-09 invoice availability and copy/correction requests with protected externally issued invoice records, metadata, three-business-day copy service target, reminders and audit; do not delay legally due issuance or assume an uploaded PDF proves BIR compliance. Label MateryalPH PO/payment files as not tax invoices. Update clients, OpenAPI, notifications, and exhaustive timeline/authorization/refund tests. Use Test Mode only. Do not deploy or commit.
```

---

# Phase 14: Reviews, Scores, Badges, and Price Insights

## Outcome

Verified completed purchases produce controlled reviews, daily Vendor scores, automatic badges, and local price insights without misleading small samples.

## Required Implementation

**Approved tax and Materials Analytics integration.** Deliver MAT-01–MAT-07 end to end for Buyer and Vendor using the shared daily snapshot service and source observations. Enable Explore navigation only now. Build categorized lists, canonical Material Price Details, exact-date graph/table, current offers for Buyers and own-price versus suppressed competitor averages for Owner/Manager. Keep trust score inputs separate.

- 14-day review window, double-blind reveal, 24-hour edit, dispute withholding, moderation.
- MQS/VCS 90-day windows, OHS 30-day window, sample gates, and daily VPS calculation.
- CRR, FRR, and NFR event definitions from verified source events.
- Exact badge triggers and automatic removal; Admin suppression only for documented fraud/compliance findings.
- MAT-01–MAT-07 public listed-price observations only, 7/30/90-day and bounded custom ranges; completed-sale and quotation prices remain separate private records.

## Acceptance Gate

**Additional acceptance evidence.** Pass every MAT-07 fixture and inspect actual JSON for competitor identity leakage. Test duplicates, unit/spec mismatches, equal weighting, tax-inclusive amounts, exact endpoints, missing data, changed participants, daily job replay, revoked roles and cached response isolation.

Canceled, test, duplicate, fraudulent, or otherwise ineligible activity cannot affect scores. Low samples show “New Vendor — Building Track Record.”

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement MAT-01–MAT-07 exactly, replacing old mixed listing/completed-sale insight logic. Capture eligible public ordinary prices daily at 00:10 Asia/Manila into immutable published runs; retain actual time and geography and never fabricate a missed day. Deduplicate one Vendor/group by latest published ordinary-price effective timestamp then stable variant ID; average equally without inventory weighting. Buyer Explore -> Materials Analytics -> Material Price Details -> current Vendor Product Details must be fully functional and accessible. Provide 7/30/90-day and <=365-day custom ranges, PHP/unit, current versus historical timestamps, graph gaps/table, counts, null insufficient-data states and ((end-start)/start)*100 from unrounded means. One-seller Buyer average is limited-data; trend needs two sellers at each exact endpoint. Vendor Owner/Manager requests exclude own organization and suppress every competitor point/variant/endpoint below three distinct competitors, with no exact small count or individual store/offer identifiers. Use separate backend serializers, policies and cache keys; no Vendor token can request Buyer offer output. Own listing edit is an explicit normal authorized edit. Seed clearly labeled isolated DEMO history and test the 100/110/120=>110 and 100=>110=+10% fixtures plus all MAT-07 cases. No market-data API, forecast, automatic price change or private quote source is added.

Implement MateryalPH Phase 14: verified-purchase reviews, moderation, MQS/VCS/OHS/VPS and operational metrics, automatic badges, and local price-trend insights.

Use the exact windows, minimum samples, formulas, exclusions, and badge thresholds in the System Workflow. Implement a 14-calendar-day rating window, hidden-until-both-or-expiry publication, 24-hour edit lock, dispute withholding, immutable moderation history, and product/vendor rating separation. Never permit a Vendor to delete a Buyer review.

Generate metric events from authoritative order/fulfillment/dispute facts and calculate daily snapshots. Display New Vendor — Building Track Record below minimum samples. Automatically award/remove performance badges; Admin may suppress for a documented fraud/compliance case but may not manually award them.

Implement Materials Analytics using only MAT-03 ordinary public listed-price snapshots, exact comparable groups, equal Vendor weights and MAT-04 date/sample rules. All private quotation and completed-sale prices are excluded. Isolated seeded market observations are permitted only in labeled DEMO datasets; do not confuse them with trust-score eligibility. Never label a result an official market price.

Update Buyer/Vendor/Admin UI, OpenAPI, jobs, audit events, and deterministic fake-clock tests for every threshold/window edge. Do not deploy or commit.
```

---

# Phase 15: Notifications, Reminders, PDFs, and Exports

## Outcome

Users receive reliable in-app, push, and email notices. The system produces authorized Purchase Orders, confirmations, budget reports, summaries, and operational exports.

## Required Implementation

**Approved tax and Materials Analytics integration.** Add FIN-08/FIN-09 sample invoice/certificate/return support packages, monthly statement PDFs and legal-date reminders. Reconcile issuer/payee/month/quarter/ATC and include required zero/exempt payee rows. Export MAT aggregates with the same audience restrictions; Vendor export cannot contain individual competitors or suppressed samples.

- Notification templates, preferences, mandatory classes, device tokens, delivery attempts, deep links, and retry rules.
- FCM for Buyer push and Web Push where supported.
- Email provider adapter; Mailpit locally.
- Scheduled deadline/reminder jobs.
- Purchase Order, payment confirmation, procurement summary, budget PDF/CSV, and internal operational reports.
- Private export storage, expiry, access logs, and data minimization.

## API/Key Step

Configure Firebase Development credentials and nonlocal email credentials from the environment guide. Keep the Firebase service account only on the backend.

## Acceptance Gate

**Additional acceptance evidence.** Only DRAFT/REVIEWED/EXPORTED/SIMULATED_SUBMISSION_RECORDED is possible for demo tax reporting. Missing legal-date review blocks review readiness. Export alone cannot mark FILED or BIR_PAID; spoofed issuer and same-user approval fail.

Notification-provider failure does not roll back a committed order. Deep links recheck authorization. Mandatory notices cannot be disabled.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement tax packages for 2307, 0619-E support, 1601-EQ/QAP and annual 1604-E/alphalist using FIN-08 effective ATCs WI820/WC820 versus WI830/WC830, calendar-quarter grouping and the versioned non-eFPS demo deadline calendar. Keep taxable-year threshold counters separate. Watermark all sample artifacts, store export hashes and exact source versions, and require independent reviewer. Unknown/overridden due dates show DUE_DATE_REVIEW_REQUIRED with source/reviewer. Distinguish external Vendor goods invoices, platform fee invoices and processor documents; PDF upload alone is not compliant structured e-invoicing. No live BIR API submission or actual government receipt is fabricated. Apply MAT suppression and scope to authorized exports, neutralize spreadsheet-formula injection and revoke access when permissions change.

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

**Approved tax and Materials Analytics integration.** Embed Materials Analytics in the Philippine Geographic Marketplace Analytics section with nationwide/PSGC scope, compatible category/date filters, limited-sample labels and separate authorized source inspection. Add FIN tax/fee/evidence/adjustment/statement/package queues and independent review controls to Admin and existing Vendor finance pages.

- Vendor verification, product compliance, dispute/appeal, review moderation, user enforcement, invoice, privacy, job health, and refund-monitoring queues.
- Non-secret Platform Settings with versioning and validation.
- Searchable append-only audit log and access logging.
- PSGC map: Philippines → Region → Province or independent/highly urbanized city → City or municipality.
- Global geography/date/procurement/category/fulfillment/payment/state filters.
- Gross/net GMV, order volume, fulfillment/cancellation/dispute rates, response distribution, demand heatmap, Buyer/Vendor DAU/WAU/MAU.
- Small-cell suppression, unresolved geography, accessible table, and export controls.

## Acceptance Gate

**Additional acceptance evidence.** Admin aggregate access cannot inspect source listings without the separate permission; finance is separately authorized. Payment/order filters do not change listed-price observations. Source/export reviews are attributable and test data never mixes with live figures.

Aggregate permission never exposes exact Buyer coordinates. Auto-accept and app opens alone do not count as human Vendor activity.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Implement MAT Admin lists/details/charts inside the existing geographic section, with source inspection only for materials_analytics.inspect_sources and a recorded reason. Nation/region/province/city/municipality filters use PSGC; do not impose a national 50 km circle. Mark transaction-only filters inapplicable to price panels. Add FIN-10 queues and scoped screens for evidence, remittance reconciliation, fee approval/payment status, overdue debt, tax adjustments and sample report readiness. Use two distinct named finance users for required preparation/review. Display gross/net GMV independently from CWT, commissions, platform revenue, collected cash and receivables. Add materials snapshot health and labeled demo datasets; no Admin rate/edit control can bypass source/effective-date review or LIVE gates.

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

**Approved tax and Materials Analytics integration.** Harden finance evidence/ledger export and market responses against cross-organization access, role spoofing, cache leakage, arbitrary grouping, scraping amplification, SQL injection and sensitive logging. Check responsive Explore cards and graph/table keyboard, screen reader, contrast, touch and reduced-motion behavior.

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

**Additional acceptance evidence.** Raw payloads/logs/exports never contain unauthorized competitor identity, exact stock or tax evidence. Server checks survive hidden-button bypass. No binary-float money drift or unbounded date/radius query is accepted.

Critical/high security findings are fixed or formally blocked from release. No accessibility blocker exists on a critical journey.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Add threat-focused tests for FIN-10 and MAT-05 with authenticated audience/organization/permission isolation, rejected role/filter overrides and revoked cached downloads. Exercise exact origin/radius validation, bounded 365-day queries, run publication and count invalidation. Measure seeded query plans with Technical Design Section 14 fixtures; report actual hardware/timings. Preserve the stated limitation that public Buyer listings can reveal stores, without claiming complete anonymization. Audit all new financial and analytics UI states and exports for accessibility and secret/evidence leakage.

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

**Approved tax and Materials Analytics integration.** Run a complete capstone scenario across Buyer, Vendor Owner/Manager, denied staff and two named Admin reviewers, including FIN-06/FIN-12 and MAT-07, real Xendit TEST evidence where supported and clearly distinct simulated deductions/history.

- Cross-client end-to-end suite for Buyer, Vendor roles, and Admin roles.
- Seeded deterministic Development/UAT dataset labeled as test.
- Xendit test scenarios, Google/FCM/email/storage failure adapters, fake time, and duplicate webhook replay.
- Inventory concurrency/load tests.
- UAT scripts for Item-Based, Project-Based, Order-from-Chat, NRPC, cancellation, dispute, and refund paths.
- Backup, restore, rollback, migration, and failed-job replay drills.
- Requirements traceability matrix from workflow rule to test ID.

## Acceptance Gate

**Additional acceptance evidence.** Record actual test results, screenshots and expected-versus-actual centavo values; demonstrate three-competitor visibility and two-competitor suppression, then cancellation/dispute finance separation and blocked LIVE. No document-only validation is reported as implemented success.

All critical journeys pass. There is no unresolved Severity 1 or Severity 2 defect. Restore and rollback are demonstrated, not assumed.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Create a reproducible demo/UAT script: Explore counts -> categorized material/variant averages -> exact-date graph -> Buyer named Vendor offers -> Owner/Manager aggregate-only competitor comparisons -> denied staff -> Admin geography/source permission. Then run VAT/non-VAT, valid/missing declaration, threshold crossing under concurrency, physical cash, mixed NRPC, completion/monthly fee payment, Vendor cancellation and partial dispute refund, report review/export and disabled live gate. Use separate isolated financial/market fixtures so no synthetic history or tax certificate is represented as actual market data/BIR evidence. Replay duplicate/out-of-order events and failed daily capture/refund funding; capture real results and unresolved provider capability separately.

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

**Approved tax and Materials Analytics integration.** Deploy to an explicitly TEST/DEMO environment with finance/analytics schemas, scheduler/worker, dataset-separated cache/queues/storage and known-good demo fixtures. Register monthly billing 00:05, daily prices 00:10 and bounded reconciliation jobs; new finance/analytics settings contain no secrets.

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

**Additional acceptance evidence.** After deployment, verify one published daily run, snapshot failure visibility, demo statement draft, API audience restrictions, sample export access and payment-mode labels. The environment cannot activate LIVE from a flag alone.

Staging deploys only after CI passes. Migration, health, worker, scheduler, Reverb, payment webhook, private storage, and critical smoke tests succeed. A rollback is rehearsed.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

Extend CI/CD and staging runbooks for Finance/Analytics additive migrations, schema/contract checks, worker queues, shared scheduler locks and database uniqueness. Use finance:dry-run or tested command equivalents for job verification without fake provider success; implement/document any command before invoking it. Keep new configuration backend-only, preserve quarterly secret rotation and separate envs, and do not request a BIR key. Smoke-test count/list/graph, Owner/Manager suppression, Admin source permission, ledger reconciliation and failed-job alerts before accepting staging.

Prepare MateryalPH Phase 19: production-grade CI/CD configuration and the isolated Staging deployment on Render Singapore. Do not perform an external deployment until I explicitly authorize it after reviewing the diff and required secret checklist.

Read AGENTS.md, technical design, environment guide, and complete test plan. Create path-aware GitHub Actions for Laravel formatting/static analysis/tests with PostgreSQL/PostGIS and Redis, both React lint/test/build jobs, Flutter analyze/test/build checks, OpenAPI validation/client drift, secret scan, dependency audit, and container scan. Use least-privilege workflow permissions and protected staging/production environments.

Create a root render.yaml for isolated Staging services: Laravel API Docker web service, queue worker, Reverb web service, scheduler cron, PostgreSQL 16, managed Redis-compatible key value, Vendor static site, and Admin static site. Use Singapore region for stateful/backend resources. Reference secrets without values. Add health checks, pre-deploy migrations, non-root image, optimized Laravel caches, graceful shutdown, and safe worker retry settings.

Document exact dashboard-only steps for entering Staging secrets, Google callback/host restrictions, Xendit Test Mode webhook URL/token, Firebase, email, private storage, and Sentry. Add post-deploy smoke checks and rollback commands. Add internal Flutter build instructions with ignored signing files and protected CI secrets.

Validate YAML/Docker/builds locally where possible. Stop before external creation/deployment and present the required approvals, costs to verify, secret checklist, and acceptance steps. Do not commit or push.
```

---

# Phase 20: Production Readiness and Controlled Release

## Outcome

The approved deliverable is a controlled capstone demonstration release in TEST/DEMO. Complete it after the measured acceptance gates pass. The following real-commerce readiness material is retained as a future conditional checklist; no live deployment, production key collection or official filing is authorized by this phase.

The tested Staging deployment is promoted to the named capstone demonstration release after its security, accessibility, UAT, backup and operational checks. TEST credentials and simulated data remain isolated. Moving to real commerce is a separate future action requiring provider, legal, privacy and business approvals.

## Required Implementation

**Approved tax and Materials Analytics integration.** Complete the approved capstone demonstration release using existing TEST credentials and watermarked simulated finance/market fixtures. Record future LIVE prerequisites without blocking the academic delivery or treating demo evidence as production approval.

- Formal go/no-go checklist and named approval owners.
- Verify TEST payment/refund capabilities and clearly simulated withholding; record future Xendit LIVE contract, responsibility and funding prerequisites as unresolved where appropriate.
- Verify the existing demo Google project/key restrictions, quotas, domains, app identifiers and OAuth configuration; keep future production credentials separate.
- Verify the demo database/backups, storage lifecycle, email, FCM, monitoring, alerts and named support owner without representing demo evidence as production approval.
- Migration rehearsal, deployment, smoke tests, rollback trigger, status communication, and incident response.
- Prepare signed demonstration builds for the agreed distribution method; public app-store submission requires a separate explicit instruction.
- 90-day secret rotation calendar and first rotation owner.

## Acceptance Gate

**Additional acceptance evidence.** Demo UAT, security, accessibility, restore and deployment gates pass with actual evidence. Xendit/finance remain TEST/DEMO; unconfirmed registration/withholder/funding prevents real commerce. No real BIR filing, test-to-live promotion or live credential request is part of this capstone release.

No capstone release occurs with unresolved critical/high implementation findings, exposed secrets, default credentials, unverified TEST refund behavior, misleading real-money claims or untested restore/rollback. Isolated, labeled TEST data/keys are required for this demo. A future LIVE release additionally prohibits test data/keys and requires authentic provider/legal approvals.

## Copy-Paste Codex Prompt

```text
Use the approved FIN-01–FIN-12 financial contract and MAT-01–MAT-07 Materials Analytics contract for this phase, as detailed in the revised workflows and technical design.

For this approved project, complete the capstone TEST/DEMO release path only. Audit FIN-12/MAT-07 evidence, scheduled snapshots, reviewed sample finance packages, permission tests, restore/rollback and visible environment labels. Keep LIVE_COMMERCE_ENABLED false and record unresolved authentic registration, last-facility assignment, fee/tax classification, invoice and refund-funding requirements as future deployment gates. Do not ask for production keys or claim a simulated certificate/return is filed. A future real-commerce release requires a separate explicit request and authentic approvals; the existing conditional production checklist below is not authorization to execute it.

Prepare MateryalPH Phase 20 capstone demonstration release from accepted Staging. Start with a readiness audit and a concrete release/rollback package. Keep payment, finance and material fixtures TEST/DEMO and real-commerce activation disabled. Do not create LIVE infrastructure, enter/rotate live keys, submit to app stores or change DNS. For any external deployment not already authorized in the active session, complete the reviewable package before requesting the final deployment approval.

For a future separately authorized LIVE release only, audit all workflow requirements, Phase 18 results, Staging evidence, security/privacy/accessibility findings, dependency status, backup/restore proof, rollback proof, monitoring, support ownership, and incident runbooks. Verify that Xendit live account approval, sub-account capabilities, enabled payment/refund channels, processing-fee treatment, and webhook configuration have written confirmation. Verify legal/tax/privacy approval for Terms, NRPC, cancellation/refund disclosures, invoice wording, retention, and processor arrangements.

For that future separately authorized LIVE release only, generate a Production environment checklist with new non-reused credentials, least privileges, restricted Google keys, protected GitHub/Render secrets, debug off, test seeders blocked, backups enabled, alerts tested, domains/TLS/CORS/cookies/OIDC callbacks exact, and a 90-day rotation register. Generate the migration/release/smoke/rollback sequence with decision points and responsible owner placeholders.

For an authorized capstone deployment, execute the reviewed TEST/DEMO release steps, report each result, stop on any failed gate, never print secrets, and never mark payment/refund successful from a browser redirect. A later request for live deployment must separately satisfy all future LIVE gates. Finish with release evidence, known limitations, operations handoff, and next rotation date. Do not commit or push unless asked.
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
