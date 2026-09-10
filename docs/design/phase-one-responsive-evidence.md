# Phase 1 responsive verification

Status: partial evidence only; Phase 1 is not accepted.

## Verified in this continuation

- `apps/vendor-web`: `npm.cmd run test:e2e` — 112 passed. Chromium widths: 320, 375, 390, 768, 1024, 1280, 1440, 1920. Covers Vendor landing interaction/disclosures and Vendor/Admin authentication route overflow and initial keyboard focus. API responses are intercepted; these are not real-provider smoke tests.
- `apps/admin-web`: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run`, `npm.cmd run build` — passed; two component tests.
- `apps/buyer-mobile`: `flutter test` — 16 passed. Added all three onboarding steps through Welcome at 320×568, 375×667, 390×844, 844×390, and 768×1024 with 100% and 200% text. Existing offline fail-closed restoration test remains included.

The initial browser run exposed a missing keyboard recovery action on the Admin missing-invitation screen. A return-to-sign-in link fixes this without relaxing invitation validation. The initial Buyer matrix exposed vertical overflow; onboarding content and Welcome now scroll while retaining the approved content and actions.

## Not demonstrated by these checks

Full keyboard traversal, screen-reader/device QA, risk-OTP state coverage, Buyer golden tests, native Android/iOS builds and provider assessments, PostgreSQL/PostGIS migration/schema gates, complete security scans, clean-start reproduction, and real OIDC/email delivery remain separate acceptance requirements. These layout checks must not be cited as proof of operational acceptance.
