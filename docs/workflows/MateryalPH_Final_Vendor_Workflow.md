**Vendor Flow**

---

**Vendor Portal (Web Application using React.js)**

MateryalPH provides a dedicated **web-based Vendor Portal** developed using React.js. It is separate from the Buyer mobile application and Admin Portal and supports Vendor account management, onboarding, verification, storefront management, product compliance, inventory, orders, fulfillment, payment records, staff management, messages, disputes, and analytics.

The System Workflow is the authoritative source for shared security, state, scoring, payment, privacy, accessibility, audit, and integration rules. This Vendor Workflow defines Vendor-facing processes, permissions, and responsibilities.

The Vendor website includes a public landing page for supplier recruitment. The page explains the available Buyer audience, onboarding requirements, marketplace functions, zero-commission policy, third-party payment fees, and applicable limitations without guaranteeing sales or revenue.

- **Key Focus:** Marketplace purpose, eligibility, verification, setup, fees, fulfillment responsibilities, privacy, and Vendor obligations.
- **Call to Action:** **Create Vendor Account** or **Sign In**, leading to the Vendor Portal authentication page.

Existing Vendor users select **Sign In**. A business that is not yet registered selects **Sign Up** and creates the Vendor Owner account before onboarding.

---

**Vendor User Types**

- **Vendor Owner (Main Vendor Store Account)**

The Vendor Owner is the highest-authority account in the Vendor organization. The Owner controls legal-business information, Xendit onboarding and payout configuration, staff delegation, security, storefront settings, compliance, PS/ICC submissions, listings, inventory, orders, fulfillment, messages, disputes, and reports. If the Vendor has no staff accounts, all permitted store functions remain available to the Owner.

### **Vendor Team Account**

A Vendor Team Account belongs to one employee and is connected to the existing Vendor organization through a membership record. It does not create a separate store. Each employee uses an individual login identity, receives exactly one fixed role, and maintains an independent audit history.

The fixed roles are:

1. **Store Manager (Delegate Role)**
2. **Store Staff**
3. **Customer Service Staff**
4. **Inventory Staff**
5. **Fulfillment Staff**

Roles cannot be stacked, customized, or combined. Small stores may use Store Staff when one employee performs both customer-service and inventory functions. Vendor Sales Staff, Vendor Compliance Staff, and Vendor Custom Roles are not part of the final capstone model.

### **Pending or Restricted Account**

A Vendor user whose account, organization, onboarding, compliance, or marketplace status is pending or restricted receives only the functions permitted by that status. The Laravel backend checks account status, organization membership, role, and resource access on every protected request. Interface hiding is not treated as security enforcement.

---

**Vendor Sign-in and Sign-up**

# 1. Vendor Sign-in

The Vendor Owner and all Team Accounts use the same Vendor Sign-in page. After authentication, the backend resolves the user's organization, fixed role, delegated flags, account status, and permitted functions.

The supported methods are:

- **Email and Password**

The system validates the submitted email and password through HTTPS, input validation, risk-based bot protection, and account-aware rate limiting. A maximum of five failed attempts within 15 minutes triggers temporary throttling. The backend confirms that the email is verified, the password matches its adaptive hash, the membership remains active, and neither the user nor Vendor organization is suspended, deactivated, or banned.

The response remains generic when more detail could reveal whether an account exists. Passwords are never stored in plain text or reversible form.

- **Sign in with Google**

Google sign-in uses the OpenID Connect Authorization Code flow with PKCE. MateryalPH validates signature, issuer, audience, expiration, nonce, state, and `email_verified`, and uses Google's stable `sub` claim as the linked identity. A valid Google sign-in does not require a duplicate email OTP. An unlinked Google identity is directed to registration or the authorized staff-invitation process and never creates an active Vendor automatically.

**Privileged Verification**

The Vendor Owner and Store Manager must enroll an authenticator-app TOTP before using privileged functions. TOTP is required for a fresh privileged session and recent reauthentication is required for staff delegation, security changes, legal-business changes, payout configuration, and account deletion. Email OTP remains available for email verification, recovery, and risk-based step-up; it is not labeled strong MFA. MateryalPH sends no SMS OTP.

# Vendor Team Account Sign-in

After successful authentication, the system identifies:

- Vendor organization.
- User account and membership.
- Fixed role.
- Store Manager staff-management delegation, if applicable.
- Account and organization statuses.
- Required security step-up.

A Team Account sees only the sections and records permitted by its role. An employee cannot create another Vendor organization, assume ownership, or access another Vendor's information.

## 1.1 Forgot Password

The user submits an email address and receives a generic response. If the account is eligible, the system sends a unique, time-limited, single-use reset link or OTP. Reset requests are rate-limited and older active recovery credentials are invalidated when a newer reset is completed.

After a successful reset, the system invalidates the recovery credential, revokes active sessions and refresh tokens, records the event, and sends a security confirmation. An expired or used credential cannot change the password. Privileged accounts must complete their enrolled TOTP or an approved recovery process.

# 1.3 Authentication and Session Management

The Vendor Portal uses the shared JWT architecture. Short-lived access tokens and rotated refresh tokens are transmitted through `Secure`, `HttpOnly` cookies with CSRF protection and an appropriate `SameSite` policy. Tokens are not stored in browser local storage.

Sessions are revoked after logout, password reset, password change, email change, factor recovery, account suspension, membership deactivation, or organization ban. After authentication, the system evaluates account status, Vendor organization, role, delegation flags, email verification, business verification, onboarding, marketplace activation, and required reauthentication.

# 1.4 Authentication and Security Audit Trail

The system records significant events, including account creation, successful and failed login, Google authentication, password recovery, email verification, TOTP enrollment and recovery, credential changes, staff invitation and role changes, suspension, deactivation, and sensitive configuration actions. Each record contains the actor, organization, action, affected resource, previous and new value where appropriate, timestamp, result, device or correlation reference, and reason. Secrets and OTP values are excluded.

---

# 2. Vendor Sign-up and Registration

Registration creates a restricted Vendor Owner account and Vendor organization. It does not approve the business for marketplace participation. The sequence is:

`Account Creation → Email Verification → Required Information and Agreement Acceptance → Active Portal Account → Vendor Onboarding → Marketplace Activation`

# 2.1 Account Creation

The Vendor may use:

- **Sign Up with Google.** After valid Google authentication, the verified email is recorded and no second email OTP is required. The Owner completes the missing required fields and agreements.
- **Sign Up with Email and Password.** The Owner provides name, business or store name, email, mobile number, password and confirmation, and required agreement acknowledgments. The system sends a six-digit, short-lived, single-use email OTP. The account remains `PENDING_VERIFICATION` until the email is verified.

Registration applies HTTPS, CSRF protection where applicable, server-side validation, rate limiting, duplicate-account prevention, bot protection, secure password hashing, and generic responses. One email address cannot create multiple MateryalPH account types in the current capstone.

### 2.2 Email and Mobile Number Registration

For Google Sign-Up, a valid `email_verified` claim sets **Email Verification Status: Verified**. For email/password sign-up, the email OTP expires, is single-use, is replaced by a newer code, and is subject to resend and attempt limits.

The Vendor Owner must provide a valid Philippine mobile or telephone number for legitimate administrative, order, and delivery coordination. The number is normalized where applicable and masked in the interface. It is a contact field only and is not verified through SMS. A change to the registered contact number requires recent authentication, confirmation, notification, and audit logging, but no SMS provider is used.

## 2.3 Agreement and Policy Acceptance

Before onboarding, the Vendor Owner accepts the applicable Vendor Terms of Service and Vendor Code of Conduct. The system stores agreement type, version, organization, accepting user, timestamp, and source. A Privacy Notice is presented separately and identifies the purpose, lawful basis, collected information, recipients, retention basis, rights, and contact process. An NDA is used only for a separately identified business need.

### 2.4 Verification Completion

The account-verification stage is complete when:

- Email is verified.
- Required contact information is recorded.
- Required Terms and Code of Conduct are accepted.
- Privacy Notice acknowledgment is recorded.

The system creates the Vendor organization and Owner membership with:

- **Account Status:** `ACTIVE`
- **Onboarding Status:** `NOT_STARTED`
- **Marketplace Status:** `NOT_ACTIVE`

The Owner may enter the Vendor Portal and complete onboarding but cannot receive marketplace orders until activation.

### Verification Security Controls

Verification uses HTTPS, secure OIDC handling, adaptive password hashing, expiring single-use email codes, request and attempt limits, server-side validation, enumeration-resistant responses, session security, TOTP for privileged functions, and immutable security-event logging. Google passwords, plaintext OTPs, access tokens, and recovery codes are never stored in logs.

---

## Vendor Onboarding

Onboarding collects the legal, operational, compliance, storefront, fulfillment, and payment information required for activation. The checklist displays `REQUIRED`, `OPTIONAL`, `COMPLETE`, `PENDING_VERIFICATION`, `CHANGES_REQUIRED`, and `APPROVED`. Progress may be saved. Dependencies are enforced by the backend.

**1. Business Information and Document Verification**

Business Information is separated from the public Store Profile and includes:

- **Business or Store Name.** The verified public store name.
- **Date of Establishment.**
- **Primary Business Contact.** A Vendor may add multiple contacts. Each includes full name, position or title, professional or personal email, telephone or mobile number, and an authorized-representative flag.
- **Registered Business Address.** Street or building, barangay, city or municipality, province, postal code, latitude, and longitude. The Owner may enter the address or place a map pin. The location is validated before it is used for discovery, distance, service coverage, or delivery fees.
- **Supplier Type or Classification.** Wholesaler/Distributor, Retail Hardware Store, or Specialized Supplier. A Vendor may select multiple applicable niches, including Construction Materials, Electrical Supplies, Plumbing and Sanitary, Tools and Equipment, Finishing Materials, Fasteners and Hardware, or a reviewed Other category. Construction-vehicle rental is excluded.
- **Business Type.** Sole Proprietorship, Partnership, or Corporation.

**Business and Compliance Verification**

| **Business Type** | **Required registration evidence** |
| --- | --- |
| Sole Proprietorship | DTI Business Name Registration |
| Partnership | Applicable SEC registration |
| Corporation | Applicable SEC registration |

All Vendors also submit the applicable LGU Business Permit, BIR Certificate of Registration, TIN information, declared VAT status, and other required regulatory evidence. Additional ISO or industry certifications are optional unless a product or law makes them mandatory.

The Vendor supplies the document and entered metadata. An authorized Admin verifies the document number, issue date, expiration date or `NOT_APPLICABLE`, decision, remarks, and review source. Vendor-entered dates are not treated as final verified dates. Every document may be `PENDING_VERIFICATION`, `APPROVED`, `RETURNED_FOR_CORRECTION`, `REJECTED`, or `EXPIRED`.

An Admin must provide a reason for rejection or return. The previous approved document may remain effective while a replacement is reviewed unless it has expired or evidence requires immediate restriction. Expiration monitoring uses the Admin-verified date and notifies the Vendor before expiry. A critical verified field change reopens review and creates an audit record.

### Privacy Notice

The collection screen presents the applicable Privacy Notice before personal or document information is submitted. The system minimizes public exposure, limits document access to authorized users, uses private storage and expiring links, and records the applicable acknowledgment or lawful consent separately from commercial Terms.

**2. Business Store Profile Setup**

The public profile contains:

- Business logo or profile image.
- Verified store name.
- Store banner.
- Store description.
- Approved promotional images and optional video.
- Public business contact and operating information selected by the Owner.

Media is validated for type, size, safety, accuracy, intellectual-property compliance, and accessibility metadata. Legal documents, personal staff details, private contacts, TIN, payout information, and authentication data are never displayed publicly.

## 3. Fulfillment Configuration

## Bulk Order Capability

| **Declared capability** | **Eligibility** |
| --- | --- |
| Can accommodate bulk orders | Item-Based and Project-Based Procurement |
| Cannot accommodate bulk orders | Item-Based Procurement only |

Bulk capability affects Project-Based matching but does not create a Vendor RFQ bidding queue.

**Services Capability**

- Self-Pickup.
- Vendor Delivery.
- Both.

If Vendor Delivery is enabled, Delivery Configuration is mandatory. Physical payment methods are separately configurable: COD may be enabled for Site Delivery and In-Store Payment for Self-Pickup. Online Xendit onboarding remains mandatory regardless of these optional methods.

## 4. Delivery Configuration

The Vendor records vehicles it actually operates. Categories include Motorcycle, Pickup, Van, Truck, and Custom Vehicle Type. Truck subtypes may include Open Truck, Flatbed Truck, and Wing Van.

| **Field** | **Description** |
| --- | --- |
| Vehicle image | Operational reference shown only where relevant |
| Number available | Positive integer representing currently usable vehicles |
| Capacity per vehicle | Maximum payload in kilograms |
| Cargo length, width, and height | Usable cargo dimensions |
| Heavy-vehicle classification | Used with site-access restrictions |
| Base fee | Fixed charge per confirmed trip |
| Per-kilometer rate | Distance-based charge |
| Maximum delivery distance | Service limit for that vehicle |

The system recommends a suitable vehicle; it does not dispatch automatically. The Vendor confirms or changes the recommendation and confirms any multiple vehicles or trips before the Buyer pays the final delivery fee. Existing order snapshots are not changed when a vehicle configuration is later edited or removed.

## 5. Payment Configuration (Using Xendit Activation)

Every Vendor must complete **Xendit xenPlatform sub-account onboarding** before marketplace activation. MateryalPH stores only the required account identifier, capabilities, connection status, and reconciliation references. Payment credentials and secret keys remain with Xendit or protected server configuration.

MateryalPH charges zero marketplace commission. The Buyer pays the separately disclosed Payment Processing Fee, subject to the active Xendit agreement and applicable law. The Vendor can review MateryalPH transaction records and use the Xendit dashboard for balances and withdrawals. MateryalPH has no internal Vendor wallet and does not claim to hold funds in escrow.

Enabled payment channels come from the actual Xendit environment. Each channel must have documented limits, expiry, settlement, and refund capability. A channel without native refund support remains disabled unless an approved Vendor-managed refund process is implemented and disclosed. Online full-order payments and NRPC assurance payments for COD or In-Store Payment use separate payment purposes and references. An NRPC assurance payment expires after 45 minutes and is credited against the remaining physical-payment balance; it is not an additional charge.

## 6. Vendor Team Account Management

Team setup is optional for activation. The Owner may add staff after onboarding. Every invitation identifies the employee, email, contact number where required, exactly one fixed role, organization, expiry, and inviting actor. The employee accepts through an individual account and never receives the Owner's credentials.

When the Owner creates or edits a Store Manager, the system presents an off-by-default toggle: **Allow this Store Manager to manage staff accounts**. A delegated Store Manager may manage only Store Staff, Customer Service Staff, Inventory Staff, and Fulfillment Staff. The Manager cannot create or manage another Store Manager, change the Owner, grant delegation, change their own access, edit payout credentials, or delete audit records. The Owner is notified of every delegated staff-management action.

### Vendor Activation Requirements

A Vendor is eligible for marketplace activation only when every mandatory item has a successful final status:

1. Email verified and required agreements accepted.
2. Business Information complete and validated.
3. Required DTI or SEC, LGU, BIR, TIN, and applicable regulatory evidence approved.
4. Public Store Profile complete.
5. Supplier and Bulk Order capability recorded.
6. Fulfillment method configured.
7. Delivery Configuration complete when Vendor Delivery is enabled.
8. Xendit xenPlatform onboarding connected and required capabilities active.
9. At least one publishable product listing exists; an applicable regulated listing must pass the required PS/ICC workflow before publication.
10. No unresolved mandatory correction, rejected requirement, expired blocking document, suspension, or activation hold exists.

Team Accounts are optional and do not block activation. Activation and every later restriction are recorded with actor, rule result, timestamp, and reason.

---

**Vendor Marketplace Operations**

After activation, authorized users manage the store according to their fixed roles. Sensitive business, compliance, security, payment, or fulfillment-configuration changes may require recent authentication and administrative reverification. Existing obligations remain visible during a restriction when needed to complete orders, respond to disputes, or preserve evidence.

---

**Vendor Digital Storefront**

Tier 2 Vendors receive a digital storefront with active listings, public availability, service coverage, fulfillment methods, declared payment methods, verified compliance indicators, public ratings, and earned badges. Internal quantities, legal documents, private contacts, payment credentials, and employee account information are excluded.

**Dashboard Panel Overview**

**Performance Indicators** show CRR, order-processing time, Vendor-caused cancellation rate, return rate, on-time rate, and score eligibility. **Action Items and Alerts** show manual confirmation requests, auto-accept pauses, quotation and counter-offer deadlines, NRPC acceptance or flags, fulfillment tasks, inventory confirmation, compliance corrections, invoice requests, cancellation refunds, dispute-conclusion refunds, and system notices. **Detailed Panels** show gross sales records, order volume, storefront traffic, disputes, and product quality without presenting MateryalPH reports as official tax accounting.

**Navigation Topbar**

- Current page and Asia/Manila system date.
- Notifications.
- Accessible light or dark theme.
- Personal account and security settings.
- Sign Out.

Email changes require verification, notice to the previous email, session revocation, and audit. Vendor Owner and Store Manager security settings include TOTP and recovery-code management. Theme and notification preferences are per user, not per organization.

**Navigation Sidebar**

- **Store Operation**

  - **Orders**

**Flow**

1. An authorized user opens a combined Item-Based and Project-Based order list and filters by procurement type, state, date, Buyer, or Order ID.
2. A new request opens with Buyer information, CCS when eligible, line items, price snapshots, quantities, inventory, fulfillment preference, site details, payment preference, and project reference where applicable.
3. Within 24 hours, the Vendor confirms, rejects with a reason, proposes a permitted revision, or—only for an eligible Item-Based order without NRPC—allows the configured auto-accept transaction to confirm it.
4. Manual or automatic confirmation hard-reserves inventory and records the expected fulfillment or pickup date. For delivery, the Vendor confirms the vehicle, trip count, access feasibility, and final delivery fee.
5. A revision or NRPC proposal moves the request to Buyer approval. No payment or preparation may start until the Buyer accepts the latest commercial version and any NRPC Terms.
6. After full online payment is verified, an NRPC assurance payment is verified for COD or In-Store Payment, or an approved physical-payment method without NRPC is recorded, the order becomes `CONFIRMED` and may enter `PROCESSING`.
7. Fulfillment milestones update the shared order timeline. Physical quantity on hand is reduced only when the reserved stock is fulfilled, not when it is reserved.
8. A return, cancellation, cancellation refund, dispute, dispute-conclusion refund, invoice request, or rating remains linked to the same immutable order and line-item snapshots.

**Logic**

Order status follows the System Workflow: `AWAITING_VENDOR_CONFIRMATION`, `AWAITING_BUYER_APPROVAL`, `AWAITING_NRPC_ACCEPTANCE`, `AWAITING_PAYMENT`, `CONFIRMED`, `PROCESSING`, `READY_FOR_PICKUP`, `OUT_FOR_DELIVERY`, `DELIVERED`, `PICKED_UP`, `COMPLETED`, `CANCELLATION_REQUESTED`, `DECLINED`, `EXPIRED`, `CANCELLED`, and `DISPUTED`. Payment, refund, quotation, and dispute states remain separate.

Every line stores listing, variant, normalized unit, confirmed quantity, unit price snapshot, subtotal, applicable compliance reference, and inventory reservation. Listing-price changes never rewrite an order snapshot. Buyer-facing public stock status does not replace internal quantity validation.

MateryalPH does not calculate or issue the Vendor's official tax invoice. The order screen shows commercial totals, payment status, processor-fee records, refunds, and uploaded Vendor invoice references. Any Vendor-entered tax data is explicitly identified as Vendor-supplied and is not treated as MateryalPH tax advice.

**Conditions**

Vendor Owner, Store Manager, Customer Service Staff, and Store Staff may confirm or reject an order. Because a price, NRPC, or other commercial revision changes the amount payable, only the Vendor Owner, Store Manager, or Store Staff may publish it. Customer Service Staff may prepare a draft for an authorized publisher. Inventory Staff may correct inventory and manage permitted SKU auto-accept allotments but cannot accept the commercial order or set monetary safeguards. Fulfillment Staff may act only after confirmation and payment conditions are satisfied. A rejection requires a reason. Repeated unavailable-item confirmations or non-response affect only the applicable defined metric.

**Design**

The list shows Order ID, request time, response deadline, Buyer, procurement type, manual or auto-accepted source, state, payment state, refund state, NRPC indicator, total, assigned handler, and action. Order Detail shows line items, inventory, reservation, quotation or revision source, change summary, fulfillment, NRPC, payment, refund, history, evidence, messages, and related case or invoice records. Controls are role-aware, labeled, keyboard accessible, and confirmed before irreversible action.

### Item-Based

Item-Based is a filtered view of the shared Orders module. The Vendor reviews each requested line and may confirm all lines, reject the request, or propose available quantities. A partial revision recalculates the total and waits for Buyer acceptance. Confirmed quantities are reserved; cart quantities are not.

**Auto-Accept by Stock Threshold**

Auto-accept is optional, disabled by default, and configured per SKU or variant. Vendor Owner and Store Manager may enable or pause the feature, set the remaining stock allotment, and configure independent maximum unit-count and order-value safeguards. Inventory Staff may update the SKU or variant allotment but cannot change monetary safeguards or enable organization-wide authority. Store Staff and Customer Service Staff may view why an order was or was not auto-accepted but cannot modify the policy.

The Vendor-only configuration shows physical quantity on hand, hard-reserved quantity, available-to-sell quantity, soft-held quantity, auto-accept allotment remaining, unit cap, amount cap, pause reason, last editor, and last update. Internal quantities never appear to Buyers.

When an eligible Item-Based request arrives, the backend locks all affected inventory and configuration rows and rechecks the complete Vendor child order. Every SKU must have active allotment, adequate available stock, and compliant limits; the Vendor, listing, fulfillment method, and account must remain eligible; and NRPC must be disabled. If every check passes, the database transaction creates immutable accepted snapshots, creates hard reservations, reduces each allotment, records the automated actor and policy version, and moves an online order to `AWAITING_PAYMENT` or an eligible physical-payment order to `CONFIRMED`. If any check fails, no line changes and the whole child order is routed to manual review.

When an allotment reaches zero, that SKU or variant pauses immediately and sends an in-app notification and email to the permitted Vendor users. Replenishing stock or releasing a reservation does not resume it. An authorized user must review the internal quantity and deliberately resume auto-accept. An auto-accepted online order expires after 45 minutes if payment is not verified; the hard reservation is released and any restored allotment remains paused when it previously reached zero. Repeated unpaid attempts are rate-limited and flagged without automatically penalizing a legitimate Buyer.

An order that needs NRPC always bypasses auto-accept. The Vendor must manually review the request, enter the NRPC amount and reason, and obtain Buyer acceptance before preparation.

### Project-Based

Project-Based displays **Quotation Inquiries**, **Package Requests**, and **Project Orders**, not a broadcast RFQ bidding queue. The system first compiles estimates from active listings. A Buyer may then open an inquiry with any Vendor displayed in the result list. Only the contacted Vendor receives that inquiry.

The inquiry contains two records: the Buyer's immutable locked Work Package and the Vendor-editable working duplicate. The Vendor may use its duplicate to propose product matches, substitutions, specifications, quantities, units, prices, delivery method, payment method, vehicle or trip count, expected fulfillment date, and NRPC. Every change stores before-and-after values and appears to the Buyer in a plain-language comparison. The system estimate remains a separately labeled baseline and is never overwritten.

The Vendor publishes an immutable quotation version with a Buyer-response deadline. The default is 24 hours and the permitted range is 1–72 hours. Editing after publication creates a new version, invalidates the previous version, resets the exact displayed deadline, and requires the Buyer to review again. The Buyer may accept, reject, or counter. A counter-offer releases soft holds and gives the Vendor 24 hours to revise and republish. The **Delete Quotation** action is available only before acceptance and records `WITHDRAWN`; it does not physically erase the quotation or audit events.

Published lines create planning-only soft holds. They do not block Item-Based auto-accept stock. When the Buyer accepts, the backend atomically verifies every line. Insufficient stock creates `STOCK_REVALIDATION_REQUIRED`, makes no reservation, and prevents payment until the Vendor republishes. Successful acceptance creates hard reservations, assigns the Work Package to the Vendor, and expires other active Vendor quotations for that Work Package. Conversation records remain available.

When the Buyer selects the Vendor directly from a system estimate, the Vendor receives a package request containing the locked Work Package, optional informational Note, system price snapshots, site, fulfillment preference, projected delivery fee, and 24-hour response deadline. The Note requires no separate Vendor action. The Vendor manually confirms availability, final delivery arrangement, expected fulfillment date, final amount, and any NRPC, or proposes a permitted revision. Project-Based procurement never uses auto-accept.

Project-Based access requires Bulk Order Capability. Turning that capability off prevents new matches but does not cancel confirmed obligations.

- **Fulfillment**

**Flow**

1. Authorized users view confirmed orders that require preparation.
2. For Self-Pickup, the Vendor prepares the order, marks `READY_FOR_PICKUP`, sends the notice, and records handover with timestamp and Buyer or authorized-receiver confirmation.
3. For Vendor Delivery, the Vendor assigns the confirmed vehicle or trips, marks `OUT_FOR_DELIVERY`, and records delivery with photo, timestamp, receiver name, and optional signature.
4. The order moves to `DELIVERED` or `PICKED_UP` and waits for Buyer confirmation.
5. After two calendar days and required reminders, the system may auto-confirm unless a dispute is open.

**Logic and Conditions**

The vehicle recommendation excludes configurations that cannot meet capacity, distance, or confirmed site-access requirements. Multiple trips are supported only when disclosed and accepted before payment. A fulfillment proof record is mandatory. Real-time GPS tracking is outside scope.

Only Fulfillment Staff, Store Manager, and the Owner may update fulfillment milestones, record handover, or upload delivery proof. Store Staff may view the fulfillment state needed for customer support or inventory coordination but does not perform fulfillment duties.

- **Messages**

**Flow**

1. A Buyer starts a conversation from a product, Vendor profile, order, or Project-Based comparison.
2. It is assigned to the designated Customer Service Staff or Store Staff; if none is configured, it routes to the Owner.
3. The responder becomes the current Message Handler.
4. The Buyer may ask an ordinary question or initiate an Item-Based or Project-Based quotation request.
5. An authorized user may transfer the conversation. All prior sender and handler history remains unchanged.
6. At `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`, Fulfillment Staff may receive a linked delivery-coordination thread without taking ownership of the original sales conversation.

The Buyer sees the store logo and name plus the current staff handler's avatar, display name, and role. Personal email, login identifier, and private number remain hidden. A transfer creates a visible system message. Store Manager and Owner may monitor all conversations; a monitoring view does not change the Handler unless the viewer replies or explicitly takes ownership.

Customer Service Staff, Store Staff, Store Manager, and Owner may handle sales conversations. Fulfillment Staff may use only the linked fulfillment thread. Conversation access and every message are checked and attributed server-side.

**Order-from-Chat**

The Vendor may create a formal quotation from an eligible message thread. Item-Based quotations use the product or cart reference. Project-Based quotations use the Buyer's locked Work Package and Vendor-editable duplicate. Both use the same service and differ only through the stored procurement-context flag.

The quotation builder requires product or material lines, specifications, quantity, unit, unit price, fulfillment method, payment method, expected fulfillment date, and response deadline. Site Delivery also requires the system-suggested vehicle type and trip count to be confirmed or replaced with a valid configured alternative. The system calculates line subtotals, delivery fee, NRPC designation within the order value, Payment Processing Fee where applicable, Amount Due Now, later physical-payment balance, and total.

NRPC is disabled by default. Only Vendor Owner, Store Manager, or Store Staff may enter and publish its amount, affected lines, and required reason. Customer Service Staff may prepare a quotation draft but cannot publish a monetary change. The Vendor determines the order-specific NRPC amount; there is no platform-wide numeric cap, but the amount cannot exceed the eligible prepared-material subtotal, must reflect actual irreversible preparation, and remains subject to Buyer acceptance, evidence, flagging, and Admin review. Any NRPC quotation requires manual handling and cannot use auto-accept.

Publishing creates an immutable quotation version and soft holds. The Buyer sees the exact deadline and plain-language changes from the attached source. A later edit creates a new version, resets the deadline, and makes the prior version unacceptable. Rejection, counter-offer, expiry, or Vendor withdrawal releases soft holds immediately. Acceptance performs the atomic stock check and creates hard reservations only when all lines remain available.

Every quotation event uses the shared audit and notification layer: creation, draft edit with before/after values, publication, view, counter-offer, acceptance, rejection, expiry, withdrawal, inventory validation, order creation, actor, role, and timestamp. The Vendor may withdraw an unaccepted quotation but cannot erase it from the audit record.

- **E-Invoices**

The module tracks Buyer invoice requests. The Vendor generates the legally compliant invoice through its own BIR-registered invoicing or accounting process and uploads a PDF copy. MateryalPH does not create, number, calculate, or issue the Vendor's official tax invoice.

The request records `REQUESTED`, `UPLOADED`, `DOWNLOADED`, `RETURNED_FOR_CORRECTION`, or `CLOSED`. The service target is three business days after the request and never extends a stricter legal deadline. A later refund may require the Vendor to upload the legally appropriate adjustment document according to current BIR rules; the system must not invent a “credit note” requirement without confirmation of the applicable document.

Vendor Owner, Store Manager, and Store Staff may upload. Customer Service Staff may view request status and communicate with the Buyer but cannot upload the official file unless the role definition is formally changed. The PDF, invoice number, invoice date, uploader, timestamp, and related order are audit-logged.

- **Notifications**

Notifications include order requests, response deadlines, Buyer revisions, verified payments, fulfillment deadlines, messages, disputes, compliance correction, document expiry, stale inventory, invoice requests, Xendit connection health, and platform notices. Routine updates use in-app or push delivery; important records use email. No SMS provider is used.

Users may configure optional categories per channel, but mandatory security, legal, suspension, payment, and dispute notices cannot be disabled. A notification deep-links only to a resource the recipient is authorized to access.

- **Disputes**

A transaction dispute may be opened from `PROCESSING` onward. A post-completion return or dispute must be filed within seven calendar days after `COMPLETED`, subject to any non-waivable legal right. The Vendor may respond to an eligible Buyer case, submit evidence, offer replacement or voluntary refund, reject with evidence, or request Admin review. The response window is 48 calendar hours. If a response is filed, the parties have 72 calendar hours to confirm a mutual resolution. Unresolved or unanswered cases escalate to Admin. A requested clarification has a 24-hour response window. One appeal may be filed within five business days with new relevant evidence.

Customer Service Staff and Store Staff may manage the response when dispute handling is enabled by the Owner. The Owner may require all disputes to route to the Owner. Store Manager may act. Fulfillment Staff may contribute fulfillment evidence but cannot decide a commercial remedy. Only the Owner may initiate a voluntary financial refund, unless the backend executes a documented Admin decision through the supported Vendor sub-account process.

Filing a dispute does not create a refund. When a concluded dispute awards a full or partial refund, the backend automatically creates the idempotent Dispute-Conclusion Refund against the original online payment and links it to the Case ID. The Vendor and Buyer see `REFUND_PENDING` until a verified provider event produces `PARTIALLY_REFUNDED`, `REFUNDED`, or `REFUND_FAILED`.

**Cancellation and NRPC**

The Buyer may withdraw before Vendor confirmation and may request cancellation with a valid reason from `CONFIRMED` through `PROCESSING`. Cancellation is unavailable at `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`; the Buyer may still use applicable dispute, return, warranty, and statutory remedies. A Vendor cancellation requires a reason at any nonterminal stage and records the responsible actor.

When cancellation of an already-paid order becomes final, the backend automatically initiates the separate Cancellation Refund. Vendor-caused cancellation forfeits every NRPC claim, refunds all Buyer-paid order amounts, releases the reservation, and contributes to NFR. An eligible Buyer-caused cancellation during `PROCESSING` may retain the accepted NRPC only when the Vendor submits evidence of the actual irreversible preparation. For COD or In-Store Payment, the online NRPC assurance payment is the refundable source; for full online payment, the refund amount is calculated from the paid order total.

NRPC cannot be retained for Vendor fault or for defective, incorrect, unsafe, misrepresented, or nonconforming goods. It is not a standard cancellation fee and is not added on top of the agreed order value. A Buyer flag does not automatically block an accepted order, but it creates an Admin review record and preserves the objection separately from acceptance.

- **Store Management**

  - **My Products**

**Flow**

1. An authorized user selects **Store → My Products → Add Product** and enters the material name.
2. The system normalizes the name, performs exact alias and `pg_trgm` fuzzy matching, suggests a canonical category and read-only platform code, and permits reviewed unmatched names.
3. The user selects one to three approved search tags.
4. The user enters display name, brand, manufacturer name and address, country of manufacture, description, unit, Vendor SKU, base price, internal quantity, public availability, base weight, and base dimensions.
5. Optional variants define their own attributes, price modifier, weight, dimensions, and inventory.
6. Category-specific technical fields are loaded.
7. At least one general product photo is uploaded.
8. A regulated product completes the applicable PS/ICC evidence path.
9. The listing moves to the applicable status.

**Listing Statuses**

`DRAFT`, `PENDING_COMPLIANCE`, `PENDING_ADMIN_REVIEW`, `ACTIVE`, `INACTIVE`, `TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED`, and `REJECTED` are distinct states. An Out-of-Stock listing is excluded from discovery and matching. A regulated listing cannot become Active until the applicable compliance submission is verified.

**Conditions**

Vendor Owner, Store Manager, Store Staff, and Inventory Staff may create and edit listings. Vendor Owner, Store Manager, Store Staff, and Inventory Staff may submit PS/ICC evidence. Customer Service Staff and Fulfillment Staff cannot change product, price, inventory, or compliance data.

Manufacturer, certification, or required marking changes return an active regulated listing to compliance review. The last approved information remains in history and the public verified indicator is withheld until review succeeds.

- **Vehicles**

The Owner or Store Manager may add, update, deactivate, or remove future-use vehicle configurations. Fulfillment Staff may view and assign an eligible vehicle to an order but cannot change fees, capacity, or service coverage. Existing order snapshots remain intact after configuration changes.

- **Transaction History**

Transaction History replaces the former Wallet module. It is a read-only MateryalPH record of full-order payments, NRPC assurance payments, verified payment events, Buyer processing fees, Cancellation Refunds, Dispute-Conclusion Refunds, compensating refunds after reconciled technical failure, COD records, and In-Store Payment records. It does not display or control a MateryalPH balance. A link may direct the Owner to the authorized Xendit dashboard for balance and withdrawal management.

The Owner and Store Manager may view store-wide records. Other staff see only payment status required for their assigned order and never payout credentials or full financial reports.

- **Vendor Team Accounts**

  - **Team Accounts**

**Flow**

1. The Owner opens Team Accounts and invites an employee.
2. The Owner enters name, email, contact number where required, and one fixed role.
3. For a Store Manager, the Owner decides whether to enable **Manage Staff Accounts**. The toggle is off by default.
4. The employee accepts the expiring invitation and creates or connects an individual account.
5. The membership becomes active and the employee sees only permitted features.
6. The Owner may change the fixed role, revoke delegation, suspend, deactivate, or remove the membership.
7. A delegated Store Manager may manage only the four non-manager staff roles. Every action notifies the Owner.

Invitation, acceptance, role, delegation, suspension, reactivation, and deactivation are audit-logged. Historical attribution remains after deactivation. Access loss is enforced on the employee's next request and active sessions are revoked.

  - **Team Tracking**

The Owner and Store Manager may view authorized organization activity. Other employees see only their own relevant activity. Records include actor, role at the time, action, affected resource, previous and new value where appropriate, timestamp, result, and correlation reference. No Vendor user may edit or delete an audit entry.

- **Analytics**

  - **Store Performance**

Store Performance displays VPS, VCS, MQS, OHS, CRR, FRR, eligibility counts, and metric windows exactly as defined in the System Workflow. Scores below their sample threshold display **New Vendor — Building Track Record**. The portal does not maintain a second formula or threshold set.

The Owner and Store Manager may view store-wide performance. Store Staff, Customer Service Staff, Inventory Staff, and Fulfillment Staff see only role-relevant operational measures or their attributed activity.

  - **Earnings**

Earnings displays completed gross order value, refunds, online payment records, COD, In-Store Payment, processing-fee records, order count, and estimated net receipts for internal operational reference. It does not calculate official VAT, issue a tax return, or replace the Vendor's accounting books. Uploaded invoice data is Vendor-supplied.

The Owner and Store Manager may view store-wide earnings. Other staff do not receive store-wide revenue access. Reports may be exported as CSV or spreadsheet with an **Internal Operational Report — Not a Tax Invoice** notice.

- **Store Profile (Vendor Owner) / Staff Profile (Vendor Team Accounts)**

**Vendor Owner**

The Owner sees Public Store Profile, Business Information, Business Documents, Fulfillment Configuration, Payment Connection, Security, and Staff. Public-profile changes save after validation. Legal-business, address, compliance, or payment changes may require recent authentication and reverification. A field with an active review cannot be overwritten without closing or replacing the prior submission through a documented action.

**Vendor Team Account**

The Staff Profile contains:

- Staff profile picture, editable by the employee.
- Name, pre-filled from the account.
- Position or fixed role, read-only to the employee.
- Account creation date, read-only.
- Store membership, read-only.
- Personal security and notification preferences.

The Staff Profile does not edit the Vendor's public Business Store Profile. Buyer-facing communication may display the staff avatar, display name, and role beside the store identity. The employee cannot change the role or store membership.

---

### Vendor Team Account Management

## Vendor Owner (Main Store Account)

The Owner has full organization control and access to PS/ICC submissions. The Owner creates Store Managers and other staff, monitors all activity, configures auto-accept and its safeguards, publishes quotations and NRPC terms, retains payout and legal-business authority, and remains the highest-level account.

## Store Manager (Delegate Role)

The Store Manager has broad operational visibility and may manage conversations, order confirmation, quotation publication, order-specific NRPC, auto-accept configuration, listings, inventory, compliance, fulfillment, disputes, and reports. The Manager cannot transfer ownership, edit payout credentials, delete logs, delete the organization, change legal ownership, or grant delegation. Staff management is available only when the Owner enables the dedicated flag.

## Employee Roles

### Store Staff

Store Staff combines Customer Service Staff and Inventory Staff functions, including order confirmation, messages, quotation publication, order-specific NRPC within the governing rules, permitted disputes, listings, internal inventory, price changes, and PS/ICC submissions. It may view auto-accept outcomes but cannot enable the feature or change its organization-level monetary safeguards. It excludes delivery dispatch, handover, and delivery-proof duties.

### Customer Service Staff

Customer Service Staff monitors and confirms unchanged order requests, views stock necessary for confirmation, handles inquiries and assigned sales, prepares quotation drafts, and manages disputes when enabled. It cannot publish a quotation or commercial revision, set NRPC, change listings, prices, inventory, auto-accept configuration, compliance, fulfillment proof, or financial configuration.

### Inventory Staff

Inventory Staff manages listings, internal stock, variants, permitted prices, SKU or variant auto-accept allotments, and PS/ICC evidence and corrections. It cannot enable auto-accept, set its monetary safeguards, publish quotations, set NRPC, confirm commercial orders, communicate as the sales handler, update fulfillment, or access store-wide earnings.

### Fulfillment Staff

Fulfillment Staff prepares assigned confirmed orders, records fulfillment milestones and proof, assigns an approved vehicle, and communicates through the linked delivery thread or an approved telephone call. It cannot alter prices, inventory definitions, compliance, payment settings, or commercial refunds.

## Restricted Actions

No employee, including Store Manager, may transfer ownership, access another Vendor, delete audit history, create another Vendor organization under the membership, edit payout credentials, change their own role, or grant access beyond the fixed delegation rule. Only the Store Manager may view store-wide operations and earnings; specialized staff remain restricted to their scope.

## Attribution Rules

Every action records the actual user who performed it. The system never attributes a staff action only to the store. The Owner's monitoring view is recorded separately and does not change operational ownership.

### Sales Attribution

An order is attributed to the Customer Service Staff or Store Staff who handled the accepted inquiry or was explicitly assigned as sales owner. Direct Owner or Store Manager actions are attributed to that person. Inventory-only or fulfillment-only work does not become sales attribution.

### Message Attribution

The current Message Handler is the authorized person who claims, is assigned, or replies to the conversation. A transfer changes the current Handler but preserves prior actions and senders. The fulfillment thread is linked but remains separately attributed.

### Inventory Attribution

Each listing, quantity, reservation, stock movement, variant, price, and compliance change stores the actor and before-and-after value. Concurrent changes use transactional validation and cannot silently overwrite a later revision.

### Fulfillment Attribution

Each preparation state, vehicle assignment, dispatch, handover, delivery proof, receiver, and timestamp identifies the employee who recorded it.

## Off-Platform Communication Logging

An approved delivery-coordination telephone call records employee, order, channel, and timestamp without recording call content. The Vendor must not use this log to imply that the platform captured or verified the conversation.

## Employee Lifecycle

The Owner may deactivate any employee, including a Store Manager. A delegated Store Manager may deactivate only permitted non-manager staff. Deactivation revokes sessions and access but preserves historical attribution. Reassignment of unfinished work identifies both the former and new responsible users.

---

**Inventory and Stock Visibility Strategy**

The Vendor maintains exact internal quantities while Buyers see only `In Stock`, `Limited Stock`, or `Out of Stock`. Internal inventory includes quantity on hand, hard-reserved quantity, available-to-sell quantity, soft-held quantity, auto-accept allotment, reorder level, and movement history. Units Sold is displayed only from completed eligible orders.

Cart placement does not reserve stock. A published quotation creates only a soft hold, which informs the Vendor of projected demand but does not reduce saleable stock or the auto-accept pool. Manual confirmation, eligible Item-Based auto-accept, or quotation acceptance creates a hard reservation through row-level locking and an all-or-nothing database transaction. Rejection, counter-offer, quotation expiry or withdrawal, payment expiry, approved quantity reduction, or cancellation releases the applicable hold or reservation.

`available_to_sell = quantity_on_hand − hard_reserved_quantity`. Delivery or pickup reduces physical quantity on hand and the matching hard reservation in one transaction. An auto-accept action reduces its separate allotment but does not falsely record physical stock as sold. All configuration, hold, reservation, release, adjustment, and fulfillment movements record the source, actor or automated policy, before/after values, order or quotation, and timestamp.

- **Behavioral Nudge System — Keeping Listings Fresh**

The Vendor may configure an in-app, push, or email reminder time. Day 7 and Day 12 reminders warn that confirmation is required. After 15 consecutive days without stock confirmation, the listing becomes `TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED`. It is not called an account suspension. A valid stock confirmation restores eligibility immediately unless another restriction applies. No SMS reminder is sent.

**Vendor Material Listing, Inventory, and Compliance Quality Assurance**

Product data is divided into a product definition, Vendor listing, variants, inventory, price snapshots, media, and compliance submissions. This prevents inventory changes from rewriting technical or compliance history. Bulk spreadsheet updates validate every row, return row-specific errors, and apply only validated changes through an auditable import job.

### Enhanced Compliance Verification (Three-Path Input)

For a DTI-BPS regulated material, the authorized Vendor user selects:

- **Path A — Photo or Camera Capture.** The user captures the physical PS Mark, ICC sticker, or required marking. OCR proposes values for review.
- **Path B — QR Code Scan or Upload.** The system decodes an available QR payload or verification reference and retains the image as evidence.
- **Path C — Manual Entry.** The user enters the applicable number and manufacturer or importer information and must attach a clear physical-marking photo.

All paths converge on **Review and Confirm**. OCR and QR results remain editable because extraction is assistance, not proof. The backend validates required fields and compares them with the configured current official source where available. A match may produce `VERIFIED`; an uncertain or unavailable match produces `PENDING_ADMIN_REVIEW`, not an accusation of counterfeiting. Admin may approve, return for correction, or reject with a reason.

Only the applicable PS, ICC, or other required marking is requested. The system does not assume every regulated material uses the same certification. Public badges show limited verified information and never expose private documents unnecessarily.

### Official Verification References

- [DTI-BPS PS and ICC Marks](https://bps.dti.gov.ph/product-certification/ps-and-icc-marks)
- [DTI-BPS Products Under Mandatory Certification](https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification)

Official DTI-BPS sources remain authoritative. MateryalPH verification is an operational marketplace control and not a replacement for government enforcement or professional product testing.

---

- **Store Operation**
  - Orders
  - Fulfillment
  - Messages
  - E-Invoices
  - Notifications
  - Disputes
- **Store Management**
  - My Products
  - Vehicles
  - Transaction History
  - Vendor Team Accounts
    - Team Accounts
    - Team Tracking
- **Analytics**
  - Store Performance
  - Earnings
- **Store or Staff Profile**

---

### Future Enhancements

Multi-branch management, custom Vendor roles, a Vendor RFQ bidding queue, live GPS tracking, MateryalPH wallet or escrow, automated tax-invoice issuance, and construction-vehicle rental are outside the current capstone scope.
