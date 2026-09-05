# MateryalPH product context

## Product

MateryalPH is a Philippine construction-material procurement marketplace. It connects Buyers with verified Tier 2 Vendors while also showing limited, attributed Tier 1 Google directory references. The product has three separate surfaces: a Flutter Buyer application, a Vendor web portal, and an Admin web portal, all governed by one Laravel modular-monolith API.

## Source of truth

In descending authority:

1. The approved System, Buyer, Vendor, and Admin workflows in `docs/workflows/`.
2. `docs/architecture/MateryalPH_Technical_System_Design.md`.
3. `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`.
4. Reviewed Figma frames for visual intent only.

Generated guidance and design-review tools must not change roles, states, timers, formulas, payment/refund rules, map tiers, or excluded scope.

## Users and surfaces

- Buyers use the Flutter mobile app for map-first discovery, Item-Based and Project-Based procurement, messages, quotations, orders, payments, fulfillment, disputes, reviews, and reports.
- Vendor Owners and fixed-role Vendor staff use the Vendor portal for onboarding, verified storefront operations, listings, inventory, quotations, orders, fulfillment, compliance, staff, disputes, and reporting.
- Administrators use the Admin portal for invitation-only, least-privilege verification, moderation, disputes, enforcement, configuration, monitoring, analytics, privacy requests, and append-only audit review.

## Core product rules

- Tier 1 Suppliers are informational directory results only. They cannot transact, message, receive reviews, or display MateryalPH scores.
- Tier 2 Vendors are verified marketplace participants.
- One parent checkout creates one child order per Vendor.
- Order, payment, fulfillment, refund, and dispute states remain separate.
- Cart placement and quotation soft holds do not reserve sellable stock.
- Published quotation versions are immutable; only the latest version can be accepted.
- One Work Package can have multiple inquiries but only one selected Vendor.
- Payment and refund success comes only from verified provider events or authoritative reconciliation.
- Cancellation Refund and Dispute-Conclusion Refund are separate idempotent records.
- NRPC is optional, manual, disclosed before payment, part of the existing order value, and has no platform-wide numeric cap.
- Buyer cancellation is unavailable at Ready for Pickup and Out for Delivery; dispute and statutory remedies remain available.

## Explicitly excluded

No marketplace wallet or escrow, live delivery GPS, machine-learning ranking, Buyer organization accounts, Vendor multi-branch management, competitive RFQ queue, vouchers, construction-vehicle rental, or procurement beyond 50 km is included in the capstone unless separately approved.

## Quality and safety

Target WCAG 2.2 AA, deny-by-default authorization, immutable commercial/audit history, private storage, environment isolation, secret redaction, and no client-side backend secrets. Business deadlines render in Asia/Manila; stored timestamps use UTC.
