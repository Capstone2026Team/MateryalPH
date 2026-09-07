**System Flow:**

---

### Backend (Laravel)

MateryalPH consists of three distinct application surfaces: a Flutter mobile application for Buyers, a React.js web portal for Vendors, and a separate React.js web portal for Administrators. All three applications use one versioned Laravel REST API and one PostgreSQL database. The project follows a modular monolithic architecture so that authentication, authorization, marketplace rules, orders, inventory, payments, disputes, compliance, notifications, and audit records are governed by one authoritative backend.

The term **Buyer** is used throughout the system for SME contractors, independent builders, and DIY builders. The term **Vendor Owner** refers to the main store account. A **Tier 1 Supplier** is an informational Google Places directory result, while a **Tier 2 Vendor** is a registered and verified MateryalPH marketplace participant.

**Approved capstone operating basis — 5 September 2026.** MateryalPH is an academic prototype, not an asserted BIR-registered operating business. All Xendit integrations use TEST credentials and test accounts. Every payment screen, financial report, certificate preview and billing statement carries **DEMO — No real funds or BIR filing**. A successful test webhook demonstrates provider integration; it does not prove real collection, statutory withholding, remittance to the BIR, or government approval. Physical-payment demonstrations record simulated cash handover to the Vendor. Seeded identities and tax documents are conspicuously fictional and must never be submitted to regulators or used to represent a real business as verified.

The approved commercial design uses a **2% Vendor-paid commission on completed materials value after discounts and excluding materials VAT**, billed monthly for Online, COD and In-Store orders. The fee is distinct from Buyer-paid processor charges and Vendor withholding. No subscription or listing charge applies. The System Workflow's controls `FIN-01` through `FIN-12` are authoritative for calculation and implementation; the other workflows apply them within their existing screens. The production withholding entity is **UNCONFIRMED**. Test scenarios may simulate either responsibility path, but no Admin toggle can establish a real legal allocation or enable live money movement.

**Development Tools and Technology Stack**

| **Layer / Tool** | **Technology** | **Purpose** |
| --- | --- | --- |
| Buyer Mobile Application | Flutter / Dart | Buyer registration, supplier discovery, Item-Based and Project-Based procurement, orders, messages, disputes, and account settings |
| Vendor Web Portal | React 19 + TypeScript + Vite 8 | Vendor onboarding, listings, inventory, orders, fulfillment, messages, compliance, staff, and analytics |
| Admin Web Portal | React 19 + TypeScript + Vite 8 | Verification, moderation, disputes, account enforcement, platform configuration, monitoring, and audit |
| Web Styling | Tailwind CSS | Responsive and accessible styling for Vendor and Admin portals |
| Mobile State Management | Provider or approved equivalent | Authentication, cart, map, order, and application state |
| Web State Management | Zustand or approved equivalent | Authentication, notifications, filters, and portal state |
| Backend API | Laravel 13 / PHP 8.4 | Shared REST API, business rules, queues, scheduling, PDF generation, and integrations |
| Authentication | Laravel Passport, Authorization Code + PKCE | Approved OAuth access-token architecture, revocation, secure web cookies and mobile secure storage; avoid a parallel independent JWT issuer |
| Database | PostgreSQL 16 with PostGIS | Relational records, geospatial queries, transactions, constraints, and audit references |
| Cache and Queue | Redis + Laravel Queues | Temporary cache, rate limits, asynchronous email, OCR, notification, and webhook processing |
| Queue Monitoring | Laravel Horizon | Authorized monitoring and retry of queued jobs |
| Maps | Google Maps SDKs and Places API (New) | Map display, Tier 1 supplier discovery, place details, and location selection |
| Routing and ETA | Google Routes API or currently supported Google routing service | Driving route, distance, and estimated travel time |
| Initial Distance Filter | PostGIS / Haversine calculation | Fast radius filtering before route calculations |
| Real-Time Messaging | Laravel Reverb | Real-time Buyer-to-Vendor communication for Tier 2 Vendors |
| Push Notifications | Firebase Cloud Messaging and Web Push | Time-sensitive Buyer and Vendor updates |
| Email | Laravel Mail through an approved provider | Verification, recovery, security, order, compliance, and administrative notifications |
| OCR and QR | Tesseract.js, Google ML Kit, and QR decoder | Assist PS/ICC evidence entry without replacing administrative or official verification |
| Payment Gateway | Xendit xenPlatform | Vendor sub-account onboarding, online payment routing, payment status, and supported refunds |
| File Storage | Cloudinary or an approved private object store | Product media, business documents, compliance evidence, fulfillment proof, and invoices |
| PDF Generation | Laravel DomPDF | Purchase Orders, payment confirmations, and budget reports |
| Monitoring | Sentry or approved equivalent | Application-error monitoring with personal-data filtering |

Technology versions and external-service capabilities must be confirmed against the actual deployment configuration before release. Test credentials and live credentials must be separated.

---

### System-Wide API Standards

- All endpoints are versioned under `/api/v1/`.
- Resource names are RESTful, consistent, and pluralized.
- JSON responses use the envelope `{ data, meta, errors }`.
- Dates and timestamps are stored in UTC and displayed using Asia/Manila time unless a user selects another display timezone.
- Money is stored as integer centavos or a fixed-precision decimal; binary floating-point values are prohibited for monetary calculations.
- `Idempotency-Key` is required for order submission, quotation publication and acceptance, payment creation, cancellation finalization, refund creation, inventory reservation, and other retry-sensitive mutations.
- Every request includes a correlation identifier for diagnostics and audit tracing.
- List endpoints are paginated. Cursor pagination is used for feeds and messages; page pagination may be used for administrative queues and reports.
- Validation errors identify the affected field without exposing secrets, internal stack traces, or account-existence information.
- Authorization is validated on every protected request. Frontend visibility never substitutes for server-side authorization.

**API Versioning Policy**

| **Rule** | **Behavior** |
| --- | --- |
| Breaking change | Requires a new API version |
| Additive change | Remains backward-compatible within the active version |
| Deprecated endpoint | Returns a documented deprecation and sunset notice |
| Unsupported application version | Returns HTTP 426 with a safe upgrade instruction |
| Duplicate idempotent request | Returns the original result rather than creating another transaction |

**Canonical HTTP Results**

| **Code** | **Use** |
| --- | --- |
| 200 / 201 | Successful read, update, or creation |
| 202 | Asynchronous request accepted |
| 400 | Invalid request format |
| 401 | Authentication required or invalid |
| 403 | Authenticated but not authorized |
| 404 | Resource unavailable to the requester |
| 409 | State or concurrency conflict |
| 422 | Field or business-rule validation failure |
| 429 | Rate limit reached |
| 503 | Required service temporarily unavailable |

---

### Security Layers

**Authentication and Session Management**

- React portals use short-lived access tokens and rotated refresh tokens delivered through `Secure`, `HttpOnly` cookies. An appropriate `SameSite` policy and CSRF protection are required. Authentication tokens must not be stored in browser local storage.
- Flutter uses short-lived bearer access tokens and rotated refresh tokens stored in platform secure storage. Each device session has a separately revocable identifier.
- Passwords are hashed using Argon2id or the current Laravel-recommended adaptive password hash. Passwords are never stored using reversible encryption.
- Google authentication uses the OpenID Connect Authorization Code flow with PKCE. The backend validates signature, issuer, audience, expiration, nonce, state, and the `email_verified` claim. The stable Google `sub` claim is used as the external identity key; email is not used as the permanent Google identifier.
- Email/password registration uses a six-digit, short-lived, single-use email OTP to verify email ownership. Google sign-up does not repeat email verification after a valid Google identity token is accepted.
- Email OTP is used for verification, recovery, and risk-based step-up checks. It is not represented as strong multifactor authentication.
- Authenticator-app TOTP is mandatory for Administrators and for privileged Vendor Owner or delegated Store Manager sessions. Recovery codes are issued once, stored hashed, and replaced after use or regeneration.
- Buyers and non-privileged Vendor Staff receive step-up verification for a new device, suspicious activity, account recovery, or sensitive credential change rather than an email OTP after every routine login.
- Sensitive actions require recent authentication. These include ownership, staff delegation, payout settings, legal-business information, administrator roles, security factors, and account deletion.
- Sessions are revoked after password reset, email change, security-factor replacement, suspension, ban, deactivation, or a user-selected “sign out of all devices” action.

**Authorization**

The backend applies deny-by-default, least-privilege access control. Role and organization membership are evaluated on every request. Resource ownership is validated so that guessed identifiers cannot expose another Buyer, Vendor, or case. Privileged authorization changes are audit-logged and tested through automated authorization tests.

**Rate Limiting and Abuse Protection**

| **Route group** | **Default control** |
| --- | --- |
| Login | Five failed attempts per account and IP within 15 minutes, followed by temporary throttling |
| Registration | Five attempts per IP per hour, with device and risk controls |
| Email OTP | Resend cooldown, expiration, attempt limit, and one active code per purpose |
| Authenticated API | Sixty requests per minute per user unless a feature-specific limit applies |
| Unauthenticated API | Ten requests per minute per IP unless a public-service limit applies |
| Payment and refund | Three creation attempts per minute per user, plus idempotency |
| Messages and file uploads | Per-user and per-organization abuse limits |

Bot detection such as reCAPTCHA may be used on registration, suspicious login, password recovery, dispute filing, and other abuse-prone actions. It must be risk-based and must offer an accessible fallback. It must not be the only protection.

**Application and Data Security**

- All production traffic uses HTTPS/TLS.
- Eloquent parameter binding or equivalent prepared statements are required.
- React output escaping, Content Security Policy, secure headers, and file-content validation reduce XSS and upload risks.
- Webhook signatures or verification tokens are validated using constant-time comparison. Webhook events are processed idempotently and recorded before business-state changes.
- Secrets are stored in protected environment or secret-management configuration. Xendit keys, webhook tokens, Google keys, and mail credentials are never editable or visible in the Admin Portal.
- Business and compliance documents use private storage and expiring signed access URLs.
- Uploaded file type is determined from file content as well as extension. Malware scanning is required before administrative or user access in production.
- Logs exclude passwords, OTP values, full payment credentials, authentication tokens, and unnecessary personal information.

---

**Canonical State and Transaction Model**

Order, payment, fulfillment, refund, and dispute states are stored separately. A status change must pass a server-side state-transition rule and create an immutable history record.

**Order Lifecycle**

| **Status** | **Meaning** |
| --- | --- |
| `AWAITING_VENDOR_CONFIRMATION` | Buyer submitted an order request; Vendor must confirm, revise, or reject within 24 hours |
| `AWAITING_BUYER_APPROVAL` | Vendor proposed a partial quantity or other permitted revision |
| `AWAITING_NRPC_ACCEPTANCE` | Vendor proposed a Non-Recoverable Preparation Cost and the Buyer must accept its amount, reason, and Terms before payment or preparation |
| `AWAITING_PAYMENT` | Vendor confirmed stock, price snapshot, delivery arrangement, and expected fulfillment date |
| `CONFIRMED` | Online payment succeeded or an approved physical-payment method was selected |
| `PROCESSING` | Vendor is preparing the confirmed order |
| `READY_FOR_PICKUP` | Self-pickup order is ready |
| `OUT_FOR_DELIVERY` | Site-delivery order has been dispatched |
| `DELIVERED` / `PICKED_UP` | Vendor recorded fulfillment proof; Buyer confirmation is pending |
| `COMPLETED` | Buyer confirmed receipt or the two-day auto-confirmation rule completed without an open dispute |
| `CANCELLATION_REQUESTED` | Buyer submitted a permitted cancellation reason and the outcome is pending |
| `DECLINED` / `EXPIRED` / `CANCELLED` | Terminal state before fulfillment |
| `DISPUTED` | Active dispute pauses automatic completion and affected refund closure |

**Payment Lifecycle**

Payment and refund status are separate. Payment states are `NOT_REQUIRED`, `PENDING`, `PAID`, `FAILED`, and `EXPIRED`. Refund states are `NOT_REQUESTED`, `REFUND_PENDING`, `PARTIALLY_REFUNDED`, `REFUNDED`, and `REFUND_FAILED`. A successful browser redirect is not proof of payment; only a verified Xendit webhook or authoritative API reconciliation may set `PAID`. A failed or expired payment for which no money was captured does not create a refund. If reconciliation proves that money was captured despite a failed application flow, the system creates an idempotent compensating refund.

Every online payment record has one purpose: `FULL_ORDER_PAYMENT`, `NRPC_ASSURANCE_PAYMENT`, `ORDER_BALANCE_PAYMENT`, or `PLATFORM_FEE_PAYMENT`. The last purpose pays a Vendor billing statement to the platform test account and is never a Buyer order payment. Cash on Delivery and In-Store Payment balances are recorded as physical-payment obligations rather than false online-payment successes. Every record also carries `environment=TEST` and an independent evidence origin: `XENDIT_TEST`, `SIMULATED`, or, only in a separately implemented production release, `LIVE_PROVIDER`.

For a multi-vendor cart, the system creates one parent checkout and one child order per Vendor. Each child order has its own confirmation, payment allocation, delivery fee, status, refund, and audit history. The parent status is derived from its children and never replaces them.

**Inventory Transaction Rules**

- Cart placement does not reserve inventory.
- `quantity_on_hand` is physical stock. `hard_reserved_quantity` is accepted but unfulfilled stock. `available_to_sell = quantity_on_hand − hard_reserved_quantity`. `soft_held_quantity` is reported separately and does not reduce `available_to_sell`.
- Manual Vendor confirmation, quotation acceptance, or eligible Item-Based auto-accept reserves the approved quantity using one database transaction and row-level concurrency control. The transaction validates every line before changing any line; multi-line acceptance is all-or-nothing.
- Rejection, payment expiration, cancellation, or an approved quantity reduction releases the affected reservation.
- Delivery or pickup atomically reduces `quantity_on_hand` and `hard_reserved_quantity` and creates the fulfilled/sold movement. Reservation is not incorrectly recorded as physical consumption.
- Buyers see only `In Stock`, `Limited Stock`, or `Out of Stock`; authorized Vendor users may see quantity on hand, reserved quantity, and available quantity.

**Item-Based Auto-Accept**

Auto-accept is optional, disabled by default, and available only for Item-Based procurement without NRPC. An authorized Vendor configures each SKU or variant with an integer stock allotment and may independently set a maximum accepted unit count and maximum order amount. An order is eligible only when every line belongs to the same Vendor, every variant has active allotment, the resulting order remains within all configured safeguards, the listing and Vendor remain active, and the requested fulfillment method is supported.

The backend locks the affected inventory and auto-accept configuration rows, rechecks eligibility, creates the accepted commercial snapshot, creates hard reservations, and reduces the remaining auto-accept allotments in one transaction. For Online Payment the order enters `AWAITING_PAYMENT`; for COD or In-Store Payment without NRPC it enters `CONFIRMED`. A failed check makes no partial change and routes the complete Vendor child order to manual review. `quantity_on_hand` is not reduced until fulfillment. When any required allotment reaches zero, auto-accept for that SKU or variant pauses immediately and the Vendor is notified. Inventory replenishment or reservation release may restore available stock but never clears the paused flag; resumption requires an explicit authorized Vendor action.

An auto-accepted online order has a 45-minute payment expiry displayed as an exact date/time and countdown. Expiry releases the hard reservation. Abuse controls limit repeated unpaid auto-accepted orders per Buyer, device, and Vendor without making an adverse account decision solely from automation.

**Core Traceability Records**

| **Record** | **Minimum implementation fields** |
| --- | --- |
| `quotations` | ID, conversation, Buyer, Vendor, `ITEM_BASED` or `PROJECT_BASED`, source product/cart/Work Package, current version, state, accepted order, created and updated timestamps |
| `quotation_versions` | Immutable version number, creator and role, published time, expiry, superseded version, fulfillment and payment terms, totals, NRPC, and content hash |
| `quotation_lines` | Version, source line, proposed product/variant, description/specification, unit, quantity, unit price, subtotal, substitution marker, and compliance reference |
| `quotation_changes` | Version, field path, original value, proposed value, plain-language label, actor, and timestamp |
| `inventory_holds` | SKU/variant, quotation or order, `SOFT` or `HARD`, quantity, state, source, expiry, release reason, and timestamps |
| `auto_accept_policies` | Vendor, SKU/variant, enabled/paused state, remaining allotment, unit cap, amount cap, policy version, editor, and timestamps |
| `nrpc_records` | Order/quotation version, amount, reason, affected lines, Vendor actor, Terms version, Buyer acceptance, Buyer flag, evidence, and decision references |
| `payments` | Purpose, order, Vendor sub-account, amount, fee, method/channel, provider identifiers, idempotency key, expiry, state, and verified events |
| `refunds` | ORDER target with `CANCELLATION`, `DISPUTE_CONCLUSION`, or `TECHNICAL_COMPENSATION` trigger; alternatively PLATFORM_FEE target with `FEE_CREDIT` and approved fee adjustment. Original payment, order or statement as applicable, Case ID when applicable, amount, provider reference, idempotency key, state and events are required according to target |
| `geographic_dimensions` | PSGC version, code, name, level, parent code, boundary source/version, effective dates, and active state |

Immutable commercial and audit records are never physically deleted through the application. A withdrawn quotation or cancelled order retains its historical record and uses state plus retention controls.

---

**Geolocation Map UI**

Location permission is optional. When permission is granted, the Buyer may center the map on the current device location. When permission is denied or unavailable, all essential functions remain available through manual address entry or map-pin placement. The location used for ranking is:

- Project site for Project-Based Procurement.
- Selected project site for an Item-Based order linked to a project.
- Selected delivery or pickup reference location for a regular Item-Based order.
- Current or manually selected location for general browsing.

Philippine addresses store latitude/longitude and the best resolved versioned PSGC identifiers for region, province or independent/highly urbanized city, and city or municipality. Coordinates remain authoritative for radius calculations; PSGC codes support administrative aggregation and do not replace the actual order or Project-site point. Geographic-master changes are imported through a versioned job so historical facts retain their original code and reporting can apply a documented current-boundary remap.

The default radius is 5 km. Suggested radius controls are `5`, `10`, `20`, `30`, `40`, and `50 km`, with optional manual adjustment up to 50 km. The system must ask before expanding the selected radius.

### Smart Radius Expansion Logic

| **Condition** | **System Action** |
| --- | --- |
| Fewer than three eligible Tier 2 Vendors | Offer the next radius value without changing the current selection automatically |
| Buyer accepts expansion | Re-run geospatial filters and ranking within the newly selected radius |
| Fifty-kilometer limit reached | Explain that no further platform expansion is available and offer Tier 1 references where available |
| Location permission denied | Continue through manual address or map-pin selection |

Map markers, radius boundaries, and badges must not rely on color alone. Every marker has a text label or accessible detail card, and a list view provides an equivalent alternative to the map.

### Vendor Map Badges

Tier 2 Vendors may display earned system badges. **Favorite Supplier** is a Buyer-controlled relationship and is never presented as the system-awarded **Trusted Supplier** badge.

| **Badge** | **Canonical trigger** |
| --- | --- |
| Fast Responder | CRR at least 85%, with at least 10 eligible inquiries during the trailing 30 days |
| On-Time | FRR at least 95%, with at least 10 fulfilled orders during the trailing 90 days |
| Most Ordered | Top 10% by completed-order count within the same canonical category and Vendor registered province, with at least 20 completed orders during the trailing 90 days |
| Highly Rated | VCS at least 4.50, with at least 10 eligible Vendor ratings during the trailing 90 days |
| High-Quality Materials | MQS at least 4.60, with at least 10 eligible product ratings during the trailing 90 days |
| Trusted Supplier | Verified for at least 90 days; VCS and OHS at least 4.50; at least 25 completed orders; no active serious compliance violation or unresolved severe dispute |
| Best Price | Lowest active comparable unit price for the same product, variant, and unit within the selected radius; product must be available |

---

## HYBRID TWO-TIER VENDOR POPULATION

### Model Overview

| **Tier** | **Source** | **Feature Access** | **Map Presentation** |
| --- | --- | --- | --- |
| Tier 1 Supplier | Google Places API result | Public place details, public contact, call, directions, and report action only | Informational Directory Supplier marker |
| Tier 2 Vendor | MateryalPH-verified Vendor | Storefront, listings, inventory, cart, orders, payment, messaging, projects, reviews, and disputes | Verified Vendor marker and earned badges |

Tier 1 Suppliers cannot receive MateryalPH orders, payments, reviews, messages, or project awards. A Tier 1 Supplier may claim its listing and register. After verification, the Tier 1 marker is suppressed and replaced by the Tier 2 storefront.

Google Places data must be displayed with required Google and third-party attribution. Google content may not be combined with a non-Google map where prohibited. Place IDs and other fields may be stored or cached only as allowed by the current Google Maps Platform terms. The operational refresh target is seven days for permitted cached content, but a shorter contractual limit always prevails.

### Five-Layer Algorithmic Sanitization (Tier 1)

**Layer 1 — Query and Field Filtering**

The system uses Places API (New) with construction-relevant place types or text queries and explicit field masks. Only required fields are requested. Closed businesses and results without a usable name or location are excluded. API response limits are treated as integration configuration rather than hardcoded guarantees.

**Layer 2 — Duplicate Detection**

The system first compares the Google Place ID. Where no shared Place ID exists, nearby results with normalized similar names may be flagged for review. Automated proximity matching must not merge distinct branches without sufficient evidence.

**Layer 3 — Data-Quality Screening**

Incomplete or apparently inactive results may be deprioritized, but the system must not represent Google reviews as MateryalPH-verified transactions. The detail panel identifies the source as Google and uses “if available” for ratings, reviews, photos, hours, website, telephone, and descriptive information.

**Layer 4 — Category Validation and Tier Replacement**

Construction-relevant types and keywords are allowed. A verified Tier 2 Vendor linked to the same Place ID suppresses the Tier 1 record. The verified MateryalPH storefront becomes authoritative for marketplace inventory and ordering.

**Layer 5 — Refresh, Reporting, and Availability**

| **Event** | **System Behavior** |
| --- | --- |
| Permitted cache remains fresh | Serve it with its source and attribution |
| Cache requires refresh | Re-query only required fields and update permitted values |
| Buyer reports inaccurate information | Record the report, hide clearly unsafe data where necessary, and request a targeted refresh |
| Repeated credible reports | Temporarily suppress the Tier 1 result pending review |
| Google service unavailable | Display permitted cached results and allow manual address/search fallback; do not fabricate place information |

### Grid-Based Multi-Point Search for Radius Expansion

When the Buyer expands the radius, the backend may divide the newly covered geographic area into bounded search cells to reduce coverage bias and control API cost. Results are merged by Place ID, filtered by the exact Buyer-selected radius, sanitized, and attributed. Grid searching improves coverage but is not described as a complete census of all suppliers. Requests must comply with current Google quotas, field-mask requirements, paging rules, caching terms, and billing configuration.

### Place Details API — Lazy Loading

Place Details is called only when a Buyer opens a Tier 1 detail panel or when a targeted refresh is required. The system requests only fields needed for that screen. Available details may include business name, address, Google rating and reviews, photos, opening hours, website, public telephone number, and descriptive information. Each review or photo preserves its required author attribution. The screen provides Call, Directions, Report Incorrect Information, and Claim This Business actions where applicable.

---

**In-App Messaging System**

Real-time messaging through Laravel Reverb is available only between Buyers and Tier 2 Vendors. A conversation may originate from a product, Vendor profile, order, or Project-Based comparison. Product or order context is attached as a structured reference rather than copied into editable chat text.

Chat may be used for questions, stock clarification, substitutions, coordination, and the formal Order-from-Chat quotation engine. Ordinary text messages never change an order price, system-compiled estimate, delivery fee, Purchase Order, or payment amount. A commercial change is effective only through a published, versioned quotation or revised-order action that the Buyer explicitly accepts before payment.

Buyer-facing conversation identity displays the store logo and name together with the current handler's avatar, display name, and role. Staff personal email, private telephone number, and authentication identifier remain hidden. Transfers preserve every sender and handler in the conversation history.

**Order-from-Chat Quotation Engine**

The same backend quotation engine supports `ITEM_BASED` and `PROJECT_BASED` contexts. Shared services handle versioning, deadlines, reminders, soft holds, hard reservations, vehicle and trip computation, totals, Buyer decisions, notifications, and audit events. The procurement-context flag selects the permitted source data and fields; it does not create a second implementation.

For Item-Based inquiry, the structured reference contains the selected products or cart lines. For Project-Based inquiry, the Buyer may open a separate conversation with each Vendor shown in the system-compiled result list. Each conversation receives:

1. A locked, immutable Work Package reference representing the Buyer's original requirements.
2. A Vendor-editable working duplicate used to propose a quotation.

The locked reference is never overwritten. The editable duplicate may propose product matches, substitutions, quantities, units, unit prices, fulfillment method, delivery details, expected date, payment method, and NRPC. Every changed field stores its original value, proposed value, actor, and timestamp. Before acceptance, the Buyer receives a plain-language change summary covering additions, removals, substitutions, specification changes, quantity changes, unit-price changes, delivery changes, timing, payment method, NRPC, and total—not only the final price.

A quotation contains immutable versions and uses `DRAFT`, `PUBLISHED`, `VIEWED`, `COUNTERED`, `STOCK_REVALIDATION_REQUIRED`, `ACCEPTED`, `REJECTED`, `EXPIRED`, or `WITHDRAWN`. Publishing sets a Buyer-response deadline. The default is 24 hours; the Vendor may select 1–72 hours. An edit to a published quotation creates and publishes a new version, invalidates acceptance of every older version, resets the deadline from the new publication time, and notifies the Buyer. The UI displays the exact Asia/Manila expiry and a live countdown. A reminder is sent four hours before expiry when the deadline is at least eight hours, or 30 minutes before expiry when it is shorter.

The Buyer may accept the current version, reject it, or submit a counter-offer. A counter-offer records requested changes, ends the current Buyer-response deadline, releases its soft holds, and gives the Vendor 24 hours to revise and republish. A Vendor may use **Delete Quotation** only before acceptance; the backend implements it as `WITHDRAWN` rather than physical deletion so the audit record survives. Messages remain available according to retention policy.

Publishing creates a soft hold for planning visibility. A soft hold does not reduce sellable stock or the Item-Based auto-accept pool. Acceptance therefore performs an atomic availability check across all lines. If sufficient stock remains, the transaction creates hard reservations and the order snapshot. If any line is insufficient, no line is reserved, the Buyer is not charged, and the quotation becomes `STOCK_REVALIDATION_REQUIRED` until the Vendor republishes a valid version. Rejection, counter-offer, expiry, or withdrawal releases soft holds immediately.

For Project-Based procurement, multiple Vendors may independently prepare quotations, but one Work Package may accept only one Vendor quotation. Accepting one version atomically assigns the Work Package to that Vendor and expires other active quotations for the same Work Package; their conversation histories remain readable. The system-compiled estimates remain comparison baselines and are not represented as Vendor-authored quotations.

Every quotation event records quotation and version identifiers, context type, conversation, Buyer, Vendor organization, actor and role, before/after values, publication and expiry times, view event, Buyer decision, inventory result, related order, correlation identifier, and timestamp. Read access to this history follows role and organization scope.

---

**In-App Payment System**

Every Tier 2 Vendor must complete the environment-appropriate Xendit xenPlatform onboarding checklist before marketplace activation. Test readiness is visibly distinct from production KYC and tax registration. Online Buyer payments are created for the applicable Vendor test sub-account. Vendor balances and withdrawals remain with the applicable Xendit account and dashboard; MateryalPH has no internal wallet or escrow. Commission is assessed under FIN-03 and billed separately each month, without a commission split from Buyer payments in this capstone release.

The Buyer confirms the order only after the Vendor confirms inventory, permitted revisions, expected fulfillment date, delivery vehicle or trip count, final total, and any NRPC. For online payment, the checkout creates the payment request and waits for a verified Xendit event. For Cash on Delivery or In-Store Payment without NRPC, the order records the selected physical-payment method without creating a Xendit payment. When NRPC applies to a physical-payment order, the system first collects the accepted NRPC amount online as an assurance payment and credits it against the later physical-payment balance.

The Buyer pays the disclosed online payment-processing fee. The interface labels it **Payment Processing Fee**, not “Xendit deduction,” and displays the materials subtotal, delivery fee, processing fee, and total before confirmation. The system applies no markup to the actual configured fee. Passing the fee to the Buyer must be permitted by the active Xendit agreement and applicable Philippine law before production use.

Enabled online channels are drawn from the actual Xendit environment and may include GCash, Maya, GrabPay, QR payments, and supported over-the-counter channels. Each channel stores its payment limits, expiry, settlement behavior, and refund capability. A channel without native refund support must have a documented Vendor-managed refund method before it is enabled; otherwise it remains disabled.

Refunds are created through a supported Xendit refund operation for the relevant sub-account where available and must return to the original payment method. MateryalPH records the trigger, request, Xendit identifier, amount, initiator, reason, state, and verified webhook results. A successful refund webhook means the request was processed and forwarded through the payment rail; the Buyer UI must not claim that funds have already appeared and must display the channel-dependent expected arrival information.

Refund initiation has two independent business triggers:

1. **Cancellation Refund.** When cancellation of an already-paid order becomes final, the backend automatically calculates the refundable amount and submits one idempotent refund request. Vendor-caused cancellation returns every Buyer-paid order amount, including NRPC. Buyer-caused cancellation during `PROCESSING` may retain only the accepted, applicable NRPC and any separately disclosed processor treatment permitted by law. Cancellation is not available after `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`; statutory remedies and dispute reporting remain available.
2. **Dispute-Conclusion Refund.** A dispute remains separate from refund state. If the final, unappealed or immediately enforceable dispute outcome awards a full or partial refund, the backend submits the corresponding idempotent refund request and links it to the Case ID and decision. Filing the dispute alone does not initiate a refund.

Administrators may decide a dispute outcome but do not receive, hold, or manually disburse money. A failed or unsupported refund is placed in an exception queue and follows the disclosed, contractually approved fallback. Payment-processing fees may be nonreturnable to the Vendor under provider terms; Buyer-facing treatment follows the disclosed cancellation and fault rules.

**FIN-01 — Legal basis and responsibility assignment.** RR No. 16-2023 established merchant creditable withholding at 1% of half of qualifying gross remittance. RR No. 5-2025 now expresses the rate as **0.5% of gross remittance**; compute `G × 0.005`, without another division by two. It is a Vendor income-tax credit, not revenue of MateryalPH or an extra Buyer tax. The original regulation excludes sales returns/discounts, separately billed shipping/delivery, VAT, and qualifying consideration for platform use from its defined base. These legal facts are separate from the prototype's implementation choices below. [RR No. 16-2023](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2016-2023%203.pdf), [RR No. 5-2025](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%205-2025.pdf)

The account-specific withholding arrangement is unknown. RMC No. 8-2024 assigns responsibility to the final controlling facility in its multi-facility example; Xendit likewise requires account-specific settlement confirmation. Implement one responsibility assignment per covered remittance, with entity, legal name/TIN, capacity, channel, effective period, approving reviewer and evidence reference. `UNCONFIRMED` blocks live payment/settlement activation. `DEMO_PLATFORM_WITHHOLDER` is the default teaching scenario; `DEMO_PROVIDER_WITHHOLDER` is an explicit alternate fixture. Neither is a statement that Xendit actually withholds in TEST. Do not deduct twice for the same remittance. Distinct obligations, including card-company withholding and withholding on service payments, require separate tax records and must not be erased as duplicates. [RMC No. 8-2024](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%208-2024%20(1).pdf), [Xendit guidance](https://docs.xendit.co/docs/withholding-tax-on-gross-remittances-ph)

| **Party** | **Operational responsibility** | **Prototype representation** |
| --- | --- | --- |
| MateryalPH operator | Vendor onboarding checks, tax/fee records, its own service-income accounting and invoicing; withholding/filing when legally assigned | Registration remains unconfirmed; show simulation and production prerequisites |
| Assigned withholding agent | Deduction, remittance, returns, payee reports, and Form 2307 for its own withholding | Simulated ledger/export or reconciled provider evidence; never fabricate BIR receipt |
| Vendor | Accurate tax information, sales invoices, own income and business-tax returns, supported credit claims | VAT/non-VAT fixtures and external invoice-upload workflow |
| Authorized finance reviewer | Review calculations, reconcile evidence, prepare filing package and record actual submission evidence in a future live deployment | Super Admin with the named finance permissions; distinct preparer/reviewer identities |
| Buyer | Pay agreed commercial amount; supply invoice details if needed | No marketplace withholding added to checkout; business-Buyer withholding, if applicable, is a separate review case |

**FIN-02 — Amount contract and tax classification.** Use server-side decimal arithmetic and integer-centavo storage. `money(x)` rounds nonnegative PHP amounts half-up to two decimals. Compute reversals from the original rounded values; never negate and reround a reconstructed total. Every amount snapshot records currency, calculation version, line IDs, source quantities/prices, discounts, tax-profile version, tax category, rounding allocation and accepted quotation version. These are implementation rules, not independent BIR approvals.

Prices displayed to Buyers are amounts payable inclusive of any applicable Vendor VAT. Each line has `VAT_12`, `VAT_ZERO`, `VAT_EXEMPT`, or `NON_VAT`; zero-rated and exempt are different classifications and require supporting basis. A VAT-registered Vendor is not automatically entitled to mark every line taxable, exempt, or zero-rated. For a `VAT_12` line after discount with payable amount `L`, included VAT is `money(L × 12 / 112)` and exclusive value is `L − VAT`. Other categories have zero included VAT but retain their distinct legal classification. Unknown registration/category blocks publication of a payable quotation until corrected. Staff cannot infer VAT registration from sales value or a checkbox alone. Official invoicing remains external under FIN-09. [BIR VAT guidance](https://bir-cdn.bir.gov.ph/BIR/pdf/2550Q%20guidelines%20April%202024_final.pdf)

`M` is the sum of discounted payable material lines; `V` is their included VAT; `E = M − V`; `D` is the separately billed delivery amount payable, including any delivery VAT recorded separately; `F` is the disclosed Buyer processing fee for that payment; `N` is accepted NRPC allocated only to its affected material lines. Allocate order discounts proportionally to eligible lines by largest remainder in centavos, ties by stable line ID, before tax calculation. A refund consumes the original line allocation, so discounts and VAT cannot be deducted twice. Delivery VAT is not included in `V` because all of `D` is excluded separately in FIN-05.

| **Payment case** | **Buyer amounts** | **Withholding event scope** |
| --- | --- | --- |
| Full Online | Commercial order `M + D`; pay `M + D + F` | Assess covered remittance from the successful collection, not the entire cart across Vendors |
| COD / In-Store, no NRPC | Pay `M + D` directly to Vendor; no online processing fee | No platform merchant-remittance event for direct cash |
| COD / In-Store with NRPC | Pay `N + F` online now; pay `M + D − N` physically later | Assess only the online portion allocated to affected materials |
| Approved later online balance | Pay uncollected commercial balance plus only that new attempt's disclosed fee | Assess new collection only; exclude previously assessed principal |
| Vendor monthly commission bill | Vendor pays statement under `PLATFORM_FEE_PAYMENT` | Separate platform service receipt; do not classify it as another remittance to that Vendor |

NRPC is neither a surcharge nor a second sale. Its tax allocation follows the selected affected material lines; `0 < N ≤ eligible prepared-material subtotal` is an integrity limit within the accepted price, not a platform-wide percentage/peso cap. The fee paid on an NRPC assurance transaction is not credited as material principal. For example, paying `N=1,000` plus `F=20` reduces the physical balance by 1,000, not 1,020. Buyer consent covers every payable amount before collection.

Processing-fee computation uses a versioned channel quote, including who bears the fee, percentage/fixed components, tax components, payment limits and the provider's rounding basis. If a provider charges on the fee-inclusive payment itself, compute a server-side gross-up or request an authoritative fee quote so the disclosed `F` covers exactly the approved charge; do not naïvely multiply only the materials subtotal. Store the quoted charge and reconcile it to the reported deduction. A difference becomes a Vendor/platform reconciliation item and never an undisclosed post-payment Buyer charge. The FIN-06 fixture explicitly fixes `F=P`; that equality is not assumed for every real channel. In the test billing flow the platform absorbs its own commission-bill processing charge.

For mixed NRPC, require each selected affected line to carry a principal allocation whose sum is exactly `N` and whose amount does not exceed that line's unpaid payable material value. Allocate included VAT proportionally from the original line's VAT snapshot to that payment in centavos; assign rounding remainder to the final principal collection/refund so all allocations sum exactly to the original VAT. A later physical payment does not re-assess the already collected online portion. A retained preparation payment after cancellation is not automatically tax-exempt: its original tax record enters FIN-07 review even though no platform commission is earned.

**FIN-03 — Commission schedule and monthly collection.** The capstone business-model policy is `commission_rate=0.02` on `E_completed`, the completed, non-refunded materials value excluding included Vendor VAT. `commission_due = money(E_completed × 0.02)`. It applies to Item-Based, Project-Based, Online, COD and In-Store orders with no minimum, numeric cap, subscription or listing charge. There is no additional fee on delivery, Buyer processing charges, Vendor VAT, NRPC deposits, cancelled orders or retained cancellation NRPC. This supersedes earlier zero-commission wording. Two percent is a launch hypothesis, not a market-average claim, profit guarantee or rate mandated by law.

The policy is intended to give suppliers a simple cost proportional to completed sales while contributing toward infrastructure and support. Operating-cost review must separately model map/routing use, hosting, storage, support, refund losses and contracted Xendit activity/transfer fees; a low-volume month may remain unprofitable. Do not add an undisclosed surcharge to cover a shortfall. [Xendit fee categories](https://docs.xendit.co/docs/xenplatform-fees)

Fee assessment creates `ESTIMATED` at accepted order snapshot and `EARNED` at `COMPLETED`, keyed by order and fee-policy version. An unpaid physical sale still creates a fee receivable at completion; an active non-payment dispute sets a separate `dispute_hold=true` on that receivable until the outcome determines the completed sale value. No fee is earned on a merely paid, confirmed or dispatched order. Reopening an order does not earn a second fee. For partial refunds, recompute the target fee from remaining eligible exclusive value and credit `original fee − target fee`; the last full reversal consumes every remaining fee centavo.

At 00:05 Asia/Manila on the first day of each month, an idempotent job drafts a Vendor statement for the previous calendar month. Include unbilled EARNED entries and accepted adjustments; disputed entries remain identified separately and uncollectible until resolved. An authorized finance reviewer approves the draft by the third calendar day. The due date is the fifteenth, or twelve calendar days after issue if issued late. A statement records period, each source order, subtotal, adjustments, net amount, issue/due timestamps and policy version. Approval cannot edit earned source amounts; correct those through a referenced adjustment. No silent new price applies to accepted orders.

A positive issued statement is paid by the Vendor Owner through a Xendit TEST payment to the platform test account, purpose `PLATFORM_FEE_PAYMENT`, with a 45-minute attempt expiry. Expiry permits a new attempt and does not erase the receivable; webhook/API reconciliation must rule out a late successful earlier attempt before another charge is accepted. The platform absorbs processing charges on its own bill. There is no automatic debit of the Vendor account, automatic withdrawal, internal wallet, or commission split on Buyer payments in this release. If the test account cannot support the route, use an explicitly SIMULATED billing fixture, not invented API success. A future split-payment design needs a separate change review; Xendit does not automatically reverse splits when the original payment is refunded. [Xendit split-payment behavior](https://docs.xendit.co/docs/split-payments)

An overdue statement sends Owner notices on the due date and seven days later, then enters finance review. It does not cancel existing orders or block refunds, tax records or invoice access. A credit on an unpaid bill reduces the outstanding amount; a credit on a paid bill is separately refundable through the original fee payment where supported, with an audited payable exception otherwise. Do not invent a cash balance or silently consume an unrelated Buyer's payment. Negative bills are credit statements, never negative Xendit payment requests.

The quoted 2% is inclusive of any applicable VAT on MateryalPH's service. The default teaching profile is `DEMO_NONVAT`, not a claim that the real operator has obtained non-VAT registration. A separate `DEMO_VAT_12` scenario shows `fee_VAT = money(fee × 12 / 112)` and `fee_revenue = fee − fee_VAT`. Thus a 200 fee contains 21.43 VAT and 178.57 service value only in that VAT scenario. Non-VAT status does not mean income/business taxes are absent. Corporate/individual income taxes and applicable percentage tax are reviewed outside the order calculator. A Vendor required to withhold on the platform's service fee supplies a separately reviewed Form 2307/credit; never apply the merchant-remittance 0.5% to that service invoice automatically. Its applicable rate and ATC require the payer/service classification.

**FIN-04 — Vendor tax evidence and threshold engine.** RMC No. 8-2024 requires BIR registration evidence, prescribed declarations for threshold relief, and supporting documents for other relief. The 500,000 threshold aggregates relevant remittances across all marketplaces/DFSPs; it is not a separate allowance per storefront. Missing required declarations trigger withholding. The threshold-crossing remittance and subsequent remittances are covered. Annual declarations are due by the twentieth day of the first taxable-year month when claiming the relief. [BIR RMC No. 8-2024](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%208-2024%20(1).pdf)

Store `taxpayer_key` (validated Vendor taxpayer identity, not user ID), legal/trade name, TIN and branch code, individual/corporate class, BIR COR reference, VAT status, fiscal-year start/end, prior-year total, declaration year/receipt/effective period, claimed outside-platform amount and as-of date, reviewer, evidence, and applicable exemption/reduced-withholding authorization. Never assume that a Vendor's elected income-tax rate, such as 8%, is the remittance withholding rate. Demo fixtures use an internal synthetic taxpayer key and conspicuously sample documents. Verification in TEST never promotes evidence to LIVE.

At each assessable remittance, lock that taxpayer's yearly accumulator and resolve the effective evidence version. Relief applies only when the validated rule and declaration support it and the known cumulative amount including this remittance does not exceed 500,000. Missing/invalid evidence uses `SUBJECT_STANDARD`, not an exemption. A prior-year amount above the threshold preserves subject status into the new year until a valid subsequent relief basis is reviewed; January does not grant a fresh automatic allowance. A correction/declaration that may affect an earlier period creates an adjustment review; it never silently rewrites posted tax.

Track on-platform gross remittances before CWT using FIN-05; outside-platform evidence carries its own period and is not double-counted against previously declared totals. Where a declaration reports an all-platform total, store which part is already represented in the local accumulator; unresolved overlap goes to review. The system cannot independently see every other marketplace. A reported outside-platform threshold breach triggers subject status even if local activity is low. Crossing is sticky for the taxable year; a later refund or lower running total does not automatically restore relief. On 1 January for calendar-year fixtures, create a new accumulator but retain prior-year status/evidence logic. Fiscal-year fixtures use their recorded taxable-year boundary.

**FIN-05 — Remittance computation and settlement evidence.** The default separately billed commission policy means a monthly fee receivable is not subtracted from each Buyer remittance. For this release set `commission_deducted_in_remittance=0`; the separate fee payment remains a Vendor expense/service payment. Any future netted commission exclusion requires a verified remittance policy and evidence of that deduction. The exact provider deduction mapping remains a production validation dependency, not an assumption that the Xendit dashboard always computes the same base.

For each actual or simulated remittance group, perform these steps in order:

1. Resolve TEST/LIVE boundary, Vendor, taxpayer, currency, original successful collections, channel, settlement grouping and assigned withholding entity. A bank withdrawal is not a second merchant sale; retries and sub-account transfers do not recreate the underlying assessable collection.
2. Build `C`, the gross successful collected amount allocated to this remittance, including any separately charged Buyer processor fee. Discounted order amounts already reflect discounts. Build `R`, allocations of approved returns/refunds removed before this remittance, and `D_r`, the remaining separately billed delivery amount in this remittance. Build `V_r`, the remaining included material VAT allocated to this remittance. For NRPC use only its allocated material portion, never the full order's material VAT.
3. Build `P`, the evidenced qualifying platform/DFSP consideration removed from the same remittance and not already excluded in `R` or other components. In demo examples `P` equals the simulated provider charge including its configured applicable taxes, and matches Buyer fee `F`. Never subtract `F` again merely because it is displayed in checkout. Real provider fee/VAT treatment requires reconciled charge components; a receipt/deduction not fitting the validated policy becomes `BASE_REVIEW_REQUIRED`.
4. Compute `G = C − R − D_r − V_r − P`. The components are mutually exclusive; reject negative bases or allocations exceeding the source amount with `BASE_REVIEW_REQUIRED`, rather than silently clamping them. Processor charges that survive a fully reversed payment are handled as a separate Vendor/platform expense, not a negative merchant sale. For a cancelled/refunded payment before any merchant remittance, void the pending assessment and record no new merchant remittance.
5. Apply FIN-04 using the complete canonical remittance group, including this `G`, before evaluating threshold relief. A group cannot be arbitrarily split to avoid crossing. Save prior cumulative amount, this base, next amount, status, evidence, reason and effective rate. Standard `W = money(G × 0.005)`; approved threshold relief gives `W=0`; special relief uses only the evidenced applicable withholding treatment.
6. Compute expected Vendor remittance cash `C − R − P − W`. Delivery and included material VAT remain amounts payable to the Vendor even though excluded from the CWT base. The monthly commission is still unpaid separately and is not deducted again. Record the gross sale, cash movement, fee and CWT distinctly; neither net cash nor `G` replaces the sales amount in Vendor revenue records.
7. Post the assessment and threshold update once in a database transaction with an outbox event. Uniqueness is enforced on `(environment, taxpayer_key, remittance_group_id, obligation_type)`. Concurrent settlements for the same taxpayer serialize; retries return the original result. Do not hold a database lock while making a provider network call.
8. The demo adapter records `SIMULATED_WITHHELD` and simulated payable/receivable entries. The Xendit TEST payment remains evidence of the payment only. In the alternate provider fixture, import the simulated provider deduction once and compare expected versus reported amounts. A real provider-managed route would import actual deduction/certificate evidence; a real platform-managed route would need a separately validated deduction, funding, BIR payment and filing process before activation.
9. Reconcile original collection, provider fees, deductions, settlement reference, expected cash and reported cash to the centavo. Differences create `RECONCILIATION_EXCEPTION`; no unexplained tolerance write-off or second charge is allowed. An order can have a successful payment while its tax reconciliation is unresolved; do not turn that into a false payment failure or duplicate refund.

Payment-method names do not alone determine tax coverage. Direct Vendor cash in this approved design has no MateryalPH remittance. Cash collected by an agent for the platform and routed through it would be a different arrangement requiring assessment. Credit-card rails require their own withholding mapping: a provider's exclusion from its remittance-withholding program is not proof that the transaction has no withholding obligations at all. Tier 1 directory entries remain informational and cannot accept marketplace orders or payments.

**FIN-06 — Worked demo amounts and exact expected results.** All processor charges below are fictional test fixtures, not current Xendit prices. Each example assumes standard CWT eligibility unless relief is expressly stated. Commission is separately billed on completion. The examples do not claim that Xendit TEST deducted or remitted tax.

| **Scenario** | **Inputs and calculation** | **Expected result** |
| --- | --- | --- |
| Full online, non-VAT goods | `M=10,000; V=0; D=500; F=P=100; C=10,600; R=0` | `G=10,000; W=50; expected Vendor cash=10,450; completion fee=200` |
| Full online, VAT-inclusive goods | `M=11,200; V=1,200; D=500; F=P=100; C=11,800` | `E=10,000; G=10,000; W=50; expected Vendor cash=11,650; completion fee=200` |
| Valid threshold relief, exactly at limit | Prior `G=490,000`; next `G=10,000`; valid relief evidence | New cumulative 500,000; `W=0` on this remittance |
| Threshold crossing | Prior `G=499,000`; next `G=2,000` | New cumulative 501,000; `W=10` on all 2,000, not 5 on the excess 1,000 |
| Missing required declaration | First `G=2,000`, no evidenced other relief | `W=10`, despite local total being below 500,000 |
| Direct COD, non-VAT, no NRPC | `M=10,000; D=500` | Buyer pays Vendor 10,500; no platform CWT event; completion fee=200 |
| Mixed COD, non-VAT NRPC | `M=10,000; D=500; N=1,000; F=P=20` | Buyer pays online 1,020; physical balance 9,500; online `G=1,000; W=5`; expected online Vendor cash 995; one completion fee=200 |
| Vendor cancels paid NRPC order | Same mixed example, original payment succeeded | Automatic Cancellation Refund target 1,020; fee=0; prior `W=5` moves to tax-adjustment review, not a Buyer deduction |
| Partial materials refund after completion | Original `E=10,000`, fee=200; approved returned exclusive materials=2,000 | Remaining fee target=160; fee credit=40; Buyer refund follows original payable line amounts, including its VAT if any |
| VAT-registered platform fixture | Fee payable=200 | Included fee VAT=21.43; platform fee revenue=178.57; Buyer goods VAT is unchanged |

**FIN-07 — Cancellation, dispute, and financial correction.** Keep the two existing refund triggers separate. A final paid cancellation automatically queues `CANCELLATION`; only an enforceable concluded dispute award queues `DISPUTE_CONCLUSION`. A failed payment without capture queues neither. The refund target is the Buyer-paid refundable amount after lawful NRPC/processor treatment and prior successful or in-flight refund allocations. Vendor CWT, commission debt and provider settlement deductions never reduce that target. Partial refunds reverse original affected-line VAT/discount allocations, not current listing values.

For a mixed order, refund the online principal through its original payment source and handle any already paid cash portion as a separately evidenced Vendor cash reimbursement. No Refund API can reverse an uncollected physical balance or invent a refund of cash through an unrelated online payment. Record physical money as `PHYSICAL_PAYMENT_RECORDED`; cash reimbursement as `VENDOR_REIMBURSEMENT_PENDING` then `REIMBURSEMENT_CONFIRMED` after evidence and Buyer confirmation or authorized case review. These are separate from Xendit payment/refund success. Cancelling an unpaid physical obligation closes the obligation without a refund.

Cancellation finalization atomically writes the decision, one refund instruction, a commission cancellation/credit and a tax-adjustment review reference. An outbox worker immediately attempts the supported Refund API after commit. Insufficient Vendor test balance or unavailable refund capability produces a visible `REFUND_FAILED`/exception, Owner notice and authorized retry after funding is resolved; do not call this completed or ask the Buyer to pay again. Live activation requires an evidenced funding/recovery arrangement for Buyer entitlements, including withheld tax and nonreturnable provider fees. The system cannot guarantee cash arrival or BIR recovery from a successful application job.

Tax correction uses `ADJUSTMENT_REQUIRED → UNDER_REVIEW → APPROVED → POSTED` or `REJECTED`, linked to the original assessment, refund, tax period and certificate. Refund success never automatically reverses a filed tax return or creates a BIR refund. The responsible withholding agent/finance reviewer determines whether an unfiled accrual can be corrected or a filed return/certificate needs the legally appropriate amendment. The demo may illustrate an approved adjustment but marks it SIMULATED. Posted records are append-only; never silently reopen a closed period or reset threshold relief because a refund occurred.

For technical routing, refunds have target_type=ORDER for the existing Buyer refund triggers, or target_type=PLATFORM_FEE with trigger=FEE_CREDIT for an approved return of a previously paid platform fee under FIN-03. A PLATFORM_FEE refund references its original fee payment, statement and adjustment; it never becomes another Buyer refund or merchant-remittance event. An unpaid fee credit reduces receivable without requesting a refund. This target distinction implements the existing fee-credit policy and does not change Buyer cancellation/dispute rules.

**FIN-08 — Reports, certificates, and filing evidence.** RMO Nos. 18-2025 and 26-2025 replace obsolete marketplace codes with `WI820/WC820` for marketplace withholding and `WI830/WC830` for DFSP withholding; `WI` and `WC` follow the payee's individual/corporate status. Current code descriptions refer to gross remittance, not half of it. Store effective dates and obligation type so historical transactions keep their historical codes. [RMO No. 26-2025](https://bir-cdn.bir.gov.ph/BIR/pdf/RMO%20No.%2026-2025%20Digest.pdf)

Prepare a tax package by withholding entity and period, never a combined platform/DFSP return. Include the source remittance register, deductions, adjustments, selected ATCs, payee reconciliation, Form 2307 preview/data, 0619-E monthly support for the first two quarter months, 1601-EQ quarterly support, quarterly alphalist and annual 1604-E/alphalist support. Verify the applicable form version and format before external filing; a generic CSV is not automatically a BIR-valid submission. RMC No. 55-2026 reiterates alphalists as required return attachments and eSubmission: quarterly CWT alphalists are due by the last day of the following month; annual CWT alphalists by March 1 of the succeeding year. [BIR RMC No. 55-2026](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2055-2026.pdf)

The filing calendar is separate from a Vendor's fiscal-year threshold accumulator: CWT return/alphalist aggregation uses calendar months, calendar quarters and the applicable calendar-year return. Include zero-withholding/exempt payees where required in payee schedules, with the relief reason; absence of a deduction is not permission to omit the underlying covered payment. Form 2307 data uses monthly income/base amounts, quarterly totals, ATC and tax withheld for the same issuer/payee.

The standard demo calendar seeds 0619-E for the first two months of each quarter with the non-eFPS tenth-day-of-following-month baseline; 1601-EQ/QAP on the last day of the month following the calendar quarter; Form 2307 delivery within twenty days after quarter end or at payment when properly requested; and 1604-E/annual alphalist on March 1 of the following year. The configured demonstration uses the non-eFPS baseline only. A real eFPS filing schedule, holidays, extensions and superseding issuances require verified calendar overrides with a cited source and reviewer. Show the nominal deadline and any approved actual deadline separately, never silently shift a statutory date. [BIR RR No. 11-2018, filing and statements provisions](https://bir-cdn.bir.gov.ph/local/pdf/Digest%20RR%2011-2018.pdf)

The capstone creates only `DRAFT → REVIEWED → EXPORTED` packages and `SIMULATED_SUBMISSION_RECORDED` evidence for demonstration. `FILED`, `BIR_PAID` and valid issued certificate claims require authentic external evidence in a future live deployment. Capture form/version, reporting period, preparer/reviewer, export hash, totals, due-date source, filing channel, external acknowledgment and payment reference separately. A provider-issued certificate retains that provider as issuer; MateryalPH cannot sign it as the withholding agent. Certificate access is limited to the named Vendor and authorized finance reviewer.

Use Asia/Manila due dates and a versioned filing calendar. Monthly deadlines vary with filing channel and applicable rules; a finance reviewer must approve those dates against the current BIR calendar before a package is considered ready. Do not reuse the platform fee-billing deadline as a tax deadline. Show `DUE_DATE_REVIEW_REQUIRED` when the legal date has not been validated. Initial demo alerts are 15, 7 and 1 day before a known deadline and on overdue status. Missing certificates, rejected submissions and unreconciled amounts remain exception tasks; export alone does not close them.

**FIN-09 — Invoices and separate taxpayer duties.** Vendor invoicing remains the Vendor's responsibility through its registered invoicing process, with any required invoice issued when legally due; it does not wait for Buyer completion or a request. The three-business-day document-request target concerns providing a copy/correction and never extends the legal issuance deadline. MateryalPH may calculate transaction VAT arithmetic from validated inputs for checkout, withholding-base determination and reconciliation; this is not issuance of the Vendor's official invoice or computation of the Vendor's full tax return. The Vendor's invoice difference enters `INVOICE_RECONCILIATION_REQUIRED` and cannot silently change an accepted Buyer price. [BIR invoicing clarifications](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2077-2024.pdf)

The platform's monthly service bill is a separate document owed by the Vendor. Demo bill/certificate PDFs are watermarked and use a SAMPLE identifier, not fabricated official invoice numbers, signatures, registration or BIR acknowledgment. In a live deployment the platform must issue its own legally appropriate service invoice through its registered process. Vendor goods invoices, platform service invoices, processor invoices, payment confirmations and Form 2307 are different document types and must not share numbering or substitute for one another.

RR No. 11-2025 and RR No. 26-2025 distinguish electronic invoicing from electronic sales reporting. The extended December 31, 2026 issuance deadline covers specified groups, including small/medium/large e-commerce taxpayers; micro taxpayers are exempt under that e-commerce category, but other coverage categories still require review. A PDF upload alone does not demonstrate compliant structured electronic invoicing. Record taxpayer classification, invoicing method, applicable coverage, source/version, deadline and reviewer. Broad reporting obligations contingent on later regulations are not presented as an existing universal BIR API integration. [BIR RR No. 26-2025](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2026-2025%20Digest.pdf)

**FIN-10 — Implementation records and permissions.** Add these records to the existing shared database and audit service; do not build separate finance engines for Buyer, Vendor, Admin, Item-Based or Project-Based procurement.

| **Record / API resource under `/api/v1/`** | **Required fields / behavior** |
| --- | --- |
| `vendor-tax-profiles` and evidence versions | Vendor, taxpayer identity, registration/classification, fiscal year, declaration/exemption evidence, validity, reviewer, origin |
| `financial-snapshots` | Order/quotation version, exact line amounts, discount/VAT allocation, M/V/E/D/F/N, policy IDs, calculation hash |
| `remittance-assessments` | Environment, source collections, unique group, assigned entity, C/R/D_r/V_r/P/G/W, threshold before/after, evidence and reconciliation state |
| `tax-year-accumulators` | Environment, taxpayer and year unique key; local total, external declaration scope, breach flag and last locked event |
| `fee-assessments` / `fee-statements` | Unique source order/policy, earned target, credits, billing period, issue/due dates, outstanding amount and fee payment references |
| `physical-payment-records` | Order, remaining obligation, method, amount, Vendor recorder, time, evidence, Buyer acknowledgment, correction history |
| `tax-adjustments` / `tax-report-packages` | Original event/period, reason, before/after, preparer/reviewer, evidence, export hash, filing calendar/version |
| `tax-certificates` / `invoice-records` | Document type, real or sample issuer, payee, period/order/statement, number, amount, protected file, origin and verification state |
| `financial-ledger-entries` | Append-only balanced event lines; source, debit/credit accounts, currency, centavos, environment, reversal link, actor and timestamp |

Commands use POST/PATCH with backend policies, validation, idempotency and state checks; GET/read and export are scoped. Standard mutations include profile submission/review; assessment calculation/reconciliation; statement draft/approve/pay; refund and tax adjustment review; package prepare/review/export. No route submits a live BIR return or changes a payout destination in this release. Version conflict returns 409; invalid allocation returns 422; a provider outage returns a retryable pending/error result without posting success. Signed webhooks, append-only event storage, outbox delivery and reconciliation remain shared infrastructure.

Vendor Owner submits tax evidence, accepts the commission Terms and pays statements. Store Manager may view authorized store finance and prepare profile corrections, but Owner approval is required for legal tax declarations and fee payment. Existing staff order/invoice roles remain as defined; seeing a Buyer total does not grant access to Vendor certificates or platform fee accounts. Vendor Verification Staff review registration evidence; Super Admin receives explicit `finance.view`, `finance.review_tax`, `finance.approve_statements`, `finance.export` and `finance.record_external_evidence` permissions. Two different named users must prepare and approve tax overrides, adjustments and report packages, even in a demo with two test accounts. No role may override a missing live registration/responsibility gate.

Tax identifiers and evidence use private storage, least privilege, masked display and download auditing. Retention follows the approved legal-purpose schedule; do not invent a short deletion rule for open tax periods, disputes or legal holds. Test and live ledgers, object prefixes, credentials, queues and exports must be isolated. Keep secrets in environment-specific protected configuration, never in these reports, frontend bundles, fixtures or logs.

The implementation uses the following independent finance state fields. The service validates transitions; arbitrary status PATCH requests are rejected.

| **Record / field** | **Allowed states and transition guard** |
| --- | --- |
| Assessment `calculation_state` | `CALCULATED → POSTED`; invalid input is `BASE_REVIEW_REQUIRED`; an unposted cancelled collection may become `VOIDED`; posted values change only through linked adjustments |
| Assessment `deduction_evidence_state` | `UNCONFIRMED`, `SIMULATED_WITHHELD`, `PROVIDER_REPORTED`, `PLATFORM_EVIDENCED`; last two require corresponding issuer/evidence and cannot be inferred from payment success |
| Assessment `reconciliation_state` | `PENDING → RECONCILED` or `RECONCILIATION_EXCEPTION`; exception resolution appends evidence and reviewer action |
| Fee assessment | `ESTIMATED → EARNED`; `ESTIMATED → CANCELLED` if no completed sale; posted credits track `PARTIALLY_CREDITED` / `CREDITED`; a disputed line retains prior state and a separate dispute hold |
| Fee statement | `DRAFT → ISSUED → PARTIALLY_PAID → PAID`; full payment may skip PARTIALLY_PAID; `OVERDUE` is derived from unpaid due amount/date; only DRAFT may be VOIDED; later changes use credit/debit adjustments |
| Fee payment | Shared payment lifecycle, purpose `PLATFORM_FEE_PAYMENT`, statement allocation and environment required |
| Physical obligation | `UNPAID → PARTIALLY_RECORDED → PHYSICAL_PAYMENT_RECORDED`; terminal cancellation may release unpaid amount; corrections cannot exceed recorded collection |
| Physical remedy | `VENDOR_REIMBURSEMENT_PENDING → REIMBURSEMENT_CONFIRMED`; evidence and Buyer acknowledgment or authorized reasoned decision required |
| Tax adjustment | `ADJUSTMENT_REQUIRED → UNDER_REVIEW → APPROVED → POSTED`, or `REJECTED`; distinct reviewer and original record/period required |
| Tax package | `DRAFT → REVIEWED → EXPORTED`; demo evidence uses `SIMULATED_SUBMISSION_RECORDED`; no test transition to authentic FILED/BIR_PAID |

`financial-ledger-entries` are an operational reconciliation subledger, not a replacement for either taxpayer's registered books. Every posting batch must balance by currency and environment. Use `DEMO_FLOW` for simulated merchant money movement and `PLATFORM_FEE` for fee-account projection; never mix their accounts. Within DEMO_FLOW, simulated collection posts debit collection control / credit Vendor payable for `C`; the evidenced provider charge posts debit Vendor payable / credit provider-charge control for `P`; simulated CWT posts debit Vendor payable / credit CWT control for `W`; simulated remittance posts debit Vendor payable / credit collection control for `C−P−W` (prior refunds use their separately linked entries). This projection does not assert that MateryalPH owns or holds Vendor funds. For provider-withholding fixtures, record the same deduction event once under the provider's actor and evidence, never as an additional platform deduction.

Within PLATFORM_FEE, earning posts debit fee receivable / credit fee revenue and applicable output-VAT component. Statement issue groups existing receivables and creates no second revenue entry. A fee payment posts debit provider collection control / credit fee receivable for the allocated amount; its charge is debit platform processing expense / credit provider collection control. An approved fee credit reverses the original revenue/VAT allocation against receivable, or creates a refund payable if already paid. Return of the paid fee clears that payable through the original fee-payment route. Tax-control balance clearance in TEST is an explicitly simulated event; authentic BIR remittance would require external evidence. All reversals identify the original posting and cannot exceed its unreversed amount. A tested balance constraint and unique source-event key prevent drift and duplicate posting.

**FIN-11 — Reporting reconciliation and audit trace.** A transaction must be traceable as `order/quotation version → financial snapshot → payment or cash record → remittance assessment → deduction/settlement evidence → certificate/report package`, and separately `completion → fee assessment → statement → fee payment → platform service invoice reference`. A refund branches into the original payment, affected lines, commission adjustment and tax-review case. Each event stores actor/role, environment, timestamp, source version, correlation ID, before/after values and reason. Do not merge a payment status, order completion, withholding status, commission collection and BIR filing into one status.

Gross GMV remains confirmed material-plus-delivery commercial value before cancellations/refunds; Buyer processing fees are excluded. Net GMV reverses cancelled/refunded commercial value only once using unique line/event allocations. Vendor commission and CWT reduce cash or create expenses/credits, not GMV. Platform revenue displays earned fee value excluding its applicable fee VAT, with collected cash, receivables and credits separately. Buyer budgets include actual payable material VAT, delivery and Buyer processing costs, with NRPC principal counted once. Pending incomplete orders, completed/retained actual costs and paid cancelled amounts awaiting recovery are disjoint budget buckets; release unpaid cancellation obligations immediately and release refundable paid amounts only when reimbursement succeeds. Committed Spend is their sum, never an additional deduction alongside Actual Spend. Vendor tax, commission and monthly billing payments are not added to Buyer budgets. Demo analytics may include a dedicated labeled TEST dataset; it is never combined with live figures or presented as actual market demand.

**FIN-12 — Capstone demonstration and acceptance gate.** Demonstrate FIN-06 cases using resettable fixtures: valid relief, missing declaration, exact boundary, crossing, VAT/non-VAT materials, direct cash, mixed NRPC, completed fee billing, full cancellation and partial dispute refund. Also verify duplicate/out-of-order payment events; two concurrent remittances crossing the threshold; certificate issuer mismatch; prior-year subject status at year rollover; a cash record that must not create an online success; tax-profile edits that cannot rewrite history; failed fee payment; refund with insufficient funds; and evidence/finance access denial across Vendors. These are meaningful acceptance cases for financial and authorization risk.

The primary demo shows platform-withholding calculations as SIMULATED; the alternate provider case shows reconciliation without another deduction. Present sample report/certificate exports with watermarks and show that no BIR submission occurs. A release gate must fail if a test tax profile, fictional document, unconfirmed withholding entity, unapproved live fee treatment, unresolved refund funding, or test key is used to request live activation. A successful capstone demonstration establishes implemented behavior, not production tax clearance. The legal sources were reviewed on 5 September 2026; production facts require revalidation before real commerce.

**Non-Recoverable Preparation Cost (NRPC)**

MateryalPH applies no standard cancellation fee. NRPC is an optional Vendor-defined portion of the existing order value for actual irreversible preparation, such as cutting, mixing, customization, or a special order. It is not added on top of the agreed materials and service total. There is no platform-wide percentage or peso cap; the Vendor determines the amount for the specific order, subject to `0 < NRPC ≤ eligible prepared-material subtotal`, required reason, clear disclosure, Buyer acceptance, evidence when retained, and Admin review when flagged. The toggle is disabled by default and any NRPC order requires manual Vendor review; auto-accept is prohibited.

Before payment or preparation, the Buyer must see and explicitly accept the NRPC amount, reason, affected lines, cancellation effect, and versioned NRPC Terms. A Buyer may flag the NRPC as disproportionate without automatically blocking an otherwise accepted order. The flag creates an Admin review record, preserves the Buyer's acceptance and objection separately, and may result in removal, reduction, or other remedy through the dispute process.

For a fully online order, NRPC is tagged within the paid total. For COD or In-Store Payment, the accepted NRPC is collected as a separate online assurance payment with a 45-minute expiry and credited against the amount due at delivery or pickup. Failure to pay before expiry cancels the pending request and releases reservations. NRPC is retained only when an eligible Buyer-requested cancellation becomes final during `PROCESSING` and the Vendor can substantiate the preparation. It is forfeited when the Vendor cancels and cannot limit remedies for defective, incorrect, unsafe, misrepresented, or otherwise nonconforming goods or Vendor-caused failure.

**Cancellation Eligibility and Refund Trigger**

| **Order state and actor** | **Required behavior** |
| --- | --- |
| Buyer before Vendor confirmation | Withdraw immediately; release soft state; no refund when no payment was captured |
| Buyer at `AWAITING_PAYMENT` | Cancel or allow expiry; release hard reservation; refund only if reconciliation identifies a captured payment |
| Buyer at `CONFIRMED` before preparation | Require a reason; finalize under the applicable rule; automatically refund the eligible paid amount |
| Buyer at `PROCESSING` | Require a reason and review; an accepted, substantiated NRPC may be retained; automatically refund the calculated balance when cancellation becomes final |
| Buyer at `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY` | Cancellation action unavailable; present dispute, return, warranty, and statutory-remedy paths |
| Vendor before `DELIVERED` or `PICKED_UP` | Require a reason; final cancellation forfeits NRPC, releases reservation, initiates a full Cancellation Refund when paid, and creates the NFR event |

Buyer cancellation reason codes are `CHANGE_OF_REQUIREMENT`, `DUPLICATE_ORDER`, `BUDGET_CHANGE`, `PROJECT_DELAY`, `SCHEDULE_CONFLICT`, `VENDOR_AGREEMENT`, and `OTHER`; `OTHER` requires explanatory text. Vendor cancellation codes distinguish stock failure, operational inability, delivery inability, compliance restriction, account restriction, Buyer agreement, and Other. Codes support reporting but never replace the required factual record or legal review.

---

# Two-Way Community Reputation and Rating System

The reputation system combines verified-purchase ratings with system-recorded operational performance. It does not use arbitrary manual point deductions. Moderation, resolved disputes, and confirmed operational events update only the metric to which they legitimately relate.

## Community Rating (Qualitative)

After a completed order, the Buyer may rate the Vendor on **Service Quality** and **Delivery Speed** or **Processing Speed**. The Buyer may also create a separate Product Review for each purchased line item, including a Product Quality rating, a comment of up to 1,000 characters, and permitted media.

The Vendor may rate the Buyer on **Inquiry Seriousness**, **Communication Quality**, and **Payment Reliability**. Buyer scores help Vendors assess transaction reliability but do not affect Vendor ranking.

Both parties' ratings remain hidden until both submit or 14 calendar days pass after completion. The submission window closes after 14 days. A reviewer may correct a submitted review within 24 hours, after which it is locked. Administrators may remove guideline-violating content only with a reason and audit record. Ratings associated with an active dispute may be temporarily withheld until the dispute is resolved.

Reviews show verified-purchase status. Public reviewer identity is limited to the first name and last initial unless the reviewer chooses a more restrictive permitted display name. Canceled, fraudulent, duplicate, test, and otherwise ineligible transactions do not contribute to scores.

## Computation

### Vendor Community Score (VCS)

`VCS = (Service Quality + Delivery/Processing Speed + MQS) / 3`

VCS ranges from 1.00 to 5.00 and uses a rolling 90-day window. It is published after at least five eligible Vendor ratings and after MQS is eligible. Below either threshold, the Vendor displays **New Vendor — Building Track Record**.

### Material Quality Score (MQS)

`MQS = Average of eligible Product Quality ratings across the Vendor's sold products`

MQS ranges from 1.00 to 5.00, uses a rolling 90-day window, and is published after at least five eligible product ratings. A product listing retains its own product-average rating separately from the Vendor-level MQS.

### Contractor Community Score (CCS)

`CCS = (Inquiry Seriousness + Communication Quality + Payment Reliability) / 3`

CCS ranges from 1.00 to 5.00, uses a rolling 90-day window, and is published after at least five eligible completed transactions. It does not feed into SRS, FMS, or Vendor badges.

### Operational Health Score (OHS)

OHS is generated from system-recorded events. It is published after at least 10 eligible orders during the trailing 30 days and is recalculated weekly.

`OHS = clamp(5.00 − NFR Penalty − LSR Penalty − RR Penalty − ODR Penalty − LVD Penalty, 1.00, 5.00)`

| **Metric** | **Definition and window** |
| --- | --- |
| Non-Fulfillment Rate (NFR) | Vendor-caused cancellations or refunds divided by eligible confirmed orders, trailing 30 days |
| Late Shipment Rate (LSR) | Orders dispatched or made ready after the Vendor-confirmed date divided by eligible fulfilled orders, trailing 30 days |
| Return Rate (RR) | Validated defect, wrong-item, or incomplete-order returns divided by fulfilled orders, trailing 30 days |
| Order Defect Rate (ODR) | Confirmed defect claims, chargebacks, or severe order issues divided by eligible orders, trailing 30 days |
| Listing Violation Deduction (LVD) | Active confirmed listing violations during the trailing 90 days |

The penalty bands remain:

| **Metric** | **No penalty** | **Low** | **Medium** | **High** |
| --- | --- | --- | --- | --- |
| NFR | 0–2% | 2.01–5%: 0.25 | 5.01–10%: 0.75 | Above 10%: 1.50 |
| LSR | 0–3% | 3.01–8%: 0.25 | 8.01–15%: 0.75 | Above 15%: 1.25 |
| RR | 0–2% | 2.01–5%: 0.25 | 5.01–10%: 0.50 | Above 10%: 1.00 |
| ODR | 0–1% | 1.01–3%: 0.25 | 3.01–6%: 0.75 | Above 6%: 1.25 |

LVD penalties are 0.10 for one violation, 0.30 for two to three, 0.60 for four to five, and 1.00 for six or more.

### Vendor Performance Score (VPS)

`VPS = (VCS × 0.50) + (OHS × 0.50)`

VPS ranges from 1.00 to 5.00. It is published only when both VCS and OHS are eligible. A neutral internal value of 3.00 may be used for ranking a new Vendor, but it is not displayed as an earned public score.

### Supporting Badge Metrics

`FRR = Orders fulfilled on or before the confirmed date ÷ eligible fulfilled orders × 100`

`CRR = Eligible inquiries receiving a meaningful Vendor response within 12 hours ÷ eligible inquiries received × 100`

Automated acknowledgments do not count as meaningful responses. Test, spam, blocked, and duplicate inquiries are excluded using documented rules.

### Automated Flagging, Sanctions, and Existing Orders

| **Condition** | **System Action** | **Existing confirmed orders** |
| --- | --- | --- |
| VPS below 3.00 or OHS below 2.50 for seven consecutive days | Warning and reduced discovery visibility | Continue |
| VPS below 3.00 or OHS below 2.50 for 30 consecutive days | Open an Admin investigation and restrict new inquiries where justified | Continue under monitoring |
| Temporary suspension | Hide listings and prevent new orders | Continue unless Admin determines fulfillment is unsafe or impossible |
| Permanent ban | Prevent new activity and cancel unconfirmed requests | Admin determines the safe completion, replacement, cancellation, or refund path for each confirmed order |

Warnings, flags, no-shows, and low scores do not automatically produce a permanent ban. Automated low-score actions apply only to published scores that have met their sample requirements; the neutral internal new-Vendor value cannot trigger enforcement. An authorized Administrator reviews severity, evidence, repetition, and proportionality. One appeal is permitted within five business days when new relevant evidence is submitted.

### Rating Eligibility Rules

| **Rule** | **Detail** |
| --- | --- |
| Trigger | Order reaches `COMPLETED` |
| Limit | One Vendor rating per party per order and one Product Review per eligible line item |
| Window | 14 calendar days after completion |
| Correction | 24 hours after submission |
| Blind reveal | Both submit or the 14-day window expires |
| Dispute | Rating may be withheld while a directly related dispute remains active |

A transaction dispute may be opened from `PROCESSING` onward. A post-completion return or dispute must be submitted within seven calendar days after `COMPLETED`, subject to any non-waivable right provided by applicable law. Safety, fraud, privacy, or account-abuse reports may be submitted outside the transaction window through the appropriate reporting channel.

---

### Ranking Algorithm

Ranking is deterministic and explainable. It uses only Tier 2 Vendor inventory inside the Buyer-selected radius. Radius changes recalculate location-dependent components. All scores are normalized to 0–100 and clamped to their valid ranges.

### Item-Based Procurement

Catalog browsing defaults to distance within the selected category. When a Buyer searches for a specific material and selects **Best Deal**, the Search Relevance Score applies.

`SRS = (Distance × 0.30) + (Price × 0.25) + (Normalized VPS × 0.20) + (Stock × 0.15) + (Product Rating × 0.10)`

| **Component** | **Formula** |
| --- | --- |
| Distance | `max(0, (1 − Actual Distance / Selected Radius) × 100)` |
| Price | `(Lowest comparable unit price / Candidate comparable unit price) × 100`, capped at 100 |
| Normalized VPS | `((VPS − 1) / 4) × 100`; new Vendor internal default is 50 |
| Stock | In Stock = 100; Limited Stock = 50; Out of Stock = 0 and excluded |
| Product Rating | `(Product average / 5) × 100`; unrated listing internal default is 60 and is labeled New |

Comparable prices must use the same product, variant, unit, and quantity basis. Sponsored placement, if introduced later, must never be mixed invisibly into SRS.

### Project-Based Procurement

`FMS = (Material Match × 0.40) + (Budget Fit × 0.25) + (Distance × 0.20) + (Normalized VPS × 0.15)`

| **Component** | **Formula** |
| --- | --- |
| Material Match | Fulfillable normalized required quantity divided by total normalized required quantity × 100 |
| Budget Fit | 100 when total projected cost is within budget; above budget, subtract five points for each percentage point of overage, with a minimum of 0 |
| Distance | `max(0, (1 − Vendor distance / Selected radius) × 100)` |
| Normalized VPS | `((VPS − 1) / 4) × 100`; new Vendor internal default is 50 |

Lead time and missing-item count remain visible but do not silently change the formula. One Project-Based work package is awarded to one Vendor. Missing items are sourced through linked Item-Based orders.

Default SRS and FMS weights are stored in `platform_settings`. Buyer overrides are stored separately in `buyer_ranking_preferences`, with separate Item-Based and Project-Based records. Weights must total 100%, cannot all be zero, and may be reset to the current platform defaults. A sliders/tune shortcut appears in Item-Based search and Project-Based comparison, with an indicator when personalized weights are active.

---

**MAT-01 — Purpose, source, and location scope.** Materials Analytics is a local listed-price planning aid shared by Buyer, Vendor and Admin clients. It uses only eligible Tier 2 catalog inventory, never Google Tier 1 prices, private quotations, completed-sale prices, tax records or competitor stock quantities. Earlier Price Trend Insight wording that combined listing and transaction observations is superseded for this feature; completed-sale prices remain private transaction/reporting evidence. No automatic repricing, price forecast, paid analytics API or machine-learning model is added.

Buyer Explore displays **Nearby Verified Vendors**, **Available Products**, and **View Materials Analytics** above the category list. The Buyer-selected browsing origin and exact radius are inherited by the analytics list and Material Price Details. Allowed radii remain `5, 10, 20, 30, 40, 50 km`, default 5 km; expansion requires the existing confirmation. A Project-origin deep link explicitly labels and uses that Project site without overwriting another saved location. Vendor analytics use the authenticated organization's verified store point, default 50 km, with the same radius options and no arbitrary competitor-centered pin. Admin analytics use the selected versioned PSGC area, including Philippines-wide scope; the Buyer/Vendor 50 km ceiling does not restrict national Admin aggregation. Distance is geodesic radius membership, not driving distance or a delivery guarantee.

**MAT-02 — Current counts and eligibility.** For one current request snapshot, an eligible offer requires an active Tier 2 organization, ACTIVE/publishable listing, valid required compliance, an approved finite positive ordinary public price and tax classification, confirmed non-stale inventory and positive sellable quantity for the variant. Internal quantity remains private. Eligible listings may support pickup or delivery; actual delivery serviceability is revalidated for the selected fulfillment method. Count `DISTINCT vendor_organization_id` with at least one eligible listing and `DISTINCT vendor_listing_id` with at least one eligible variant within the scope. Multiple variants do not inflate Available Products; two different stores offering the same material count as two listings. Vendor count is not the count of all registered stores. Never count Tier 1, suspended stores, unavailable variants or stale inventory.

The Explore cards are current totals for the location/radius before category/search filtering; label this scope explicitly. Current offer lists and seller counts use the same current eligibility predicate. Date filters affect historical analytics, not these current counts. Return `current_as_of`, origin/radius or PSGC scope, eligibility version and dataset label together. Short-lived cached counts are labeled with their timestamp and invalidated by eligibility changes; checkout always revalidates authoritative state. Material rows with recorded history but no eligible current offers remain viewable with **No Current Offers**, zero current sellers, and no purchase action.

**MAT-03 — Comparable groups, variants, and average.** A material family is a navigation group, not a license to average incompatible goods. Each comparable group has a canonical material ID, exact brand/model when applicable, controlled technical specifications and variant attributes, approved unit-conversion version and canonical sale unit. Cement types, steel grades/diameters/lengths, pack sizes without validated conversions and other incompatible goods remain separate. Do not infer equivalence from fuzzy names or convert mass to volume without an approved material-specific conversion. Unmapped custom products remain purchasable when otherwise eligible but display **Not Yet Comparable** and are excluded from price aggregates until mapped.

Use the ordinary single-sale-pack public amount, inclusive of applicable Vendor VAT, normalized to the stated canonical unit. Exclude promotions, volume tiers, negotiated prices, delivery, processing fees, CWT, Vendor commission and NRPC. A public price change has a new immutable listing-price version. Products with only a bulk-specific quotation and no ordinary public price cannot enter the average. Tax classification is retained for explanation; VAT-inclusive and non-VAT payable offers may be compared for Buyer cash budgeting without adding VAT to either again.

First deduplicate offers within each `(Vendor, comparable group, snapshot)` so each Vendor contributes one value: choose the eligible offer with the latest published ordinary-price effective timestamp, breaking equal timestamps by ascending stable listing-variant ID. Record the chosen source and duplicate exclusion internally. Then `daily_average = sum(selected Vendor normalized prices) / distinct contributing Vendors`. Do not weight by inventory, orders, listing count, reviews or store size. Preserve decimal precision for normalization and calculation; round displayed PHP amounts half-up to two decimals. A parent material row lists its separate comparable variants and averages; it has no blended price across incompatible groups.

**MAT-04 — Daily snapshots, dates, and trend.** One shared scheduled job captures eligible current offers at 00:10 Asia/Manila each day. Store the actual capture instant, local snapshot date, price/version, geography/address version, eligibility/comparability versions and source dataset. Use one consistent database snapshot and publish a run only after every staged partition validates; partial/failed runs are never presented as complete. Capture all eligible marketplace sources once, then apply Buyer/Vendor radius or Admin geography at query time. Do not create a separate history per Buyer coordinate.

Daily observations are immutable. Job retries reuse the same run/source keys; an approved correction appends a replacement revision with reason and supersedes the selected run, without editing earlier observations. A missed day's job cannot invent historical inventory from today's state. Leave missing dates as gaps. A delayed same-day first capture is labeled with its actual time; if capture crosses local midnight, discard the incomplete staging run and start with the actual new date. Backfill is permitted only from sufficient authenticated historical source facts or explicitly simulated demo fixtures.

Default history is 30 days; presets compare the ending date to 7, 30 or 90 calendar days earlier. Default end is the latest successfully published snapshot date. Custom dates must have start before end, an interval of at most 365 days, and no future endpoint; the picker shows the earliest available recorded date. The graph includes both endpoints. Endpoints must have actual observations on those exact dates; do not silently use the nearest date, interpolate a missing value or extrapolate future prices.

For a comparable group, `change_percent = ((end_average - start_average) / start_average) * 100`, using unrounded decimal averages and displaying two decimals. Buyer and Admin may see a one-Vendor daily average labeled **Limited Local Data — 1 Vendor**, but percentage/direction requires at least two contributing Vendors at each endpoint and a positive starting average. Vendor comparisons require MAT-05's three competing Vendors at every displayed daily point and both endpoints. Missing/zero/insufficient endpoints return a null percentage and **Insufficient Local Data** or **Insufficient Competitor Data**. Direction uses the displayed percentage: positive Increasing, negative Decreasing, and rounded 0.00% No Material Change at Display Precision. Always show dates, unit, snapshot time, counts where permitted and the explanation that this is listed-price movement, not an official inflation index.

Filter historical points using each observation's recorded storefront location and the fixed query origin or geographic area. If participating Vendor IDs differ between endpoints, return `composition_changed=true` and explain that changed participation may affect the result; do not identify the competitors in the Vendor response. Historical eligibility is evaluated at capture, while current offer links recheck current eligibility. A source removed for proven invalid data is excluded only through a reviewed analytics correction, not silently erased because a store later closes.

**MAT-05 — Role visibility and disclosure.** Buyer Materials Analytics and Material Price Details show material description, specifications, comparable variants, daily averages, graph/table, current distinct offering-Vendor counts and current public offers with store name, price, tax display, availability, distance and listing link. They never expose exact stock or private historical negotiated prices. Opening an offer enters the existing Product Details and ordering workflow; an analytics price does not reserve stock or become a binding quotation.

Only Vendor Owner and Store Manager may access Vendor Materials Analytics under `materials_analytics.view_competitors`. Exclude the requesting Vendor's organization from all competitor aggregates before averaging or counting. Require at least three distinct competing Vendor organizations for each displayed aggregate, variant, graph point and endpoint. The only competitor outputs are the comparable material/variant, rounded aggregate average, permitted aggregate sample count, trend, dates and quality flags. No individual competitor offer rows, IDs, names, logos, links, coordinates, contact details, per-offer timestamps, minimum/maximum single-offer prices, or identifying export fields are serialized. The Vendor's own price is a separate authorized value and never contributes to its competitor average. Below threshold, return suppressed/null values and **Insufficient Competitor Data**; do not reveal the exact sub-threshold count. No frontend toggle may request Buyer detail serialization through a Vendor token. This is access control for this interface/API, not a promise of anonymity against public Buyer browsing or inference.

Admin aggregate access requires `analytics.view_aggregates`. The MAT sample rules concern public listed-price observations; existing small-cell protections for Buyer activity, demand and personal data remain independently enforced. A separate `materials_analytics.inspect_sources` permission allows source inspection of public listing identity, source price/version and geography for market-quality review; it does not grant tax-document, Buyer-coordinate, private inventory or unrestricted export access. Super Admin receives this permission; an approved Custom Role may receive it. Record source-inspection actor, filters, reason and correlation ID. Vendor staff outside Owner/Manager are denied; exports, cached responses, graph tooltips, notifications and logs follow the same audience rules. Material selection, date controls and radius/PSGC filters use server-validated allowlists, preventing arbitrary SQL/grouping or competitor-ID filters.

**MAT-06 — Interface and operational trace.** Buyer navigation is **Explore → Materials Analytics → Material Price Details → Selected Vendor Listing**. Material Price Details describes a canonical material/comparable group, distinct from the existing single-Vendor Product Details. Category sections are collapsible, searchable and paginated, with variant rows, visible PHP/unit, average as-of date, change period, seller count and a descriptive View Details action. Keep the approved Inter font, orange/charcoal semantic tokens, touch targets and responsive patterns. Use a simple line chart with gaps and an accessible data table/text summary; no color-only direction, mandatory animation or animation that conceals loading. Preserve filters/scroll on Back. Reuse the same query rules in Vendor Analytics and Admin Philippine Geographic Marketplace Analytics.

Every surface implements loading, empty, not-yet-comparable, insufficient sample/history, stale snapshot, unavailable current offer, offline, permission-denied and retry states. Offline data is labeled cached and cannot initiate checkout or change a Vendor price. Display **Updated daily**, last successful capture and current-offer timestamp separately. Do not relabel a cached result with the current time. Switching scope cancels/ignores stale responses and clears unauthorized cached detail on role/logout changes. Viewing Materials Analytics never rewrites an existing Project budget or accepted order. Vendor price editing uses the existing authorized listing editor with explicit save and audit; analytics never changes prices automatically.

The trace is `listing/price/availability version → comparable-group version → snapshot run → selected Vendor observation → scoped aggregate → audience-safe response`. Store filters, algorithm version and run reference needed to reproduce a result without routinely logging a Buyer's exact coordinate. TEST and any future live observations, jobs, caches and exports are isolated. Use **DEMO — Simulated Marketplace Data** throughout a seeded demonstration; no fictional history enters a live market chart. Collect real history only from the start of actual eligible captures. MAT-01–MAT-06 are the shared analytics requirements; FIN-01–FIN-12 remain authoritative for money/tax and are never recalculated from market averages.

**MAT-07 — Acceptance and demonstration.** Test exact radius boundary inclusion and just-outside exclusion; different units/specifications; duplicates and equal Vendor weighting; unavailable/stale variants; VAT-inclusive payable comparison; no mixed transaction/quotation prices; 7/30/90-day/custom endpoints; missing days; zero baseline; one-Vendor Buyer average without trend; two-Vendor Buyer trend; three-competitor Vendor visibility and suppression at two; own-store exclusion; participant changes; role/export/cache leakage; captured geography; retry/correction atomicity; and TEST/live separation. A demo with Vendor observations 100, 110 and 120 yields 110, regardless of duplicate listings. Endpoint averages 100 and 110 yield +10.00%; reversed endpoints yield -9.09%. A Vendor own price of 80 with three competitor prices 100, 110 and 120 sees own 80 and competitor average 110; removing one competitor suppresses the competitor result. Inspect actual API payloads, not just hidden UI labels.

### Administrative Geographic Aggregation

The Admin analytics service provides drillable aggregates for `Philippines → Region → Province or Independent/Highly Urbanized City → City or Municipality`. It never assumes that every region contains provinces. Selecting a geographic PSGC code filters the rest of the authorized Admin dashboard.

Supply uses active Tier 2 Vendor storefronts at the verified business-address point. Registered Buyer Count uses the verified primary/default Buyer location. Transaction demand uses the delivery or pickup reference or Project-site point associated with the order. Gross GMV includes confirmed commercial order value across Online, COD, and In-Store Payment, excludes the separately disclosed processing fee, and is measured before cancellations and refunds; Net GMV subtracts cancelled and refunded commercial value. Order Volume counts confirmed Vendor child orders.

Fulfillment, cancellation, dispute, response-time, category-demand, and active-user metrics use versioned definitions and store numerator, denominator, exclusions, time range, timezone, geographic basis, and aggregation timestamp. Active Buyer and Vendor trends count unique users performing meaningful actions rather than app opens. Aggregates use privacy-aware views, suppress or generalize small groups under the approved disclosure threshold, and provide accessible table equivalents for map and chart displays.

---

### Notifications and External-Service Failure Handling

Routine events use in-app notifications. Important account, order, compliance, and administrative events use email. Time-sensitive mobile and web events may use push notifications. MateryalPH does not use an SMS provider in the capstone; telephone numbers are retained only for legitimate contact and delivery coordination. Mandatory security notices cannot be disabled.

| **Failure** | **Required behavior** |
| --- | --- |
| Google Maps or Places unavailable | Preserve the selected location, allow manual address entry, and display only permitted cached data with a freshness notice |
| Xendit unavailable | Preserve the confirmed order, block new online-payment attempts temporarily, and allow retry; do not mark it paid |
| Delayed or duplicate Xendit webhook | Process idempotently and reconcile against the authoritative payment record |
| Cancellation or dispute refund request fails | Preserve `REFUND_FAILED`, retain the original idempotency key and trigger, notify authorized operations staff and the Buyer, and use only the approved retry or fallback path |
| Quotation accept conflicts with a newer version | Return HTTP 409, show the latest version and change summary, and do not reserve stock or begin payment |
| Quotation stock is no longer available | Make no partial reservation, set `STOCK_REVALIDATION_REQUIRED`, and require Vendor republication |
| OCR or QR unavailable | Allow manual compliance entry with mandatory evidence |
| Email unavailable | Queue, retry with backoff, and keep the requested action pending when verification is mandatory |
| Reverb unavailable | Preserve messages through the REST API and synchronize when the real-time channel returns |
| File service unavailable | Prevent completion of evidence-dependent actions and retain the draft |

---

### Privacy, Retention, Backup, and Account Deletion

MateryalPH applies transparency, legitimate purpose, proportionality, data minimization, accuracy, security, and limited retention. Privacy notices identify the controller, purposes, categories, recipients, retention basis, user rights, and contact process. Consent is requested only when consent is the appropriate legal basis; commercial Terms acceptance and Privacy Notice acknowledgment remain separate.

Users may request access, correction, objection, portability where applicable, deletion, or another lawful privacy action. The system verifies the requester, assigns a case reference, records the response, and preserves data that must remain for tax, fraud prevention, dispute, security, contractual, or legal-claim purposes. Deleted accounts are deactivated first; retained records are minimized or pseudonymized when direct identity is no longer required.

Retention is controlled by a formally approved retention schedule rather than arbitrary permanent storage. Each retained category has a legal or operational purpose, owner, retention trigger, expiration action, and exception for a legal hold. Production retention durations must be approved against current Philippine legal and tax requirements before launch.

Encrypted backups are automated, access-controlled, and periodically restore-tested. Recovery objectives, backup frequency, and retention are recorded in the deployment runbook. Production changes require database migration, rollback, monitoring, and incident-response procedures.

---

### Accessibility and Interface Quality

Buyer, Vendor, and Admin interfaces target WCAG 2.2 Level AA. Required controls include keyboard navigation for web portals, logical focus order, visible focus, screen-reader labels, error summaries, text alternatives, sufficient color contrast, scalable text, and status indicators that do not depend on color alone. Pointer targets meet the 24-by-24 CSS-pixel WCAG minimum; frequently used mobile controls should target approximately 44-by-44 logical pixels where practical.

Map functions have an equivalent list view. Dialogs trap and restore focus correctly. Tables provide headings and responsive alternatives. Authentication and CAPTCHA flows provide accessible alternatives. Destructive or financial actions require clear confirmation and cannot be represented by an unlabeled icon alone.

---

### Compliance and Authoritative References

MateryalPH supports compliance workflows but does not represent automated checks as a government certification or legal determination.

This workflow is a product and technical control specification, not legal advice. Before production launch, Philippine counsel, the Data Protection Officer, tax advisers, and the contracted payment provider must validate the then-current legal duties, notices, retention periods, fee treatment, invoicing process, and contractual allocation of responsibilities. A later change in law, regulation, regulator guidance, provider documentation, or contract supersedes a conflicting workflow rule and requires controlled change review.

- Vendor and Buyer personal information is processed under the Philippine Data Privacy Act of 2012, its Implementing Rules and Regulations, and relevant National Privacy Commission issuances.
- Marketplace disclosures, merchant traceability, complaint handling, and fair online practices must be validated against the Internet Transactions Act of 2023 and its current implementing rules.
- Consumer-facing descriptions, prices, fees, and remedies must be clear and non-misleading under applicable consumer-protection requirements.
- Electronic records and acceptance logs are retained in a manner consistent with the Electronic Commerce Act and applicable evidence requirements.
- Product PS/ICC checks use the current DTI-BPS regulated-products list and official verification sources.
- MateryalPH calculates transaction amounts and applicable withholding under FIN-01–FIN-12 and prepares internal/demo records. Vendor goods invoices and the platform's service invoices remain the respective issuer's responsibility through its registered process. Official filing, full income-tax accounting and government certification are not asserted by the capstone.
- Xendit capabilities, fees, sub-account behavior, payment channels, refund support, webhooks, and testing are implemented according to the active Xendit account and current documentation.
- Google Maps and Places content is displayed, attributed, stored, and cached according to the active Google Maps Platform agreement.

**Reference Baseline**

- [BIR RR No. 11-2018 — Filing, payee schedules and certificate timing](https://bir-cdn.bir.gov.ph/local/pdf/Digest%20RR%2011-2018.pdf)
- [BIR RR No. 16-2023 — Merchant remittance withholding and exclusions](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2016-2023%203.pdf)
- [BIR RMC No. 8-2024 — Registration, declarations, thresholds and responsibility](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%208-2024%20(1).pdf)
- [BIR RR No. 5-2025 — Current 0.5% gross-remittance rate](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%205-2025.pdf)
- [BIR RMO No. 18-2025 — Replacement withholding codes](https://bir-cdn.bir.gov.ph/BIR/pdf/RMO%20No.%20018-2025.pdf)
- [BIR RMO No. 26-2025 — Corrected gross-remittance code descriptions](https://bir-cdn.bir.gov.ph/BIR/pdf/RMO%20No.%2026-2025%20Digest.pdf)
- [BIR RMC No. 55-2026 — Withholding alphalist submissions](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2055-2026.pdf)
- [BIR RR No. 11-2025 — Electronic invoicing and reporting](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2011-2025.pdf)
- [BIR RR No. 26-2025 — Electronic-invoice transition and coverage](https://bir-cdn.bir.gov.ph/BIR/pdf/RR%20No.%2026-2025%20Digest.pdf)
- [BIR Form 2550Q guidance — VAT rates and bases](https://bir-cdn.bir.gov.ph/BIR/pdf/2550Q%20guidelines%20April%202024_final.pdf)
- [Xendit — Philippine withholding on gross remittances](https://docs.xendit.co/docs/withholding-tax-on-gross-remittances-ph)
- [Xendit — xenPlatform fees](https://docs.xendit.co/docs/xenplatform-fees)
- [Xendit — Split payments and refund limitations](https://docs.xendit.co/docs/split-payments)
- [PwC — When the BIR says mine to online sellers, February 2024](https://www.pwc.com/ph/en/tax/tax-publications/taxwise-or-otherwise/2024/when-the-bir-says-mine-to-online-sellers.html)
- [Inquirer — Online-seller withholding implementation, July 2024](https://newsinfo.inquirer.net/1961672/bir-online-sellers-must-now-pay-withholding-tax)
- [Cruz Marcelo — RR No. 16-2023 overview](https://cruzmarcelo.com/quick-look-bir-revenue-regulations-no-16-2023-requires-e-marketplaces-and-digital-financial-services-providers-to-withhold-1-income-tax-on-remittances-to-merchants/)

- [Lawphil — Republic Act No. 11967, Internet Transactions Act of 2023](https://www.lawphil.net/statutes/repacts/ra2023/ra_11967_2023.html)
- [Lawphil — Republic Act No. 8792, Electronic Commerce Act of 2000](https://lawphil.net/statutes/repacts/ra2000/ra_8792_2000.html)
- [Lawphil — Republic Act No. 7394, Consumer Act of the Philippines](https://lawphil.net/statutes/repacts/ra1992/ra_7394_1992.html)
- [National Privacy Commission — Data Privacy Act](https://privacy.gov.ph/data-privacy-act/)
- [National Privacy Commission — Implementing Rules and Regulations](https://privacy.gov.ph/implementing-rules-regulations-data-privacy-act-2012/)
- [BIR — Ease of Paying Taxes](https://www.bir.gov.ph/EOPT)
- [BIR RMC No. 77-2024 — Invoicing Clarifications](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2077-2024.pdf)
- [Philippine Statistics Authority — Philippine Standard Geographic Code](https://psa.gov.ph/classification/psgc)
- [DTI-BPS — PS and ICC Marks](https://bps.dti.gov.ph/product-certification/ps-and-icc-marks)
- [DTI-BPS — Products Under Mandatory Certification](https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification)
- [DTI — E-Commerce Philippine Trustmark / Internet Transactions Act](https://trustmark.dti.gov.ph/)
- [DTI-BPS — PNS 2155:2020 Guidelines for E-Commerce Transactions](https://bps.dti.gov.ph/press-releases/28-2021/259-dti-issues-national-standard-guidelines-for-e-commerce-transactions)
- [Xendit — Accept Payments for Sub-Accounts](https://docs.xendit.co/docs/accepting-payments-for-sub-accounts)
- [Xendit — Payments API Overview](https://docs.xendit.co/docs/how-payments-api-work)
- [Xendit — Available Payment Channels](https://docs.xendit.co/docs/available-payment-channels)
- [Xendit — Refund Payment](https://docs.xendit.co/docs/refund-payment-request)
- [Xendit — Transaction Fees](https://docs.xendit.co/docs/transaction-fees)
- [Google — Places API Policies and Attribution](https://developers.google.com/maps/documentation/places/web-service/policies)
- [Google — OpenID Connect](https://developers.google.com/identity/openid-connect/openid-connect)
- [NIST SP 800-63B — Authenticators](https://pages.nist.gov/800-63-4/sp800-63b/authenticators/)
- [OWASP — Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [OWASP — Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- [W3C — WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)

---

### Future Enhancements

The following are outside the current capstone workflow unless separately approved: Buyer organization team accounts, Vendor multi-branch management, live GPS delivery tracking, machine-learning ranking, MateryalPH escrow or wallet services, construction-vehicle rental, vouchers, and a Vendor RFQ bidding queue. Future features must use the same security, privacy, audit, accessibility, and state-management controls before release.
