# Phone entry and portal alignment

## Outcome

Buyer and Vendor email/Google registration now default to Philippines (+63) in a country-code dropdown. The editable field contains only the national number. Changing the country preserves that entry; pasting an international number separates its prefix. Philippine `09171234567` becomes `+639171234567`. Empty, malformed and overlong entries fail validation. Selecting a contact country does not change marketplace eligibility or geographic coverage.

The web control is exported from `@materyalph/web-ui` for future Admin contact forms. No phone field was added to Admin login or invitation flows. Flutter uses the same country data, wording and semantic theme, with native dropdown behavior. Narrow web and phone layouts stack the controls; wider web forms place them beside each other.

Vendor and Admin authentication shells share `PortalBrand`: a 48 px logo, 12 px gap, divider and 12 px label padding. Both use matching column proportions, 31 rem form width, top alignment and responsive spacing. Portal-specific copy, safeguards and background colors remain.

## Files

- `packages/web-ui/src/phone-field.tsx`, `phone-countries.ts`, `portal-brand.tsx`, `index.ts`: reusable controls and exports.
- `packages/shared-data/phone-countries.json`, `libphonenumber-LICENSE`: pinned calling-code data and upstream license.
- `scripts/generate-phone-countries.mjs`: generates TypeScript/Dart country lists; `--check` detects drift.
- `apps/buyer-mobile/lib/widgets/phone_number_field.dart`, `phone_countries.dart`: native component and generated data.
- Buyer `register_screen.dart`, `google_signup_screen.dart`: component integration; `test/phone_number_field_test.dart`: normalization and failure regressions.
- Vendor `App.tsx`, `pages/AuthSupportPages.tsx`, `components/auth/VendorAuthShell.tsx`, `App.css`: phone integration and layout; `App.test.tsx`, `components/PhoneField.test.tsx`, `e2e/phone-brand.spec.ts`: coverage.
- Admin `components/AdminAuthShell.tsx`, `App.css`: shared branding and matching layout.

Country codes are derived from [Google libphonenumber metadata](https://github.com/google/libphonenumber/blob/cef6ae1479b50a20bd96f9092c545e8bc9ce7760/resources/PhoneNumberMetadata.xml), with 245 regions. Data is bundled locally; country selection makes no provider request. Regenerate both clients' lists with `node scripts/generate-phone-countries.mjs` using Node and the repository's Dart SDK on PATH.

## Contract and security

No API contract, migration, server authorization, OTP, MFA or authentication-provider changes in this follow-up. Forms still submit the existing `mobile_e164` format. Server validation remains authoritative. Validation is the existing E.164 shape check, not proof of number ownership or country-specific mobile allocation. Only Philippine local trunk-prefix normalization is applied; other countries should use national significant digits or paste the complete international number.

## Verification

| Check | Result |
| --- | --- |
| Vendor lint, TypeScript, Vitest, production build | Passed; 34 tests |
| Admin lint, TypeScript, Vitest, production build | Passed; 3 tests |
| Buyer `flutter analyze`, `flutter test` | No issues; 28 tests passed |
| Buyer `dart format --output=none --set-exit-if-changed lib test` | Passed; 24 files, no changes |
| Native Flutter visual capture | Passed; 1 capture test, final render inspected with Inter and Material Icons loaded |
| Vendor `npx.cmd playwright test --reporter=list` | 128 passed across eight viewport widths; includes country changes, international paste, control sizing, exact logo spacing and matching heading geometry |
| `node scripts/generate-phone-countries.mjs --check` | Passed; 245 regions |
| Impeccable source detection | No findings |
| `git diff --check` | Passed |
| Gitleaks working diff and new text-file stdin scans | No leaks; staged scan had no staged files |

Desktop/mobile web screenshots and a native Flutter render were reviewed. Captures remain ignored under `.impeccable/review`. The initial native capture lacked its test-only icon-font loader; the capture helper was corrected without changing application icons. An initially overbroad directory secret-scan invocation included unrelated workspace contents; the final scans above explicitly cover the working diff and new source files.

## Remaining manual checks

No new keys or environment variables are required. Real-provider registration, physical keyboard/autofill and TalkBack/VoiceOver behavior still need device smoke testing. An updated native APK and iOS build were not produced for this follow-up.

- Confirm +63 remains selected when the national number is cleared.
- Select another country, paste a complete international number, and verify the saved contact after registration in the configured development environment.
- Check keyboard navigation, errors, autofill, and large text on an actual phone.

Suggested commit: `feat(ui): unify country-code inputs and portal branding`
