**System Flow:**

---

### Backend (Laravel)

MateryalPH consists of three distinct application surfaces: a Flutter mobile application for Buyers, a React.js web portal for Vendors, and a separate React.js web portal for Administrators. All three applications use one versioned Laravel REST API and one PostgreSQL database. The project follows a modular monolithic architecture so that authentication, authorization, marketplace rules, orders, inventory, payments, disputes, compliance, notifications, and audit records are governed by one authoritative backend.

The term **Buyer** is used throughout the system for SME contractors, independent builders, and DIY builders. The term **Vendor Owner** refers to the main store account. A **Tier 1 Supplier** is an informational Google Places directory result, while a **Tier 2 Vendor** is a registered and verified MateryalPH marketplace participant.

**Development Tools and Technology Stack**

| **Layer / Tool** | **Technology** | **Purpose** |
| --- | --- | --- |
| Buyer Mobile Application | Flutter / Dart | Buyer registration, supplier discovery, Item-Based and Project-Based procurement, orders, messages, disputes, and account settings |
| Vendor Web Portal | React.js 18 + Vite | Vendor onboarding, listings, inventory, orders, fulfillment, messages, compliance, staff, and analytics |
| Admin Web Portal | React.js 18 + Vite | Verification, moderation, disputes, account enforcement, platform configuration, monitoring, and audit |
| Web Styling | Tailwind CSS | Responsive and accessible styling for Vendor and Admin portals |
| Mobile State Management | Provider or approved equivalent | Authentication, cart, map, order, and application state |
| Web State Management | Zustand or approved equivalent | Authentication, notifications, filters, and portal state |
| Backend API | Laravel 11 / PHP | Shared REST API, business rules, queues, scheduling, PDF generation, and integrations |
| Authentication | JWT-based architecture | Short-lived access tokens and rotated, revocable refresh tokens |
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

Every online payment record has one purpose: `FULL_ORDER_PAYMENT`, `NRPC_ASSURANCE_PAYMENT`, or `ORDER_BALANCE_PAYMENT`. Cash on Delivery and In-Store Payment balances are recorded as physical-payment obligations rather than false online-payment successes.

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
| `refunds` | `CANCELLATION`, `DISPUTE_CONCLUSION`, or `TECHNICAL_COMPENSATION` trigger; order; Case ID when applicable; original payment; amount; provider reference; idempotency key; state; and events |
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

Every Tier 2 Vendor must complete Xendit xenPlatform onboarding before marketplace activation. Online payments are created for the applicable Vendor sub-account. MateryalPH charges zero marketplace commission, does not operate an internal wallet, and does not represent itself as holding funds in escrow. Vendor balances and withdrawals are managed through the applicable Xendit account and dashboard.

The Buyer confirms the order only after the Vendor confirms inventory, permitted revisions, expected fulfillment date, delivery vehicle or trip count, final total, and any NRPC. For online payment, the checkout creates the payment request and waits for a verified Xendit event. For Cash on Delivery or In-Store Payment without NRPC, the order records the selected physical-payment method without creating a Xendit payment. When NRPC applies to a physical-payment order, the system first collects the accepted NRPC amount online as an assurance payment and credits it against the later physical-payment balance.

The Buyer pays the disclosed online payment-processing fee. The interface labels it **Payment Processing Fee**, not “Xendit deduction,” and displays the materials subtotal, delivery fee, processing fee, and total before confirmation. The system applies no markup to the actual configured fee. Passing the fee to the Buyer must be permitted by the active Xendit agreement and applicable Philippine law before production use.

Enabled online channels are drawn from the actual Xendit environment and may include GCash, Maya, GrabPay, QR payments, and supported over-the-counter channels. Each channel stores its payment limits, expiry, settlement behavior, and refund capability. A channel without native refund support must have a documented Vendor-managed refund method before it is enabled; otherwise it remains disabled.

Refunds are created through a supported Xendit refund operation for the relevant sub-account where available and must return to the original payment method. MateryalPH records the trigger, request, Xendit identifier, amount, initiator, reason, state, and verified webhook results. A successful refund webhook means the request was processed and forwarded through the payment rail; the Buyer UI must not claim that funds have already appeared and must display the channel-dependent expected arrival information.

Refund initiation has two independent business triggers:

1. **Cancellation Refund.** When cancellation of an already-paid order becomes final, the backend automatically calculates the refundable amount and submits one idempotent refund request. Vendor-caused cancellation returns every Buyer-paid order amount, including NRPC. Buyer-caused cancellation during `PROCESSING` may retain only the accepted, applicable NRPC and any separately disclosed processor treatment permitted by law. Cancellation is not available after `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`; statutory remedies and dispute reporting remain available.
2. **Dispute-Conclusion Refund.** A dispute remains separate from refund state. If the final, unappealed or immediately enforceable dispute outcome awards a full or partial refund, the backend submits the corresponding idempotent refund request and links it to the Case ID and decision. Filing the dispute alone does not initiate a refund.

Administrators may decide a dispute outcome but do not receive, hold, or manually disburse money. A failed or unsupported refund is placed in an exception queue and follows the disclosed, contractually approved fallback. Payment-processing fees may be nonreturnable to the Vendor under provider terms; Buyer-facing treatment follows the disclosed cancellation and fault rules.

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
- MateryalPH generates a Purchase Order, itemized order record, and payment confirmation only. The Vendor is responsible for generating and uploading the legally compliant invoice through its registered system. MateryalPH does not calculate or issue the Vendor's official tax invoice.
- Xendit capabilities, fees, sub-account behavior, payment channels, refund support, webhooks, and testing are implemented according to the active Xendit account and current documentation.
- Google Maps and Places content is displayed, attributed, stored, and cached according to the active Google Maps Platform agreement.

**Reference Baseline**

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
