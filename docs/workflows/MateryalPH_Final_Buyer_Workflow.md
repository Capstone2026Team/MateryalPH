**Buyer Flow**

---

### Mobile Application (Flutter/Dart)

MateryalPH provides a dedicated **mobile application** for Buyers. The Buyer application is separate from the Vendor and Admin web portals and supports account management, geolocation-based supplier discovery, Item-Based Procurement, Project-Based Procurement, orders, payments, delivery milestones, messages, ratings, disputes, and settings.

The System Workflow is the authoritative source for shared security, state, scoring, payment, privacy, accessibility, audit, and integration rules. This Buyer Workflow defines how those rules are presented to and used by the Buyer.

The term **Buyer** includes an SME contractor, independent builder, or DIY builder. Existing Buyers use **Sign In**. New Buyers use **Sign Up**. Vendor and Admin accounts use their respective web portals and cannot be created from the Buyer application.

---

**Buyer Sign-in and Sign-up**

**Buyer Sign-in**

The Buyer may sign in using email and password or a linked Google account. All requests use HTTPS and are validated by the Laravel backend. The application applies input validation, rate limiting, account-status checks, and risk-based bot protection. Authentication responses do not reveal whether an email belongs to an account.

For email/password sign-in, the backend verifies the securely hashed password, verified email status, account status, and applicable security controls. For Google sign-in, the backend validates the Google ID token, including signature, issuer, audience, expiration, nonce, and `email_verified`. The Google `sub` value is used as the external identity identifier. MateryalPH never requests or stores a Google password.

A routine login from a recognized device does not require an email OTP after every attempt. Email OTP is used for email ownership verification, account recovery, a new or suspicious device, and sensitive account changes. This avoids representing email as strong multifactor authentication while retaining a no-SMS capstone design. The Buyer may later enroll a stronger authenticator if offered.

**Buyer Sign-up**

The Buyer may register through:

- **Sign Up with Email and Password.** The Buyer provides full name, email address, mobile number, password and confirmation, Buyer type, Terms of Service acceptance, and Privacy Notice acknowledgment. The system sends a six-digit, short-lived, single-use OTP to the registered email. The account remains restricted until the OTP is verified.
- **Sign Up with Google.** The Buyer authenticates through Google. A valid verified Google email satisfies email ownership verification, so no additional email OTP is sent. The Buyer completes any missing required fields, including mobile number, Buyer type, Terms acceptance, and Privacy Notice acknowledgment.

The mobile number is a contact and delivery-coordination field only. MateryalPH does not send SMS OTP or routine SMS notifications. Philippine numbers are normalized to E.164 format and are not displayed publicly. The same email address cannot be used to create multiple MateryalPH account types in the current capstone; an existing account produces a safe instruction to use the appropriate application.

The system records the accepted Terms version, Privacy Notice version, user, timestamp, and source. Commercial Terms acceptance remains separate from privacy acknowledgment or consent.

**Forgot Password and Account Recovery**

The Buyer submits an email address and receives a generic response. If eligible, the system sends a time-limited, single-use recovery link or OTP. A successful reset invalidates existing sessions and refresh tokens, records a security event, and sends a confirmation notice. Repeated requests and failed codes are rate-limited. Changing the primary email requires reauthentication, verification of the new email, notice to the previous email, and session revocation.

---

**Buyer Onboarding**

After registration, the Buyer may complete or skip optional profile onboarding. Required account information remains complete even when onboarding is skipped.

Optional onboarding may collect:

- Business or company name.
- Position or role.
- Business address.
- Contractor or industry classification.
- Preferred material categories.
- Saved delivery addresses or project sites.
- First Procurement Project.

Company fields are optional for independent and DIY builders. A Buyer may save multiple addresses and project sites. Every order must identify the location used for discovery, pickup reference, or delivery. GPS permission is optional; denial never blocks address entry, map-pin placement, catalog browsing, or procurement.

Buyer organization team accounts are outside the current capstone scope. Every action is attributed to the individual Buyer account that performed it.

---

**Buyer Mobile Pages**

The bottom navigation contains five primary destinations: **Map**, **Explore**, **Projects**, **Messages**, and **Profile**. Map is the default authenticated destination. Each destination preserves the selected location and current procurement context when the Buyer temporarily moves to another tab. A protected deep link returns the signed-in Buyer to the requested record after authorization.

Every page implements `loading`, `content`, `empty`, `recoverable error`, `offline`, and `permission denied` states where applicable. Retry never duplicates an order, quotation acceptance, payment, cancellation, or dispute. Financial and destructive actions require a review screen and explicit confirmation. User-entered drafts are retained locally only when appropriate and are synchronized securely after connectivity returns; payment and inventory decisions always require an online server response.

**Map Home**

- **Design.** The top app bar contains the active Location Selector and labeled Search, Notifications, and Cart actions. Radius chips show `5`, `10`, `20`, `30`, `40`, and `50 km`; five kilometers is the default. A tune icon opens filters. The map shows the selected boundary, Buyer or project pin, clustered Vendor markers, map-layer control, recenter control, and a legend for Verified Vendors, Directory Suppliers, and Favorite Suppliers. The weather widget is removed. A draggable **Vendors Near You** sheet and equivalent full list expose the same results.
- **Flow.** Opening the page loads the last permitted location and radius, then requests eligible Tier 1 and Tier 2 results. Selecting a marker focuses its summary card; selecting the card opens the Vendor Store Profile or the limited Tier 1 details. Radius expansion occurs only after Buyer confirmation. Pull-to-refresh reruns the search without changing saved preferences.
- **Logic.** GPS is optional. If unavailable, the page uses a manually selected location. Ranking and exact-radius filtering occur on the backend. Map and list results share one result identifier so selection remains synchronized. Failed map tiles do not block the list, search, or procurement functions.

**Explore Materials Catalog**

- **Design.** Explore shows the active-location indicator, search field, categories, recently viewed products, Favorite Suppliers, recommended eligible listings, filters, sorting, notifications, and Cart. Categories use the controlled platform taxonomy: Cement and Concrete; Roofing Materials; Formwork and Scaffolding; Wood and Lumber; Landscaping and Exterior; Steel and Reinforcement; Tools and Accessories; Masonry; Insulation and Waterproofing; Aggregates; Hardware and Fasteners; Electrical Materials; Drainage and Septic Materials; Plumbing Materials; Construction Chemicals; Wall and Ceiling Materials; Sanitary Fixtures; Paints and Finishes; Doors, Windows, and Glass; Flooring Materials; HVAC Materials; Fire Protection Materials; Adhesives and Sealants; and Other.
- **Flow.** Selecting a category applies it to active Tier 2 listings inside the chosen radius. Search opens Search Results; a listing opens Product Details; the tune shortcut opens Item-Based ranking preferences. Reset restores current platform defaults.
- **Logic.** Catalog browsing defaults to distance, while text search defaults to SRS Best Deal. Only active and serviceable Tier 2 listings are purchasable. Stale or unavailable listings remain excluded even if a cached card is visible.

**Search Results**

- **Design.** The page provides editable query text, result count, selected location and radius, sort control, filter chips, active-filter summary, list/grid selection, and accessible result cards. Each card shows product, normalized unit price, public stock status, Vendor, distance, rating eligibility, fulfillment methods, badges, and data-freshness time.
- **Flow.** A query is normalized for aliases and typographical similarity. Filters may include category, brand, variant, compliance status, availability, fulfillment method, Favorite Supplier, price range, and radius. Changing radius or weights requests a new ranked result set; Back restores the prior query and scroll position.
- **Logic.** Cursor pagination prevents duplicate cards. Results are deduplicated by listing and variant. Empty results offer filter removal or confirmed radius expansion. The page never represents Tier 1 directory records as purchasable inventory.

**Product Details**

- **Design.** Product media, display name, brand, manufacturer, origin, description, technical attributes, unit, variants, unit price, public availability, compliance evidence, product rating, Vendor card, distance, route estimate, fulfillment methods, and Add to Cart are arranged in labeled sections. Message Vendor and Favorite are secondary actions.
- **Flow.** The Buyer selects a variant, compatible unit, quantity, and fulfillment preference. Site Delivery requests a preliminary vehicle/trip suggestion; Self-Pickup shows the Vendor location and preliminary readiness information. Message Vendor starts an Item-Based conversation with a locked product reference. Add to Cart records the current listing version without reserving stock.
- **Logic.** Quantity must be positive, compatible with pack rules, and within public ordering limits. Price, compliance, serviceability, and active status are revalidated on Add to Cart and checkout. A PS/ICC badge describes MateryalPH evidence status and is not presented as a new government certification.

**Select Location**

- **Design.** Tabs provide Saved Locations, Search Address, and Drop Pin. The confirmation panel shows the formatted address, map preview, coordinates at appropriate precision, PSGC region/province/city-or-municipality where resolved, label, contact, and optional site instructions.
- **Flow.** The Buyer may grant current-location permission, search an address, move the pin, or select a saved location. The page validates serviceability and asks whether the choice applies to browsing only, a project, or an order. Save requires a descriptive label when retained for future use.
- **Logic.** Location permission denial never blocks manual entry. Coordinates are validated against Philippine bounds and geocoded server-side. Sensitive site instructions are shown only to the relevant Vendor after an order or authorized inquiry requires them.

**Shopping Cart**

- **Design.** Cart lines are grouped by Vendor, with variant, unit, quantity editor, price snapshot, fulfillment choice, preliminary delivery estimate, subtotal, availability warning, and remove/save-for-later actions. The parent summary clearly states that checkout creates separate Vendor child orders.
- **Flow.** Quantity changes trigger price and availability revalidation. The Buyer resolves invalid or expired lines before proceeding. Checkout may continue for eligible Vendor groups while leaving blocked groups in the cart, but the app requires the Buyer to confirm the split.
- **Logic.** Cart placement and quantity editing do not reserve stock. Totals are advisory until Vendor confirmation or eligible auto-accept. Retry uses idempotency and cannot create duplicate child orders.

**Checkout**

- **Design.** Checkout is a review sequence for delivery/pickup details, contact, Vendor-group totals, payment method, NRPC where proposed, Terms, and final submission. Each child order shows Materials Subtotal, Delivery Fee, NRPC included within the order value, Payment Processing Fee, Amount Due Now, Remaining Physical-Payment Balance where applicable, and Total.
- **Flow.** A normal cart submits Vendor confirmation requests. An accepted quotation enters checkout from its latest version. The Buyer explicitly accepts every revision and NRPC Terms before payment. Online payments open the authorized Xendit action and return to a pending-status page; redirects never independently mark payment successful.
- **Logic.** The backend revalidates quotation version, inventory reservation, address, fulfillment method, payment channel, fee, and expiry. Online payment and an NRPC assurance payment expire after 45 minutes, with exact Asia/Manila time and countdown displayed. An expired attempt releases applicable reservations and offers a safe retry only when the commercial snapshot remains valid.

**Projects**

- **Design.** Project cards show name, location, schedule, status, overall budget, committed spend, actual spend, remaining balance, work-package progress, and alerts. Create Project, filters, archive, and procurement-report actions are available according to state.
- **Flow.** Selecting a project opens its overview and Work Packages. Creation collects required project fields, validates budget and dates, and allows optional site details. A project with procurement history may be completed or archived but not physically deleted.
- **Logic.** Totals are calculated from linked work packages and orders rather than client-side estimates. An archived project is read-only except for permitted reports, disputes, invoices, and privacy actions.

**Work Packages**

- **Design.** The project header is followed by phase cards containing budget, materials count, sourcing progress, selected Vendor, quotation status, order status, and missing items. Create, Edit Draft, Activate Scan, View Results, Link Item Order, Complete, and Cancel are state-aware actions.
- **Flow.** The Buyer creates material lines and activates the package. Activation locks the original requirements and starts Vendor scanning. Returning an unselected package to Draft invalidates prior estimates. After procurement evidence exists, changes create a new version rather than overwriting history.
- **Logic.** Material lines require normalized units and positive quantities. One Project-Based Vendor may ultimately be accepted for each Work Package. Missing lines may be linked to separate Item-Based orders without changing that rule.

**Vendor Comparison**

- **Design.** System-compiled Vendor results may be displayed as sortable cards or a comparison table. Each result shows FMS, fulfillment percentage, missing lines, item subtotal, estimated delivery, projected total, budget label, distance, ETA, performance, badges, payment methods, and estimate expiry. Each Vendor card provides Message Vendor and Select Vendor actions; the tune shortcut opens FMS preferences.
- **Flow.** The Buyer may open an inquiry with any Vendor in the result list before selecting one. Each inquiry receives the locked Work Package and Vendor-editable duplicate. Published quotations appear beside the system estimate with version, deadline, change-summary, and current decision actions. When the Buyer selects without a quotation, an optional informational Note may accompany the package request and does not require a response.
- **Logic.** System estimates and Vendor quotations remain separately labeled. Accepting one Vendor quotation or confirming one direct selection atomically assigns the Work Package and expires other active quotations for that package. Message histories remain accessible. An expired system estimate must be refreshed before direct selection.

**Project Quotation Inquiry**

- **Design.** The conversation includes a pinned locked-original tab, Vendor-proposal tab, version selector, change-summary panel, itemized total, fulfillment details, NRPC disclosure, exact deadline, countdown, and Accept, Reject, or Counter-Offer actions. The store and staff identities are displayed together.
- **Flow.** The Vendor edits its duplicate and publishes a version. The Buyer views the plain-language differences from the original, opens line-level detail when needed, and decides only on the latest version. A counter-offer records requested changes and returns the quotation to the Vendor. Acceptance proceeds to atomic inventory validation and checkout.
- **Logic.** Older versions are read-only and cannot be accepted. If inventory is insufficient at acceptance, no payment begins and the Vendor must republish. Project inquiries use the shared Order-from-Chat engine with `PROJECT_BASED` context.

**Orders and Milestone Tracking**

- **Design.** Orders are grouped by Active, Awaiting Action, Completed, Cancelled, and Disputed, with filters for project, Vendor, procurement type, fulfillment, payment, and date. Cards show Order ID, Vendor, amount, current order/payment/refund states, next action, expected date, and any countdown.
- **Flow.** Selecting a card opens Order Details. The page deep-links to payment, revision approval, NRPC acceptance, cancellation, proof, dispute, rating, or invoice tasks. Push or in-app notification selection opens the same authorized order.
- **Logic.** Order, payment, refund, fulfillment, and dispute states are displayed independently. The app never infers payment success from a redirect or hides a pending refund behind a cancelled order label.

**Order Details**

- **Design.** The page contains order summary, immutable line snapshots, Vendor and handler identity, Project/Work Package reference, quotation version, change summary, fulfillment, address, payment breakdown, NRPC amount and reason, payment/refund timeline, evidence, messages, Purchase Order, invoice request, and event history.
- **Flow.** Available actions are calculated from server state. The Buyer may pay, approve a revision, accept NRPC, message the Vendor, request a permitted cancellation, view proof, confirm receipt, report an issue, rate, or request an invoice.
- **Logic.** NRPC is identified as part of—not an addition to—the agreed order value. For COD or In-Store Payment, Amount Paid Online and Remaining Balance are shown separately. Records from older quotation or order versions remain read-only.

**Review**

- **Design.** Verified-purchase Vendor and product rating forms are separate. The page shows eligibility, submission deadline, rating criteria, optional comment, media rules, and the privacy-safe public identity that will appear.
- **Flow.** The Buyer rates the Vendor and applicable products, previews the submission, and confirms. A submitted review may be corrected within 24 hours. Report Review is available for content concerns.
- **Logic.** Only eligible completed lines may be reviewed once. Reviews remain hidden until both sides submit or the 14-day window ends. An active dispute may delay publication without deleting the draft.

**Cancellation Request**

- **Design.** The page shows the current state, whether cancellation is available, reason selector, explanation, financial-impact preview, NRPC evidence status where applicable, refund estimate, and confirmation. Unavailable cancellation is replaced by Report a Problem or Dispute guidance.
- **Flow.** Before Vendor confirmation, the Buyer may withdraw the request. From `CONFIRMED` through `PROCESSING`, the Buyer submits a valid reason. The system or authorized reviewer finalizes the result. Cancellation is unavailable at `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`, although statutory remedies and dispute reporting remain available.
- **Logic.** A finalized paid cancellation automatically initiates the cancellation refund. Vendor-caused cancellation returns all Buyer-paid order amounts and forfeits NRPC. Eligible Buyer cancellation during `PROCESSING` may retain the accepted, substantiated NRPC. The preview is recalculated server-side before confirmation.

**Return or Refund Request**

- **Design.** This structured form collects issue type, affected lines, requested remedy, requested amount where partial, description, evidence, and preferred contact channel. It displays eligibility, submission deadline, privacy warning, and the original masked payment method for a possible refund; it never asks for a different card, e-wallet, or bank destination.
- **Flow.** Submission creates a Case ID and `DISPUTE_OPEN`. The Vendor response, mutual-resolution, Admin review, and appeal stages follow the dispute timeline. If the final conclusion awards a refund, the system initiates the separate dispute-conclusion refund.
- **Logic.** Filing does not immediately create `REFUND_PENDING`. Refund destination remains the original payment source when supported. Duplicate submissions for the same issue are linked or rejected safely.

**Proof of Delivery**

- **Design.** The Buyer sees Vendor-uploaded photo, milestone time, receiver name, optional signature, vehicle/trip reference, and a map/address summary without exposing unnecessary staff or receiver data. Confirm Receipt and Report a Problem are prominent actions.
- **Flow.** After `DELIVERED` or `PICKED_UP`, the Buyer reviews proof and confirms or reports an issue. A reminder precedes two-day automatic confirmation. Reporting an issue pauses automatic completion.
- **Logic.** Media access uses expiring authorization. The Buyer cannot edit Vendor evidence; any Buyer response becomes a separate event. Missing required evidence prevents the Vendor from completing the relevant milestone.

**Messages**

- **Design.** The inbox groups conversations by Vendor and context, with unread count, pinned context, current quotation/order status, and search. The thread header shows store logo and name plus the assigned staff member's avatar, name, and role. Context cards distinguish Product, Work Package, Quotation, and Order.
- **Flow.** The Buyer may send text and permitted attachments, open a product inquiry, start a quotation inquiry, view quotation versions, counter, accept, or follow an order-linked conversation. Staff reassignment is announced in the thread.
- **Logic.** Ordinary messages cannot alter commercial records. Attachments are validated and scanned. Send retries use client-generated identifiers to avoid duplicates. Private staff contact and authentication data are never displayed.

**Favorite Suppliers**

- **Design.** Favorite Vendor cards show current serviceability, distance, categories, rating, badges, last order, and active listing count. Filters support project, phase, category, and availability.
- **Flow.** The Buyer can open a store, message, remove the Favorite, or use Favorites First where offered. Removal asks for confirmation only when it also changes an active personal filter.
- **Logic.** Favorite status is personal and does not change SRS or FMS unless the Buyer explicitly selects the Favorites preference. Vendors outside the radius remain visible as saved but are not shown as eligible.

**Notifications**

- **Design.** Notifications are grouped by Orders, Quotations, Payments and Refunds, Projects, Messages, Disputes, Security, and System. Each entry includes exact time, status, short action, read state, and deep link. Filters and Mark All as Read are available.
- **Flow.** Selecting a notification opens the authorized record. Expiry-sensitive entries show the same server deadline as the related page. Notification preferences control optional channels but cannot disable mandatory security, payment, refund, or legal notices.
- **Logic.** Read state synchronizes across devices. Expired links open the current record state rather than a stale action. Sensitive message content is minimized on lock-screen push notifications.

**Disputes**

- **Design.** Case cards show Case ID, order, issue, requested remedy, current stage, responsible party, exact response deadline, refund state, and appeal availability. Case Detail contains the chronology, evidence, messages, decision, and linked refund timeline.
- **Flow.** The Buyer may respond to clarification, accept a proposed resolution, add permitted evidence, or appeal once with new relevant evidence. A refund awarded at conclusion is displayed as a separate linked process.
- **Logic.** Case events are append-only. The Buyer cannot change the original complaint after the Vendor responds but may submit labeled supplemental evidence. Deadline calculations use Asia/Manila time.

**Vendor Store Profile**

- **Design.** The storefront displays verified business identity, address/service area, categories, active listings, fulfillment and payment methods, eligible badges, rating summary, compliance indicators, business hours, Favorite, Message, and Report actions.
- **Flow.** The Buyer may browse eligible products, start a general inquiry, save the Vendor, open directions, or report inaccurate information. Purchasing always begins from a Tier 2 listing, accepted quotation, or formal order request.
- **Logic.** Private business documents, payout data, internal stock, and staff contact information remain hidden. Suspended or inactive stores show an appropriate restriction and block new transactions while preserving existing-order access.

**Invoice Request**

- **Design.** Eligible orders show Vendor, Order ID, completion date, amount, existing invoice files, request status, business-name/TIN fields needed by the Vendor, and secure download actions.
- **Flow.** The Buyer confirms invoice details and submits. The Vendor uploads the BIR-compliant invoice produced by its registered system; the Buyer receives a notification and may request correction with a reason.
- **Logic.** MateryalPH generates only the request and records. It does not label its Purchase Order or payment confirmation as the Vendor's tax invoice. Access remains limited to the Buyer, Vendor, and authorized Admin roles.

**Profile and Settings**

- **Design.** Sections cover personal profile, Buyer type, saved locations, security, signed-in devices, notifications, ranking preferences, privacy requests, agreements, help, and account deletion. Sensitive values are masked until recent authentication.
- **Flow.** Profile edits are validated and audited where material. Email change requires reauthentication and verification; password change revokes other sessions. Privacy requests create trackable cases. Account deletion shows retained-record exceptions before confirmation.
- **Logic.** Ranking preferences have separate Item-Based and Project-Based records. Location and notification permissions may be revoked without disabling manual alternatives. Financial, dispute, tax, fraud-prevention, and security records are retained only under the approved schedule or legal hold.

All pages target WCAG 2.2 Level AA. Controls have accessible names, logical reading and focus order, sufficient contrast, scalable text, and appropriately sized touch targets. Statuses use text and iconography in addition to color. Map actions have list alternatives; charts have summaries or tables; countdowns expose exact times to assistive technologies; validation identifies the field and correction; modal focus is trapped and restored; and motion respects reduced-motion preferences.

---

**Hybrid Procurement Approach**

- **Item-Based Procurement Module**

Item-Based Procurement allows the Buyer to search for a specific material or browse a structured catalog. Only active Tier 2 Vendor inventory within the selected radius can be added to the cart. Catalog browsing defaults to distance; a product search defaults to **Best Deal**, calculated using the Search Relevance Score defined in the System Workflow. The Buyer may instead sort by distance, price, or product rating. A sliders/tune shortcut opens the Buyer's Item-Based ranking preferences and provides **Reset to Default**.

Each result shows the product name, comparable unit price, product rating, units sold, public availability status, Vendor distance, eligible badges, delivery methods, data-freshness timestamp, and price insight when sufficient comparable data exists. Filters include radius, category, variant, brand, availability, fulfillment method, Favorite Supplier, and compliance status.

The Product Details page includes the material description, technical attributes, brand, manufacturer, country of manufacture, unit, variants, product guide where available, Vendor profile, Vendor rating, product rating, public availability, expected fulfillment information, location, route and ETA, product media, and applicable PS/ICC compliance evidence. A compliance badge means that MateryalPH matched or reviewed the submitted evidence; it is not presented as a new government-issued certification.

The Buyer may open a real-time conversation with the Vendor. The selected product is attached as a structured reference. Ordinary chat may clarify stock, specifications, substitution, delivery, or price but does not change a commercial record. The Buyer may also request an Item-Based Order-from-Chat quotation. Only a published, versioned quotation accepted by the Buyer can establish the itemized commercial terms.

The Buyer selects the variant, unit, and quantity and chooses Self-Pickup or Site Delivery where supported. For Site Delivery, the system recommends a suitable Vendor vehicle using product weight, cargo dimensions, distance, vehicle capacity, service coverage, and access restrictions. The initial fee is an estimate until the Vendor confirms the vehicle and any required trips.

The cart may contain items from multiple Vendors. Cart placement does not reserve stock. At submission, the system creates one parent checkout and one child order request per Vendor. Each line receives a price snapshot so later listing-price changes do not modify the pending request.

The canonical Item-Based sequence is:

`Buyer submits order request → Vendor manually or automatically accepts, revises, or rejects → Buyer approves any revision and NRPC, when applicable → Buyer selects payment → Payment is verified or physical-payment method is recorded → Vendor processes → Delivery or pickup → Buyer confirmation → Completed`

An eligible order without NRPC may use Vendor-configured auto-accept. The backend atomically verifies every SKU allotment, available stock, unit or peso limit, Vendor state, fulfillment method, and complete child order. If all checks succeed, the order is accepted and inventory is hard-reserved; otherwise the whole Vendor child order goes to manual review. Project-Based orders and any order with NRPC always require manual Vendor review.

The Vendor has 24 hours to respond. A confirmed quantity is reserved. A rejection releases no stock and does not receive an automatic major penalty; repeated inaccurate availability affects the applicable operational metric. If only part of an order is available, the Vendor proposes revised quantities and totals. The Buyer must explicitly accept before payment. If the Buyer rejects or does not accept before expiry, the reservation is released.

For Site Delivery, the Vendor confirms the suggested vehicle, number of trips, final delivery fee, access feasibility, and expected fulfillment date before payment. For Self-Pickup, the Vendor confirms the expected ready-for-pickup date.

At checkout, available payment methods are determined per child order:

- **Online Payment:** available for either fulfillment method and processed through the applicable Vendor's Xendit sub-account.
- **Cash on Delivery:** available only for Site Delivery when enabled by the Vendor.
- **In-Store Payment:** available only for Self-Pickup when enabled by the Vendor.

Online checkout displays Materials Subtotal, Delivery Fee, any NRPC designated within the order value, Payment Processing Fee, and Total. The Buyer pays the disclosed processing fee. It is not labeled “Xendit deduction.” The payment is not treated as successful until the backend receives a verified Xendit event. MateryalPH does not operate a wallet or claim to hold the payment in escrow. An auto-accepted online order and any NRPC assurance payment expire after 45 minutes; the exact expiry and countdown remain visible.

The system generates a Purchase Order and itemized order record only after Vendor confirmation and Buyer acceptance of the final amount. MateryalPH may generate a payment confirmation, but the Vendor remains responsible for the BIR-compliant invoice.

- **Project-Based Procurement Module**

Project-Based Procurement allows the Buyer to plan materials under construction projects and work packages. It uses active Tier 2 Vendor listings to compile time-limited estimates. From the compiled result list, the Buyer may independently message any displayed Vendor and request a versioned quotation through the shared Order-from-Chat engine. This is not a broadcast RFQ queue: Vendors receive an inquiry only when the Buyer opens their conversation. One Work Package may ultimately be assigned to only one Vendor. Any missing material is sourced through Item-Based Procurement and linked to the same Work Package.

## 1. Project Setup

The Buyer creates a Procurement Project and provides:

- **Project name** — the Buyer's project identifier.
- **Project-site location** — selected from saved locations, manual address, or map pin and used for discovery and distance.
- **Project timeline** — planned start and end dates.
- **Overall project budget** — the financial planning ceiling across work packages.

A new project is `ACTIVE`. The Buyer may update or delete it while no work package has a selected or confirmed Vendor. Once procurement records exist, the project may be completed or archived but not physically deleted. Project statuses are `ACTIVE`, `COMPLETED`, and `ARCHIVED`.

## 2. Work Package Management

A work package represents a phase or trade scope and contains:

- Phase name and description.
- Allocated phase budget.
- Required material lines with name, technical specification, optional preferred brand, normalized unit, and quantity.
- Site Delivery or Self-Pickup preference.
- Online Payment, COD, or In-Store Payment preference, subject to Vendor support.
- Required site contact and essential accessibility information for Site Delivery, including heavy-vehicle restriction and entrance instructions where applicable.

### Work Package Lifecycle

| **Status** | **Description** |
| --- | --- |
| `DRAFT` | Editable and deletable; Vendor scanning has not started |
| `ACTIVE` | Original materials and terms are locked; system estimates and requested Vendor quotations may be compared |
| `QUOTATION_INQUIRY` | At least one selected Vendor is preparing or has published a quotation; the locked original remains unchanged |
| `VENDOR_SELECTED` | Buyer selected one Vendor; confirmation is pending |
| `AWAITING_PAYMENT` | Vendor confirmed availability, fulfillment date, and final delivery details |
| `IN_PROGRESS` | Payment was verified or physical-payment method recorded; order is being fulfilled |
| `COMPLETED` | Linked order is completed and missing-item records are fulfilled or explicitly waived by the Buyer |
| `CANCELLED` | Work package was closed according to the cancellation rules |

An Active package cannot be overwritten. Before selecting a Vendor or accepting a quotation, the Buyer may return it to Draft, which invalidates its estimates and expires active quotation requests after confirmation. After selection, a correction requires cancellation and a new version so that the prior evidence remains auditable.

## 3. Automated Vendor Scanning and Estimate Generation

Activation scans active Tier 2 inventory within the selected radius. The system compares normalized material specifications, quantities, availability, delivery coverage, project-site access, and Vendor capability. It creates a system-compiled estimate using current listing-price snapshots and an estimated delivery fee.

The system aims for a complete one-Vendor package. Incomplete matches may be displayed with exact missing lines and a fulfillment percentage. Missing items are never silently substituted and must be acquired through linked Item-Based orders.

### Vendor Discovery Fallback Logic

If fewer than three eligible Tier 2 Vendors are found, the application offers the next radius—`5`, `10`, `20`, `30`, `40`, or `50 km`—and expands only after Buyer confirmation. Favorite Suppliers within the selected radius may be highlighted. At the 50-km limit, Tier 1 Suppliers may be shown only as off-platform contact references; they cannot receive the work package through MateryalPH.

### Estimate Validity

Each system-compiled estimate remains valid for 48 hours. Expiration invalidates its price and availability snapshot. The Buyer must refresh the scan before direct selection. A system estimate is never rewritten by chat or a Vendor quotation and remains labeled as a system-compiled baseline.

## 4. Vendor Comparison and Selection

The comparison shows:

- Fulfillment Match Score.
- Fulfillment percentage and missing lines.
- Item subtotal, estimated delivery fee, and projected total.
- Vendor-confirmed or preliminary lead-time information.
- Distance and ETA.
- Payment and fulfillment methods.
- Vendor badges and performance indicators.
- **Under Budget**, **Within Budget**, or **Over Budget** label.

The tune shortcut opens Project-Based ranking preferences. The Buyer may reset weights to platform defaults. Personalized weighting is clearly indicated.

The Buyer may message each Vendor in the compiled result list. The system auto-attaches two Work Package records to each inquiry: the Buyer's locked, read-only original and a Vendor-editable duplicate. The Vendor uses the duplicate to propose product matches, substitutions, quantity or specification changes, unit prices, delivery terms, payment method, expected fulfillment date, and NRPC. Each published version shows an exact expiry and a plain change summary comparing every modified field with the original.

The Buyer may accept the current version, reject it, or send a counter-offer. The default Buyer-response deadline is 24 hours and the Vendor may select 1–72 hours. Editing a published quotation creates a new version, invalidates the prior version, resets the displayed deadline, and requires a new Buyer review. Rejection, counter-offer, withdrawal, or expiry releases the quotation's soft holds. Acceptance performs an atomic stock check before creating hard reservations and proceeding to checkout.

If the Buyer selects a Vendor directly from the system estimate instead, the Buyer may leave an optional **Note**. The Note is informational, becomes part of the package request, and does not require Vendor action. Direct selection creates a package order request; it is not a completed award until the Vendor manually confirms availability, fulfillment date, vehicle or trip requirement, final total, and any NRPC.

Accepting one Vendor quotation or completing one direct Vendor selection assigns the Work Package to that Vendor and expires other active quotations for the package. Their conversation histories remain available. The selected Vendor is the only Project-Based Vendor for that Work Package.

## 5. Checkout and Payment Processing

### Delivery Fee Calculation

For Site Delivery, the system recommends the most suitable configured vehicle. If the load exceeds one vehicle or trip, the Vendor confirms the number of vehicles or trips before the final delivery fee is presented. The final fee uses the Vendor's base fee, per-kilometer rate, route distance, confirmed trips, capacity, and documented access restrictions.

### Payment Processing

After Vendor confirmation, the Buyer reviews the final itemized amount and selects an available method. Online payment is routed for the Vendor's Xendit sub-account. COD is restricted to Site Delivery and In-Store Payment to Self-Pickup. Physical methods appear only when enabled by the selected Vendor.

The online-payment breakdown separately displays the Payment Processing Fee. Supported channels are taken from the actual Xendit configuration. A channel without an approved refund route is not enabled unless the workflow clearly discloses and records the Vendor-managed refund method.

The Buyer accepts the current Terms version, cancellation and refund conditions, fulfillment commitment, processing-fee treatment, Work Package scope, latest quotation version where applicable, and any NRPC Terms before payment. Acceptance is versioned and timestamped. For COD or In-Store Payment with NRPC, the Buyer pays the accepted NRPC online within 45 minutes; that amount is credited against the later physical-payment balance.

## 6. Purchase Order Generation and Vendor Confirmation

The system creates the Purchase Order after the Vendor confirms and the Buyer accepts the final package. It contains:

- Material lines, specifications, quantities, units, and price snapshots.
- Missing items identified for separate sourcing.
- Confirmed fulfillment date.
- Confirmed delivery vehicle or trip count and delivery fee, where applicable.
- Total amount and Payment Processing Fee, where applicable.
- NRPC amount, reason, affected lines, accepted Terms version, and assurance-payment credit, where applicable.
- Fulfillment and payment methods.
- Project and work-package references.
- Source system-estimate or accepted quotation version and its change summary.
- Buyer, Vendor, and acceptance timestamps.

If the Vendor rejects or does not respond within 24 hours, the request expires, reservations are released, and the Buyer may refresh the three highest eligible alternatives by FMS. A single pre-confirmation rejection receives no fixed point deduction. Repeated non-response or inaccurate stock contributes only to the defined CRR or NFR rules.

## 7. Order Fulfillment and Milestone Tracking

The Vendor supplies an expected fulfillment date appropriate to the material and order. The former fixed “three days plus two days” rule is removed. A missed date creates a late milestone and notification but does not automatically cancel a paid order without a safe refund or dispute path.

For Site Delivery, fulfillment proof requires a delivery photo, timestamp, receiver name, and optional signature. For Self-Pickup, it requires handover confirmation, timestamp, and Buyer or authorized-receiver confirmation. Real-time GPS tracking is outside the capstone scope.

The Buyer receives in-app and push milestones and important email notices. No routine milestone SMS is sent. After `DELIVERED` or `PICKED_UP`, the Buyer has two calendar days to confirm receipt or report an issue. Reminders are sent before automatic confirmation. An open dispute pauses automatic confirmation.

For a Self-Pickup no-show, reminders are sent during the confirmed pickup window. After 48 hours from `READY_FOR_PICKUP`, the Vendor may request cancellation or rescheduling. Repeated confirmed no-shows are referred for Admin review and never cause automatic suspension solely because a fixed count was reached.

Material traceability fields are required only when applicable to the category, certification, batch-controlled product, or Vendor's invoice obligations. They are not mandatory for every material.

## 8. Budget Monitoring Dashboard

### Project-Level View

| **Metric** | **Description** |
| --- | --- |
| Total Approved Budget | Buyer-defined project ceiling |
| Allocated to Work Packages | Sum of active work-package budgets |
| Unallocated Reserve | Project budget less allocations |
| Committed Spend | Confirmed Purchase Orders not canceled or refunded |
| Pending Spend | Confirmed orders not yet completed |
| Actual Spend | Completed orders after refund adjustments |
| Remaining Balance | Budget less committed and actual applicable spend |
| Budget Utilization | Percentage of budget committed or spent |

### Work Package-Level View

The work-package view adds planned versus current cost, confirmed missing-item cost, linked Item-Based orders, pending Vendor-confirmation count, refund adjustments, and override history.

### Budget Alert System

At 90% utilization, the system sends an early warning. When a new order would exceed 100%, checkout pauses and requires an explicit **Budget Override** with a written reason. The Buyer may continue after acknowledgment; the resulting deficit, user, amount, reason, and timestamp are retained for audit. Budget warnings do not alter or cancel an order automatically.

## 9. Post-Fulfillment

After completion, the Buyer may rate the Vendor and purchased products for 14 calendar days. Ratings remain hidden until both parties submit or the window expires and may be corrected within 24 hours of submission. The Buyer may add the Vendor as a **Favorite Supplier**. Trusted Supplier remains a system-awarded badge.

A return or dispute may be filed within seven calendar days after completion for an eligible wrong, defective, incomplete, misleading, late, missing, payment, or fulfillment issue. Evidence is attached to the case. A rating connected to an active case may be withheld until resolution.

The Buyer may request a Vendor invoice from an eligible completed order. MateryalPH records the request and allows the Vendor to upload the BIR-compliant PDF produced by its registered invoicing system. MateryalPH's Purchase Order and payment confirmation are not tax invoices. The configured service target is three business days after the request and does not replace any earlier legal invoicing obligation of the Vendor.

When all work packages are resolved, the Buyer may mark the project Completed and export a Procurement Summary Report containing budgets, Purchase Orders, Vendor records, fulfillment states, invoice references, refunds, and override history.

## 10. Relationship to the Item-Based Procurement Module

- Missing Project-Based lines may be sourced through Item-Based orders and linked back to the originating work package.
- Both modules use the same versioned Order-from-Chat engine, confirmation-before-payment rule, payment methods, inventory reservations, delivery calculation, NRPC controls, Purchase Order model, milestone states, cancellation refunds, dispute-conclusion refunds, and ratings.
- Project-Based selection remains one Vendor per work package; linked Item-Based purchases do not become split Project-Based awards.
- Ratings from both modules contribute to the same eligible Vendor and product score calculations.

---

- **Order Fulfillment, Cancellation, Return, and Tracking**

The shared milestone sequence is:

`Awaiting Vendor Confirmation → Awaiting Buyer Approval or NRPC Acceptance, when applicable → Awaiting Payment → Confirmed → Processing → Ready for Pickup or Out for Delivery → Delivered or Picked Up → Completed`

The system controls request, payment, and verified-payment transitions. Authorized Vendor users control preparation and fulfillment milestones. Every change records actor, role, previous state, new state, timestamp, and evidence reference.

The Buyer may withdraw an order before Vendor confirmation. From `CONFIRMED` through `PROCESSING`, the Buyer may submit a cancellation request with a valid reason. The request records `CANCELLATION_REQUESTED` until the applicable automatic rule, Vendor response, or Admin review produces a final decision. Cancellation is not permitted once the order reaches `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`. Report a Problem, dispute, return, warranty, and non-waivable statutory remedies remain available.

MateryalPH charges no standard cancellation fee. NRPC is a Vendor-determined portion of the existing order value for actual irreversible preparation and has no platform-wide numeric cap. The Vendor must enter the amount, reason, affected lines, and applicable preparation description before Buyer payment or preparation. It is disabled by default, requires manual review, and the Buyer must explicitly accept the versioned NRPC Terms. The Buyer may flag a disproportionate amount for Admin review without automatically blocking an accepted order.

For online payment, NRPC is tagged within the paid total. For COD or In-Store Payment, NRPC is paid online within 45 minutes and credited against the physical-payment balance. When an eligible Buyer cancellation becomes final during `PROCESSING`, the accepted NRPC may be retained only when the Vendor substantiates the preparation. Vendor cancellation forfeits NRPC and results in a full refund of Buyer-paid order amounts. NRPC cannot reduce a remedy for defective, incorrect, unsafe, misrepresented, or otherwise nonconforming goods or Vendor fault.

Refunds follow two independent paths. A finalized cancellation of an already-paid order automatically initiates an idempotent **Cancellation Refund**. A dispute remains `DISPUTE_OPEN`; only a concluded decision awarding money initiates a **Dispute-Conclusion Refund**. Both return funds to the original payment method where supported, record `REFUND_PENDING`, and wait for the verified Xendit refund webhook before recording `PARTIALLY_REFUNDED`, `REFUNDED`, or `REFUND_FAILED`. A failed or expired payment for which no funds were captured requires no refund. If reconciliation proves capture after a failed application flow, the system creates a compensating refund.

When the Buyer prevails because of Vendor fault, the intended remedy makes the Buyer whole, including the accepted NRPC and disclosed processing fee, subject to the technically supported route. For a Buyer-requested cancellation without Vendor fault, a nonreturnable payment-processing fee may be excluded only if clearly disclosed and legally permitted. The Buyer sees the masked original payment method, refund amount, reason, reference, state, and channel-dependent arrival information. The interface never asks the Buyer to redirect a Xendit refund to another destination. Admins never manually hold or disburse funds.

---

**Price Monitoring Implementation in the System**

The **Price Trend Insight** records normalized active listing-price snapshots and completed transaction prices, including completed orders originating from accepted chat quotations, with Vendor, unit, variant, selected radius, and timestamp. Draft, rejected, expired, withdrawn, or otherwise unaccepted quotation prices are excluded because they are not completed market transactions. The system calculates 7-day and 30-day comparable averages and identifies current prices as below, within, or above the defined comparison band. It displays increasing, decreasing, or stable direction only when sufficient comparable observations exist; otherwise it shows **Insufficient Local Data**.

Comparisons must normalize unit and variant, exclude canceled or test transactions, and avoid representing the result as an official market price. Historical changes remain auditable and do not rewrite past Purchase Orders.

---

**Construction Procurement Budget Monitoring System**

The Budget Monitoring Module combines Project-Based and linked Item-Based procurement. It displays Approved Budget, Committed Spend, Pending Spend, Actual Spend, Refund Adjustments, and Remaining Balance per project and work package. Available balance accounts for confirmed but incomplete orders so that pending procurement is not ignored.

1. **Multi-Project Overview Dashboard:** The individual Buyer sees all projects owned by the account, including total budget, committed and actual spend, remaining balance, and project status. Buyer Team Accounts are not implied.
2. **Budget Report Export:** The Buyer may export PDF or CSV reports containing work-package budgets, Vendor names, order amounts, Purchase Order references, payment and delivery states, refunds, remaining balance, and Budget Override records.

---

**Supplier Preference and Favorites Feature**

The Buyer may mark a Tier 2 Vendor as a **Favorite Supplier** from Product Details, Vendor Store Profile, Messages, or Post-Fulfillment. Favorites may be organized by project or phase and display the Buyer's own transaction history, prior fulfillment experience, and current serviceability.

Favorites receive a visible indicator, dedicated filter, and optional **Favorites First** sort. They do not silently override SRS or FMS when Best Deal ranking is selected. A Favorite outside the current radius or without active matching inventory is not promoted as eligible. Removing a Favorite does not delete transaction or audit records.

---

**Dispute Workflow for Buyers**

The Buyer selects an eligible order and completes the structured Refund/Dispute Request Form. The Buyer chooses an issue type, identifies affected lines, describes the requested remedy, enters a requested amount when partial, and attaches available photos, video, delivery evidence, chat reference, invoice, or other supporting material. The form displays the original masked payment method for information but never collects a different refund destination. Submission creates a Case ID and `DISPUTE_OPEN`, not a refund, and notifies the Vendor.

- Vendor response: 48 calendar hours.
- Mutual-resolution period: 72 calendar hours after a response, or immediate escalation after no response.
- Admin clarification request: 24 calendar hours for each requested party.
- Appeal: one appeal within five business days and only with new relevant evidence.

Possible outcomes include Dismissed, Replacement, Full Refund, Partial Refund, Warning, Score Adjustment through the applicable metric, Temporary Restriction, Suspension, or Permanent Ban. A concluded Full Refund or Partial Refund decision initiates the separate Dispute-Conclusion Refund and links it to the Case ID. All deadlines use Asia/Manila time and are shown in the interface. The Buyer can view the case state, evidence history, messages, decision reason, refund state, expected arrival information, and appeal state.

---

### Future Enhancements

Buyer organization team accounts, live GPS delivery tracking, machine-learning recommendations, vouchers, and procurement beyond the 50-km platform radius are outside the current capstone scope.
