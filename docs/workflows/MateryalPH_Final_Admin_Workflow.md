**Admin Flow**

---

### Admin Portal (Web Application using React.js)

MateryalPH provides a dedicated **web-based Admin Portal** developed using React.js. It is separate from the Buyer mobile application and Vendor Portal and serves as the platform's controlled operations, verification, compliance, moderation, dispute, account-management, monitoring, and audit interface.

The System Workflow is the authoritative source for shared security, state, scoring, payment, privacy, accessibility, audit, and integration rules. This Admin Workflow defines administrative review, oversight, and enforcement without creating conflicting business rules.

The Admin Portal does not provide public registration. A Buyer or Vendor account cannot obtain Admin access through a profile change or public application. Every Admin action is authorized by the Laravel backend and attributed to an individual Admin account.

---

### Admin Sign-in

Administrators sign in using an internally issued email/password account and mandatory authenticator-app TOTP. Email is used for invitation, recovery, and security notices; email OTP is not treated as strong MFA. Public Google sign-up and public Admin sign-up are unavailable.

The authentication service applies HTTPS, server-side validation, adaptive password hashing, account and role checks, CSRF protection, rate limiting, risk-based bot protection, short-lived access tokens, rotated refresh tokens, and session revocation. Five failed attempts within 15 minutes trigger temporary throttling and a security event. A successful password or factor recovery revokes existing sessions and notifies the account holder.

The Admin Portal uses `Secure`, `HttpOnly` cookies and must not store authentication tokens in browser local storage. Sensitive actions—including Admin-role changes, permanent bans, platform-setting changes, data exports, and security-factor recovery—require recent reauthentication.

---

### Admin Account Creation

The initial Super Admin is created through a protected deployment command or seed procedure available only to authorized system operators. The command must not contain a reusable default password. It creates a pending Admin account and sends a time-limited, single-use setup invitation to the authorized email.

After the initial Super Admin exists, later Admin Staff accounts are created through the Admin Portal by an authorized Super Admin. The invitation contains the intended role, expiry, inviter, and one-time acceptance credential. The invited user sets a password, verifies the email, enrolls TOTP, receives recovery codes, and accepts the applicable Admin policy before access is activated.

Invitation, acceptance, role assignment, role change, suspension, factor reset, reactivation, and deactivation are recorded in the security audit log. Deactivation revokes all active sessions but preserves historical attribution.

---

### Admin Dashboard

**Overview**

The Admin Dashboard is the platform operations center. It is accessible only to active Admin accounts and renders modules according to their assigned permissions. Counts are linked to filtered queues and must not expose information outside the Admin's scope.

**Dashboard Sections**

**1. Platform KPIs:** Active Tier 2 Vendors, active Buyers, order requests awaiting Vendor response, confirmed orders, pending business-document reviews, pending product-compliance reviews, open disputes, appeals, account flags, unresolved invoice requests, failed background jobs, and external-integration health.

**2. Philippine Geographic Marketplace Analytics:**

The dashboard provides an interactive Philippines map using versioned Philippine Standard Geographic Code identifiers and approved administrative-boundary data. Its hierarchy is `Philippines → Region → Province or Independent/Highly Urbanized City → City or Municipality`, so NCR, independent cities, and municipalities are not omitted. The current geographic-data version and last aggregation time are displayed.

- **Design and navigation.** The default choropleth shows regions. Selecting a region drills into its provinces and independent or highly urbanized cities; selecting a province shows its component cities and municipalities. Breadcrumbs, Back, Reset Map, search, and keyboard-operable geographic selection are available. A synchronized accessible table exposes the same places, metrics, sorting, and selection without requiring map interaction.
- **Global filtering.** Clicking a geography applies its PSGC code to the entire dashboard, including KPI cards, trends, queues, category demand, response performance, and exports. The selected geography is visible in a removable filter chip and URL state. Date range, procurement type, category, fulfillment method, payment method, and order state may be combined with it.
- **Supply and Buyer presence.** Vendor Count uses active Tier 2 storefronts assigned to their verified business-address point. Registered Buyer Count uses each Buyer's current verified primary/default location. Active Buyer demand is attributed separately to the order delivery/pickup reference or Project site so a Buyer with projects in different areas is not incorrectly treated as demand only at the profile address.
- **GMV and order volume.** Gross GMV is the sum of confirmed marketplace order value for Online, COD, and In-Store Payment, excluding the separately disclosed processing fee and before refunds. Net GMV subtracts cancelled and refunded commercial value. Order Volume counts confirmed Vendor child orders. The dashboard displays gross and net values as daily, weekly, or monthly time series and never substitutes a cumulative snapshot for a trend.
- **Fulfillment and case rates.** Fulfillment Rate equals eligible orders completed by the reporting cutoff divided by confirmed orders due for fulfillment in the period. Cancellation Rate equals confirmed orders finalized as cancelled divided by eligible confirmed orders. Dispute Rate equals eligible confirmed orders with at least one transaction dispute divided by eligible confirmed orders. Numerators, denominators, exclusions, and date basis are available in metric help text.
- **Vendor response performance.** Response time is measured from an inquiry, package request, order request, or counter-offer becoming available to the Vendor until the first qualifying human response or quotation publication. Automated acknowledgments and auto-accept do not count as human response. The dashboard shows arithmetic mean as requested, plus median and 90th percentile to reveal outliers.
- **Category and material demand.** A heatmap can be switched among confirmed order count, normalized quantity where units are comparable, and commercial value. Demand is attributed to the relevant order or Project site and may be filtered by controlled category or canonical material. It supports Vendor recruitment decisions but is not represented as an official government market statistic.
- **Meaningful active users.** Buyer and Vendor activity are tracked separately as unique daily, weekly, and monthly users. A Buyer is active after submitting an order, accepting or countering a quotation, or confirming/reporting fulfillment. A Vendor user is active after publishing or revising a quotation, manually confirming or revising an order, recording fulfillment, or performing an equivalent human operational action. App opens, page views, automated jobs, and auto-accept events alone do not qualify.
- **Privacy and quality.** Aggregate queries use authorized analytics views rather than exposing individual coordinates. Small groups are suppressed or generalized under the approved disclosure-control rule. Records with unresolved geography appear in a separate data-quality count. PSGC changes are imported through a versioned job; historical orders retain the code and boundary version used for reporting, with documented remapping for current-view aggregation.

Map color never carries meaning alone. Every scale has a legend, units, exact values on focus or selection, sufficient contrast, pattern or text alternatives where required, and a non-map table. Trend charts provide accessible summaries and downloadable authorized data.

**3. Vendor Management:**

- Pending Vendor verification queue with document-by-document review.
- Approved Vendor list and current marketplace status.
- Activation-readiness checklist showing every mandatory requirement.
- Return for Correction, Approve, Reject, Temporarily Restrict, Suspend, Reactivate, and Permanently Ban actions where permitted.
- Mandatory reason for rejection, restriction, suspension, ban, or reversal.
- Xendit sub-account onboarding status and safe retry of an approved failed onboarding job; no secret keys or payout credentials are displayed.
- Document expiration monitoring based on the Admin-verified date.

**4. Buyer Management:** Buyer account status, dispute history, confirmed self-pickup no-show patterns, abuse reports, appeals, temporary restrictions, suspension, reactivation, and permanent-ban actions. No fixed number of reports or no-shows causes automatic suspension without review.

**5. Taxonomy Management:** Authorized users manage canonical material entries, aliases, platform codes, compatible units, structured technical attributes, category tags, and regulated-product mappings. A pending taxonomy suggestion must not block a Vendor from saving a draft listing. Changes are versioned and must not rewrite historical order or compliance snapshots.

**6. Product Compliance Queue:** Displays `PENDING_ADMIN_REVIEW` submissions, the Vendor-entered information, OCR or QR output, physical-marking evidence, current official reference used, and previous decisions. Authorized Product Compliance Staff may Approve, Return for Correction, or Reject with a reason. The system records reviewer, decision, timestamp, source version, and remarks. It does not label an unmatched entry counterfeit without an authorized determination.

**7. Dispute and Appeal Queue:** Displays Case ID, order, parties, issue type, evidence, current handler, deadline countdowns, status, requested remedy, refund capability, and prior decisions. A decision creates the applicable case, order, score-event, and dispute-conclusion refund instruction; it does not perform an undocumented escrow action.

**8. Flag, Restriction, and Suspension Management:** Displays system alerts, user reports, prior incidents, evidence, active sanctions, and expiration. Admins may impose or lift a permitted restriction with a mandatory reason. Existing confirmed orders receive an explicit continuation, monitored-fulfillment, cancellation, replacement, or refund plan.

**9. Score and Badge Monitoring:** Displays Vendor VCS, MQS, OHS, VPS, CRR, FRR, sample size, metric window, badge eligibility, and source events. Admins may investigate incorrect or fraudulent source data but cannot manually assign a performance badge or arbitrary score. Confirmed corrections create a reversible adjustment event and audit record.

**10. Transaction Log:** Read-only records of Xendit payment requests, verified payment events, Buyer processing fees, Cancellation Refunds, Dispute-Conclusion Refunds, reconciled compensating refunds, COD, and In-Store Payment. Filters include Vendor, Buyer, order, trigger, Case ID, channel, date, amount, payment state, and refund state. Admins cannot view secret credentials, change refund destinations, withdraw balances, or manually disburse funds.

**11. Invoice Request Log:** Read-only tracking of Buyer invoice requests and Vendor-uploaded files, including order, request date, service target, upload date, invoice reference, uploader, correction state, and download event. MateryalPH documents are clearly distinguished from the Vendor's BIR-compliant invoice. Admins do not create or calculate a Vendor tax invoice.

**12. Platform Settings:** Authorized Super Admins manage non-secret operational defaults, including SRS and FMS default weights, radius values, Vendor-response window, 45-minute payment window, quotation deadline limits, reminder offsets, dispute deadlines, rating windows, badge thresholds, budget warning threshold, invoice-request service target, analytics disclosure thresholds, upload limits, and feature flags. SRS and FMS weight groups must total 100%. VPS remains fixed at 50% VCS and 50% OHS. Buyer preference records remain in `buyer_ranking_preferences` and are never overwritten by a platform-default update. Admins may not impose a platform-wide numeric NRPC cap; oversight is through disclosure, evidence, flag, dispute, and enforcement rules.

Xendit API keys, webhook verification tokens, Google API keys, email credentials, encryption keys, and other secrets are excluded from Platform Settings. The portal may display connection health and masked environment labels only.

**13. Audit Log:** Searchable, append-only records filterable by actor, role, action, resource, organization, result, date, correlation identifier, and reason. It includes quotation versions, auto-accept policies and decisions, inventory reservations, NRPC acceptance and flags, cancellations, and both refund triggers. Access to sensitive audit details is itself logged. No Admin may edit or delete an audit entry through the portal.

**14. Product Review Moderation Queue:** Displays the review, media, flag reason, verified-purchase reference, related dispute, prior moderation, and author display rules. Admin may Dismiss the Flag, Request Correction, Hide Pending Review, or Remove for a documented guideline violation. The original content and decision history remain preserved for audit. A Vendor cannot remove a review unilaterally.

**15. Budget Override Audit Log:** Read-only view of Buyer budget overrides, including project, work package, prior budget, order amount, overage, written reason, actor, and timestamp. Overrides are Buyer decisions and do not require Admin approval unless a separate fraud or account case exists.

**16. Privacy Request Management:** Tracks verified requests for access, correction, objection, deletion, restriction, portability where applicable, or another lawful privacy action. Each request records identity verification, scope, handler, legal or retention exception, response, completion date, and audit trail. Admins see only the personal information necessary for the assigned request.

**17. Integration and Job Health:** Displays safe operational status for Xendit, Google services, email, file storage, Laravel Reverb, queues, scheduled tasks, analytics aggregation, PSGC import, and OCR. It supports authorized retries of idempotent jobs and shows correlation identifiers without exposing secrets or sensitive payloads.

---

### Admin Account and Staff Management

The Admin Portal uses predefined roles with least privilege:

| **Role** | **Primary scope** |
| --- | --- |
| Super Admin | Admin accounts, non-secret platform settings, full authorized oversight, and final privileged account actions |
| Vendor Verification Staff | Vendor business information, registration documents, activation readiness, and document expiry |
| Product Compliance Staff | DTI-BPS regulated-product mapping and PS/ICC submission review |
| Order and Dispute Staff | Order, quotation, auto-accept, NRPC and cancellation investigation; disputes, remedies, appeals, and refund monitoring |
| User Management Staff | Buyer and Vendor account review, warnings, restrictions, suspension, reactivation, and abuse cases |
| Support Staff | User-support cases, safe account guidance, and escalation without enforcement or financial authority |

Custom Admin Roles are optional. If enabled, they use named, reusable permission sets configured only by the Super Admin. A Custom Role cannot grant Super Admin assignment, secret access, audit deletion, payout control, or permissions not held by the assigning administrator.

Every Admin account receives only one role at a time. Role changes are versioned so historical actions retain the role held when the action occurred. Permissions are enforced by backend policies on every request and tested through authorization tests. Support Staff cannot acquire enforcement authority merely by being assigned a case.

Geographic aggregate analytics require the separate `analytics.view_aggregates` permission. It is granted to Super Admin and may be assigned through an approved Custom Role. Row-level personal records, exact Buyer coordinates, bulk export, and sensitive evidence require separate permissions; access to the aggregate map never implies access to them.

An Admin cannot review their own access change, recover their own TOTP through an administrative bypass, or modify records outside the assigned scope. Production database access, deployment commands, and environment secrets remain outside the normal Admin Portal.

---

### Admin Activity Attribution

Administrative attribution records the actual Admin user, role at the time, action, affected record, previous and new state, timestamp, result, reason, evidence or source reference, and correlation identifier.

- Vendor Verification Staff are attributed to business-document and activation reviews.
- Product Compliance Staff are attributed to PS/ICC and regulated-listing decisions.
- Order and Dispute Staff are attributed to investigations, decisions, remedies, clarification requests, and appeals.
- User Management Staff are attributed to warnings, restrictions, suspensions, reactivations, bans, and account-review decisions.
- Support Staff are attributed to support responses and escalations but not to a later enforcement decision made by another Admin.
- Super Admin actions remain individually attributed and are never recorded only as “system.”

When a case is transferred, the system records the former handler, new handler, transfer reason, and timestamp without rewriting earlier activity. Automated actions identify the responsible system job and triggering rule. A later Admin review remains a separate event.

---

### Vendor Verification and Activation Workflow

1. A Vendor submits the required onboarding information and documents.
2. The system validates completeness, file requirements, dependencies, and malware-scan status before queueing review.
3. Vendor Verification Staff compare the entered business information with the submitted DTI or SEC, LGU, BIR, TIN, and applicable regulatory evidence.
4. For each document, the Admin records the verified document number, issue date, expiration date or `NOT_APPLICABLE`, source, remarks, and decision.
5. **Approve** satisfies the requirement. **Return for Correction** requests a replacement or clarification. **Reject** determines that the submitted evidence does not satisfy the requirement. Return and rejection require a clear reason.
6. The system recalculates activation readiness after every decision.
7. Marketplace activation is available only when all mandatory requirements—including Xendit connection, fulfillment configuration, and the required publishable listing—are successful and no blocking condition exists.
8. Activation, rejection, later restriction, expiration, and restoration are audit-logged and notified to the Vendor.

An Admin cannot override a missing mandatory requirement by editing the frontend. A permitted exceptional override, if introduced later, requires a dedicated policy, reason, authorization, and audit event.

---

### Product PS/ICC Compliance Review Workflow

1. A Vendor Owner, Store Manager, Store Staff, or Inventory Staff submits evidence through Photo/OCR, QR, or Manual Entry with mandatory marking evidence.
2. The system performs technical validation and an official-record comparison where a current source is available.
3. A confident valid match may become `VERIFIED` according to the approved rule. An uncertain, unavailable, or unmatched record becomes `PENDING_ADMIN_REVIEW` rather than automatically counterfeit.
4. Product Compliance Staff review the material category, required marking, entered identifier, manufacturer or importer, evidence quality, current DTI-BPS reference, and previous submissions.
5. The Admin selects Approve, Return for Correction, or Reject and supplies remarks. The system records the source and time of review.
6. Approval permits publication if all other listing fields are complete. Return or rejection prevents public activation until corrected.
7. A later compliance-sensitive product edit removes the public verified state and opens reverification.

The Admin interface links to current official DTI-BPS references. MateryalPH review supports marketplace control but is not described as a government certification or laboratory test.

---

### Order, Quotation, Auto-Accept, and NRPC Oversight

Authorized Order and Dispute Staff may inspect the records necessary to investigate an order or flag without altering the Vendor's ordinary commercial configuration. The oversight view links the original Buyer request, locked Work Package where applicable, Vendor-editable duplicate, every quotation version, plain-language and field-level changes, deadlines, counter-offers, soft holds, acceptance-time inventory result, hard reservations, payment, fulfillment, cancellation, and refund history.

Auto-accept monitoring shows Vendor, SKU or variant, policy version, allotment and safeguards at the time, automated eligibility checks, transaction result, reservation movement, payment expiry, pause reason, and responsible configuration actor. Admins cannot manually force an order through a failed stock check or resume a Vendor's paused auto-accept configuration. Confirmed abuse, manipulation, or unsafe configuration is handled through a documented restriction or enforcement case.

An NRPC flag shows the Vendor-entered amount, reason, affected lines, Terms version, Buyer acceptance, separate Buyer objection, preparation evidence, order state, and cancellation cause. There is no platform-wide numeric cap. The Admin evaluates disclosure, actual preparation, proportionality, evidence, Vendor fault, product conformity, and applicable law. A decision may uphold, reduce, remove, or refund the NRPC through the appropriate case remedy. The Admin never edits the historical accepted amount; a modification creates a compensating decision and, when required, a linked refund.

---

### Dispute Resolution and Report Workflow

The process begins when an eligible Buyer or Vendor files a report connected to an order. A transaction dispute is eligible from `PROCESSING` onward. A post-completion return or dispute must be filed within seven calendar days after `COMPLETED`, subject to any non-waivable legal right. Safety, fraud, privacy, and account-abuse reports use their applicable reporting channel and are not rejected solely because the transaction window ended. Buyer issue types may include wrong item, defect, incomplete delivery, late or missing fulfillment, misleading listing, payment, invoice, or another supported transaction issue. Vendor issue types may include non-payment for a physical-payment order, confirmed pickup no-show, abusive communication, false evidence, or inaccessible delivery site.

The filing party completes the structured Refund/Dispute Request Form, selects an issue type, states the requested remedy, enters a requested amount where partial, and attaches available photos, video, order data, message reference, proof, invoice, or other evidence. The original masked payment method may be displayed for information, but the form never collects a different refund destination. The system creates a unique Case ID, timestamps the submission, preserves the original evidence, sets the dispute state, and notifies the other party. Filing alone does not create a refund.

**Case Statuses**

| **Status** | **Meaning** |
| --- | --- |
| `OPEN_AWAITING_RESPONSE` | Other party has 48 calendar hours to respond |
| `MUTUAL_RESOLUTION` | Both parties have 72 calendar hours to reach and confirm an agreement |
| `ESCALATED_ADMIN_REVIEW` | No response, no agreement, or a direct safety/compliance escalation requires Admin review |
| `AWAITING_CLARIFICATION` | Requested party has 24 calendar hours to provide additional evidence |
| `DECIDED` | Admin decision issued and remedy execution is being tracked |
| `APPEAL_OPEN` | One timely appeal with new relevant evidence is under review |
| `RESOLVED` | Decision and required remedy are complete |
| `CLOSED_INCONCLUSIVE` | Evidence is insufficient for a fault determination |

All deadlines use Asia/Manila time. If no response is received within 48 hours, the case escalates automatically. When a response is received, the parties receive 72 hours for mutual resolution. A confirmed agreement is recorded with both parties' acceptance. If the case remains unresolved, it enters Admin review.

The assigned Order and Dispute Staff reviews the order snapshots, payment events, inventory and fulfillment history, messages, evidence, account history relevant to the case, and applicable policies. If additional information is needed, the Admin issues a structured clarification request with a 24-hour deadline. Failure to respond does not automatically prove fault; the Admin decides using the available evidence and records the limitation.

**Permitted Outcomes**

- Dismissed.
- Replacement.
- Full Refund.
- Partial Refund.
- Warning.
- Score Adjustment through the applicable verified metric event.
- Temporary Restriction.
- Suspension.
- Permanent Ban.
- Inconclusive with monitoring where justified.

A score change cannot be an arbitrary number. The decision records the confirmed event—such as Vendor-caused non-fulfillment, validated defect return, or confirmed Buyer no-show—and the scoring service recalculates the applicable metric.

When a concluded dispute awards an online full or partial refund, the backend creates the idempotent **Dispute-Conclusion Refund** for the relevant original payment and Vendor sub-account and tracks authoritative status. This trigger is separate from an automatic Cancellation Refund. The Admin does not receive, hold, withdraw, redirect, or manually disburse funds. If the selected channel lacks a native refund, the documented contractually approved fallback is tracked as part of the remedy. A case is not marked Resolved until the required replacement, refund, or other action reaches its terminal state.

MateryalPH applies no standard cancellation fee. NRPC is a Vendor-determined portion of the existing order value and has no platform-wide numeric cap. It requires actual irreversible preparation, prior disclosure, explicit Buyer acceptance, and evidence when retained. It is forfeited on Vendor cancellation and cannot reduce a remedy for Vendor fault or defective, incorrect, unsafe, misrepresented, or nonconforming goods.

Either party may file one appeal within five business days only when new relevant evidence is provided or a material process error is identified. The appeal identifies the original decision and does not erase it. The appeal reviewer records whether the decision is Affirmed, Modified, or Reversed and the corresponding remedy changes.

Repeated behavior may justify a stronger action, but the Admin considers severity, evidence, proportionality, prior warnings, impact, and existing orders. A first incident does not always require only a warning, and a fixed number of flags does not automatically require a ban. Every enforcement action has a reason, effective time, scope, duration where temporary, notification record, and restoration condition.

---

### Payment and Refund Oversight

The Admin Portal is read-only for money movement. It displays payment and refund status needed for reconciliation and dispute review. Xendit keys, Vendor payout credentials, balances, and withdrawal controls are not available.

Payment success is based on a verified Xendit webhook or authoritative reconciliation, never solely on a Buyer redirect. Duplicate events are idempotent. A failed or expired payment with no captured funds has no refund. If authoritative reconciliation proves that funds were captured after an application failure, the system creates a compensating refund and alerts operations.

Refunds use separate triggers and records:

- **Cancellation Refund:** Automatically initiated when cancellation of an already-paid order becomes final. The calculation records cancellation cause, NRPC treatment, refundable amount, and responsible actor. Vendor cancellation refunds all Buyer-paid order amounts and forfeits NRPC.
- **Dispute-Conclusion Refund:** Automatically initiated only when a concluded dispute decision awards a full or partial refund. It stores the Case ID and decision version.

Each refund record contains trigger, order, Case ID when applicable, Vendor sub-account, original payment request, original masked method, amount, supported-channel capability, Xendit reference, idempotency key, initiator or system rule, timestamps, and state. Refunds return to the original payment method. `REFUND_PENDING` means the request is still being processed; even a successful provider event does not justify claiming that funds already appear in the Buyer's account. Failed refunds enter an exception queue without duplicating the request.

The Buyer-facing Payment Processing Fee is stored separately from MateryalPH commission. MateryalPH commission is zero. Any production pass-through of processing fees must match the active Xendit agreement and applicable Philippine requirements.

---

### Privacy, Accessibility, and Audit Controls

Admin access to personal information follows least privilege and the Philippine Data Privacy Act principles of transparency, legitimate purpose, proportionality, accuracy, security, and limited retention. High-volume export requires explicit permission and recent authentication. Export reason, filters, file, actor, and expiry are recorded. Files use private storage and expiring access.

The Admin Portal targets WCAG 2.2 Level AA. It supports keyboard navigation, visible focus, semantic headings and tables, labeled controls, error summaries, sufficient contrast, non-color status indicators, and accessible confirmation dialogs. Deadline timers include exact text and do not rely only on color.

Audit logs are append-only through the application. Corrections are represented by a new compensating event rather than editing prior history. System clocks, Admin identity, role, source record, decision reason, and correlation identifiers support traceability.

---

### Authoritative Compliance References

- This workflow is a product and technical control specification, not legal advice. Philippine counsel, the Data Protection Officer, tax advisers, and the contracted payment provider must complete a pre-launch review and approve changes when governing requirements or contracts change.
- [Lawphil — Republic Act No. 11967, Internet Transactions Act of 2023](https://www.lawphil.net/statutes/repacts/ra2023/ra_11967_2023.html)
- [Lawphil — Republic Act No. 8792, Electronic Commerce Act of 2000](https://lawphil.net/statutes/repacts/ra2000/ra_8792_2000.html)
- [Lawphil — Republic Act No. 7394, Consumer Act of the Philippines](https://lawphil.net/statutes/repacts/ra1992/ra_7394_1992.html)
- [National Privacy Commission — Data Privacy Act](https://privacy.gov.ph/data-privacy-act/)
- [National Privacy Commission — Implementing Rules and Regulations](https://privacy.gov.ph/implementing-rules-regulations-data-privacy-act-2012/)
- [DTI-BPS — PS and ICC Marks](https://bps.dti.gov.ph/product-certification/ps-and-icc-marks)
- [DTI-BPS — Products Under Mandatory Certification](https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification)
- [DTI — E-Commerce Philippine Trustmark / Internet Transactions Act](https://trustmark.dti.gov.ph/)
- [DTI-BPS — PNS 2155:2020 Guidelines for E-Commerce Transactions](https://bps.dti.gov.ph/press-releases/28-2021/259-dti-issues-national-standard-guidelines-for-e-commerce-transactions)
- [BIR — Ease of Paying Taxes](https://www.bir.gov.ph/EOPT)
- [BIR RMC No. 77-2024](https://bir-cdn.bir.gov.ph/BIR/pdf/RMC%20No.%2077-2024.pdf)
- [Philippine Statistics Authority — Philippine Standard Geographic Code](https://psa.gov.ph/classification/psgc)
- [Xendit — Accept Payments for Sub-Accounts](https://docs.xendit.co/docs/accepting-payments-for-sub-accounts)
- [Xendit — Refund Payment](https://docs.xendit.co/docs/refund-payment-request)
- [Xendit — Transaction Fees](https://docs.xendit.co/docs/transaction-fees)
- [Google — Places API Policies](https://developers.google.com/maps/documentation/places/web-service/policies)
- [OWASP — Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- [W3C — WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)

---

### Future Enhancements

Automated legal-document validation without human review, direct Admin financial controls, MateryalPH escrow or wallet, unrestricted Admin Custom Roles, and predictive enforcement are outside the current capstone scope.
