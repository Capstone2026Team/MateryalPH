# MateryalPH Repository Instructions

## Mission

Build MateryalPH according to the approved System, Buyer, Vendor, and Admin workflows, `docs/architecture/MateryalPH_Technical_System_Design.md`, and `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`. The workflows and technical design define product behavior; the UI planner defines the approved implementation experience. Do not invent or silently change a role, status, timer, formula, payment rule, refund trigger, map tier, or excluded feature.

## Required Working Method

1. Inspect the relevant workflow, architecture, migrations, OpenAPI paths, and tests before editing.
2. For a complex task, present a short plan and identify affected domains.
3. Ask before implementing a material requirement that is genuinely undefined or contradictory.
4. Make the smallest complete vertical change: database, backend rule, authorization, API contract, affected clients, audit/notification behavior, and tests.
5. Run relevant checks and review the diff before reporting completion.
6. Do not deploy, push, merge, rotate credentials, or perform destructive database/Git actions unless explicitly requested.

## Repository Layout

- `apps/buyer-mobile`: Flutter Buyer app.
- `apps/vendor-web`: React Vendor public/authenticated portal.
- `apps/admin-web`: React Admin portal.
- `services/api`: Laravel 13 modular monolith.
- `packages/api-contract`: OpenAPI 3.1 and generated clients.
- `packages/design-tokens`: canonical semantic tokens plus generated web/Flutter outputs.
- `packages/web-ui`: shared accessible React primitives.
- `docs/workflows`: authoritative approved workflows.
- `docs/architecture`: technical design, ERD, data dictionary, and ADRs.
- `docs/design`: UI/UX planner, reviewed Figma deviations, and design-quality evidence.
- `docs/security`: threat model and safe templates without secret values.
- `docs/test-plans`: UAT, traceability, recovery, and release checks.

## Architecture Boundaries

- All clients call the versioned Laravel REST API under `/api/v1`.
- Clients never connect directly to PostgreSQL, Redis, private storage, or secret provider APIs.
- Keep one modular monolith. Do not create microservices.
- Business rules live in domain actions/services, not controllers or UI components.
- Controllers validate transport input, authorize, invoke one use case, and return an API Resource.
- Models do not call external providers.
- External systems are accessed through interfaces and replaceable adapters.
- Critical multi-record changes use a PostgreSQL transaction.
- Noncritical side effects use an outbox event after commit.

## Fixed Technology

- Laravel 13 constrained as `^13.0`, PHP 8.4, Composer 2.
- PostgreSQL 16 with PostGIS, `pg_trgm`, and `pgcrypto`.
- Redis-compatible cache/queues and Laravel Horizon.
- Laravel Passport for approved OAuth2/JWT access and refresh behavior.
- Laravel Reverb for authorized real-time features.
- React 19, strict TypeScript, Vite 8, Tailwind CSS with semantic design tokens.
- Flutter and Dart for the Buyer app.
- OpenAPI 3.1 with generated TypeScript and Dart clients.
- Docker Compose for local infrastructure.
- GitHub Actions and Render for reference CI/CD and hosting.

Do not replace these without an approved Architecture Decision Record and user confirmation.

Apply Laravel minor and patch updates only after the full automated test and security gates pass. A future Laravel major-version change requires a new Architecture Decision Record and explicit user approval.

## Security Rules

- `.gitignore` must exist before any `.env` or credential file.
- Never commit `.env`, signing keys, service-account JSON, certificates, keystores, API keys, passwords, tokens, OTPs, or private provider payloads.
- Real credentials are entered by the user only in ignored environment files or protected cloud secret fields. Never ask the user to paste a secret into chat.
- `.env.example` contains required names and safe defaults only, never secret values.
- Keep Development, Staging, and Production credentials separate and non-reused.
- Use at least 32 random characters for caller-generated secrets.
- Never print, log, return, snapshot, or seed a secret.
- Do not put a backend secret in a `VITE_` variable or Flutter/mobile configuration.
- Passwords use Argon2id. OTPs and recovery codes are stored only as keyed/adaptive hashes as designed.
- Web tokens use `Secure`, `HttpOnly` cookies with CSRF protection; never localStorage.
- Mobile tokens use OS secure storage.
- Apply deny-by-default authorization on every protected request.
- Validate Xendit webhooks, provider identifiers, amount, currency, reference, state, and replay uniqueness.
- Use private object storage, content validation, malware-scan state, and authorized short-lived URLs.
- Logs must redact credentials, tokens, OTPs, payment details, and unnecessary personal data.
- Run a secret scan before accepting any phase.

## Data Rules

- Use UUIDv7 business identifiers and opaque API IDs.
- Store money as integer centavos; never binary floating point.
- Store timestamps in UTC and render business deadlines in Asia/Manila.
- Use `TIMESTAMPTZ`, foreign keys, checks, unique constraints, and purposeful indexes.
- Use PostGIS geography points and GiST indexes for location search.
- Published quotations, order snapshots, payment/refund events, compliance decisions, dispute decisions, and audit records are immutable.
- Corrections create new versions or compensating events.
- Never cascade-delete commercial, financial, compliance, dispute, or audit history.
- A migration must work from an empty database and on the current schema. Do not modify an already-deployed migration; add a new migration.

## Commerce Invariants

- One parent checkout creates one child order per Vendor.
- Keep order, payment, fulfillment, refund, and dispute states separate.
- Enforce transitions through one server-side transition service.
- Require `Idempotency-Key` for retry-sensitive mutations.
- Browser redirects never prove payment or refund success.
- Cancellation Refund and Dispute-Conclusion Refund are separate triggers and records.
- Cart placement does not reserve stock.
- `available_to_sell = quantity_on_hand - hard_reserved_quantity`.
- Quotation soft holds do not reduce available-to-sell or the auto-accept pool.
- Acceptance/reservation locks all affected rows in deterministic order and succeeds or fails for every line together.
- Quantity on hand is reduced only at delivery/pickup fulfillment.
- Auto-accept is Item-Based only, disabled by default, unavailable with NRPC, and governed by allotment plus unit/amount safeguards.
- NRPC is manual, disabled by default, Vendor-determined with a reason, part of the existing order value, disclosed and accepted before payment, and has no platform-wide numeric cap.
- Buyer cancellation is unavailable at Ready for Pickup and Out for Delivery; dispute and statutory remedies remain accessible.
- A Work Package may have many inquiries but only one selected Vendor outcome.
- Editing a published quotation creates a new immutable version and invalidates stale acceptance.

## Coding Standards

- PHP: strict types where practical, PSR-12, Laravel Pint, PHPStan/Larastan, typed DTOs, backed enums, Form Requests, Policies, API Resources, and explicit transaction boundaries.
- TypeScript: strict mode, no unjustified `any`, ESLint, formatter, schema validation at boundaries, accessible semantic components, and generated API client usage.
- Dart: sound null safety, immutable models, repository/service separation, centralized error mapping, secure storage abstraction, and `flutter analyze` clean.
- Name business concepts exactly as the workflows name them.
- Prefer clear code over premature abstraction. Extract only repeated, stable behavior.
- No commented-out production code, placeholder success responses, hidden feature bypasses, or TODOs on a required acceptance path.
- Use safe, structured errors with a correlation ID. Never expose stack traces to clients.

## API Contract

- Update `packages/api-contract/openapi.yaml` whenever request/response behavior changes.
- Regenerate TypeScript and Dart clients; do not hand-edit generated files.
- Responses use `{ data, meta, errors }`.
- Use safe canonical HTTP statuses and stable application error codes.
- Paginate every unbounded list.
- Use explicit resource/version fields for concurrency-sensitive updates.
- Add contract tests so implementation and OpenAPI cannot drift.

## UI and Accessibility

- Target WCAG 2.2 AA.
- Read the UI/UX planner before editing a Buyer, Vendor, or Admin interface.
- Treat the approved workflows as product truth and the Figma prototype as visual reference. Correct obsolete prototype content instead of reintroducing it.
- Use Inter and the canonical design tokens. `#F97316` is the central brand accent; use the approved deeper action token when white button text requires stronger contrast.
- Feature components use semantic token/component APIs, not unexplained raw hex colors or page-specific duplicate styles.
- Avoid nested-card-heavy layouts, generic dashboard collage, decorative gradients, bounce/elastic motion, gray text on colored surfaces, and unlabeled icon buttons.
- Use visible labels, semantic structure, keyboard focus, screen-reader names, sufficient contrast, reflow, and at least 24×24 CSS-pixel pointer targets.
- Target 44×44 px product controls on mobile and routine web actions unless the documented dense-control exception applies.
- Never communicate status using color alone.
- Every page must handle loading, empty, validation, unauthorized, offline/provider failure, retry, and success states as applicable.
- Maps require a synchronized accessible list/table alternative.
- Map Home uses zoom-aware clusters. Tier 2 labels show store name plus VPS/New Vendor; Tier 1 labels show store name plus Directory. Never label Google rating as VPS.
- A selected Tier 2 marker animates one decision route and opens a preview with an explicit View Store action. Tier 1 opens attributed Place Details only. Do not imply live GPS or animate a delivery vehicle.
- Project Vendor Map reuses the same map/route components with the Project site as origin and eligible Tier 2 candidates only.
- All motion must be purposeful, cancellable when state changes, and disabled/reduced under the platform reduced-motion setting.
- Countdown timers also display an exact date and time.
- Do not expose private staff contact details, exact Vendor inventory, exact Buyer coordinates in analytics, or private documents.

## Figma and Impeccable Workflow

- For a referenced Figma screen, retrieve the exact node's design context before implementation. Reuse hierarchy, spacing, assets, and composition while adapting behavior to the approved workflows and target stack.
- Do not paste generated React/Tailwind reference code into Flutter. Reimplement it through the Flutter design system and existing platform conventions.
- Do not use expiring Figma asset URLs in committed code. Export approved assets or use the intended dynamic data source.
- Run `/impeccable shape` before a new critical surface, then `critique`, `harden`, `animate`, `audit`, and `polish` as appropriate.
- Run deterministic Impeccable checks on both React portals and supported rendered previews. Use native Flutter semantics/widget/golden/device checks for the Buyer app.
- Inter is an explicit brand requirement; retain only the narrow documented `overused-font: Inter` detector exception. Do not disable unrelated design rules broadly.
- Impeccable findings are diagnostics and do not override workflows, security, authorization, provider policy, or accessibility tests.
- Keep approved shared Impeccable configuration/design/surface/critique artifacts tracked. Keep runtime screenshots, caches, sessions, previews, annotations, and local overrides ignored using the official ignore block.

## Testing and Definition of Done

For every change, add the smallest sufficient combination of:

- Unit tests for calculations and state rules.
- Feature/API tests for validation, authorization, idempotency, and failure paths.
- Database tests for constraints and transactions.
- Contract tests for OpenAPI/client compatibility.
- Component tests for interaction and accessibility.
- End-to-end tests for critical cross-client journeys.
- Provider adapter tests using fakes and sandbox environments.

Before reporting completion, run all relevant commands. Expected command families include:

```bash
cd services/api && vendor/bin/pint --test
cd services/api && vendor/bin/phpstan analyse
cd services/api && php artisan test
cd apps/vendor-web && npm run lint && npm run test -- --run && npm run build
cd apps/admin-web && npm run lint && npm run test -- --run && npm run build
cd apps/buyer-mobile && flutter analyze && flutter test
npx impeccable detect apps/vendor-web/src apps/admin-web/src
docker compose config
gitleaks git --staged
```

If a command is unavailable, explain why and provide the exact command the user must run. Do not claim a test passed unless it ran successfully.

## Required Final Report for Each Task

Report:

1. Outcome.
2. Files and migrations changed.
3. API contract changes.
4. Security/authorization decisions.
5. Tests and exact results.
6. Manual setup or API keys still required, naming variables only.
7. Known limitations or blocked gates.
8. Suggested conventional commit message.

Do not include secret values or repeat earlier commentary in the final report.
