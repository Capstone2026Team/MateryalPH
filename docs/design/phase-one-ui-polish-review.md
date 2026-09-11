# Phase 1 interface refinement

## Outcome and design approach

Refined the existing Inter/orange design system across Buyer, Vendor and Admin. The work prioritizes readable account tasks, clear recovery actions and truthful foundation states. No marketplace operations, roles, payment rules or database migrations were added. No commit, deployment, credential change or Passport key regeneration was performed.

Issues found included technical payment/deployment copy on the public landing page, browser callback failures falling back to JSON, missing web password visibility, small supporting text, an overly large Buyer welcome illustration, registration overflow at large text scales, and shared web utilities missing from production CSS because Tailwind did not scan the linked UI package. Rendered review also caught keyboard focus styling being overridden on shared inputs.

The public landing page retains an illustrative inquiry and planned workspace preview, with registration and verification clearly distinguished from activation. The authenticated screens show account access without fabricated commerce activity. Vendor uses a warm explanatory sidebar; Admin uses a quieter neutral sidebar; Buyer uses touch-oriented, scrollable layouts.

## Changed surfaces and reusable components

| Area | Changes |
| --- | --- |
| Buyer splash and welcome | Simplified startup branding without delays, supplied illustration, clearer account CTA hierarchy, Google loading state, proportionate brand lockup |
| Buyer onboarding | Updated all three supplied transparent-background images; removed the unsupported no-delays promise; retained three slides, Skip/Next and first-use persistence |
| Buyer forms | Shared `AuthContent` constrains reading width and supports keyboard dismissal/scrolling; `AuthNotice` provides an icon, readable text and live-region semantics |
| Buyer login/registration | Google entry on login, password controls retained, multiline hints/errors, flexible registration divider and expanded Buyer-type dropdown |
| Buyer OTP/recovery | Adaptive code spacing, existing paste/numeric entry and cooldown retained; confirmation password field and explicit reset-success state |
| Buyer Google/foundation | Safe Google error mappings, cold-start callback notification fix, clearer signed-in foundation and retryable logout failures |
| Shared web Field | Accessible Show/Hide controls, retained values and autocomplete, linked labels/errors, visible focus; React deduplication in both portal builds/tests |
| Vendor authentication | Shared hierarchy and spacing across login, registration, email verification, recovery, Google signup, callback, MFA and foundation; successful logout feedback |
| Vendor MFA | Numbered authenticator instructions, local QR/manual entry preserved, prominent recovery-code guidance and existing copy/download/acknowledgment retained |
| Vendor landing | Updated hero, transparent brand mark, calmer composition, deployment-safe fees/FAQ/footer and clear future-capability labeling |
| Admin | Shared shell hierarchy, neutral sidebar, password visibility, improved forms/status presentation and honest foundation state; invitation/TOTP behavior preserved |

## Branding and asset provenance

The supplied white-background files are JPEGs, despite the PNG names in the request. `scripts/generate-brand-assets.ps1` uses `materials/Logo/Icon with name_White background.jpg` for the 64 px web favicons and `Icon with no name_whitebackground.jpg` for the Buyer icon. It preserves aspect ratio on a white square and generates Android's five densities plus every size in the existing iOS asset catalog. The source files remain intact, and a 1024 px Buyer source output is retained under `assets/branding/app-icon.png`.

The transparent `Icon with no name_No background.png` is copied without flattening. All three updated onboarding files are copied directly from `materials/Mobile Onbording Images`. The visible Vendor header/footer/auth label and document title use **MaterialPH Vendor**; internal MateryalPH names remain unchanged.

## API and security

The only backend change is presentation for `/api/v1/auth/google/callback`: browser navigation accepting HTML receives a branded, non-cacheable failure page for validation, supported authentication exceptions and provider connection failures. Existing allowlisted identity-denial redirects remain intact. JSON clients retain canonical error envelopes. Unknown failures do not receive a new authentication bypass or arbitrary redirect.

The HTML view never reflects callback state, authorization codes or provider payloads. It uses local fonts, images and generated semantic tokens, `no-store`, `no-referrer` and `nosniff`. Its navigation uses application-configured destinations. OpenAPI documents HTML/JSON errors and both generated clients were regenerated; generated changes are callback documentation, not new request fields.

Account isolation, PKCE/nonce/state verification, CSRF/cookies, native bearer tokens, OTP limits, MFA enforcement, local QR generation, recovery storage and session revocation remain in their existing implementations. No new API keys or environment variables are required.

## Verification

| Gate | Result |
| --- | --- |
| Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd test -- --run`, `npm.cmd run build` | Passed; 30 tests |
| Admin equivalent commands | Passed; 3 tests |
| `npx.cmd playwright test --reporter=list` in Vendor | 112 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px, covering both portals |
| Buyer `dart format --output=none --set-exit-if-changed lib test`, `flutter analyze`, `flutter test`, `flutter build apk --debug` | Passed; 26 tests, analyzer clean, debug APK built |
| Laravel `php artisan test` in `materyalph_phase1_test-api-test-1` | 64 passed, 748 assertions; dedicated database safety guard retained |
| `php vendor/bin/pint --test` | Passed |
| `php vendor/bin/phpstan analyse --no-progress --memory-limit=1G` | Passed; default 128 MB limit was insufficient |
| OpenAPI `npm.cmd run validate`, `npm.cmd run generate` | Passed; three existing unused future-schema recommendations |
| `node packages/design-tokens/scripts/generate.mjs --check` | Passed |
| Impeccable source scan, both portals | No findings |
| Impeccable rendered `/login`, both portals at 390×844 | No findings after minimum-text/padding corrections |
| Impeccable rendered Vendor landing at 1440×1000 | No findings after FAQ line-length and preview-label corrections |
| `docker compose config --quiet`, `git diff --check` | Passed |
| Gitleaks staged, working-diff and new text-file scans | No leaks; no files were staged |

Screenshots and capture helpers are ignored under `.impeccable/review` or the Buyer build directory. Review covered desktop/mobile web login, Vendor callback and landing, plus native Flutter welcome/onboarding renders. Widget tests cover compact/normal/large phones, 1×/2× text, open keyboards, password visibility, Google error mapping and logout failure. They do not replace physical-device or real-provider acceptance.

## File groups changed

- `apps/buyer-mobile/lib`: theme, app routing/messaging, authentication repository, account/onboarding/foundation screens, brand lockup and new shared `widgets/auth_content.dart`; regression coverage in `test/buyer_app_test.dart` and `test/auth_presentation_test.dart`.
- `apps/buyer-mobile/assets`, Android `mipmap-*` and iOS `AppIcon.appiconset`: supplied onboarding artwork and generated application icons.
- `apps/vendor-web`: landing/authentication components and pages, shared styles, entry document, brand assets, Vite/Vitest configuration, component tests and Playwright reflow/landing tests.
- `apps/admin-web`: authentication shell, app/status presentation, shared styles, entry document, favicon, Vite/Vitest configuration and component tests.
- `packages/web-ui/src/field.tsx`: shared accessible password visibility and field styling.
- `services/api/app/Http/Controllers/Api/Auth/GoogleOidcController.php`, `resources/views/auth/google-failure.blade.php`, `public/auth/*` and `tests/Feature/Api/GoogleCallbackPresentationTest.php`: safe browser callback presentation, local assets and regression tests.
- `packages/api-contract/openapi.yaml` and generated TypeScript/Dart callback documentation; `packages/design-tokens/scripts/generate.mjs` for standalone auth tokens.
- `scripts/generate-brand-assets.ps1` and this review: reproducible assets and implementation evidence. No migrations changed.

## Manual smoke-test checklist

- [ ] Buyer: fresh launch splash → three-slide onboarding; Skip, Next and completion persist; returning launch reaches the correct destination.
- [ ] Buyer: Welcome CTAs, login, registration, Google signup, form errors and password visibility; repeat at compact and normal phone sizes with keyboard open and large text.
- [ ] Buyer: six-digit email OTP paste, invalid/expired code, resend cooldown and exact time; verify success and required email verification.
- [ ] Buyer: forgot/reset password with unknown email, mismatched confirmation, valid reset and return to sign in.
- [ ] Buyer: real Google login/signup, cancellation, wrong account type, expired exchange and cold-start deep link; no provider values appear.
- [ ] Buyer: signed-in foundation, logout success/failure/retry, TalkBack, Android back behavior, launcher icon and system safe areas.
- [ ] Vendor: landing navigation, mobile menu, FAQ, fees and footer contain no test-mode/payment-onboarding disclosure; all registration/sign-in links work.
- [ ] Vendor: email and Google registration/login, reCAPTCHA and email fallback, validation focus, email verification, forgot/reset password.
- [ ] Vendor: cross-portal Google denial, account-not-found, retry with another account, cancellation and expired callback recover safely.
- [ ] Vendor: enrollment QR/manual key, six-digit challenge, recovery codes copy/download/save acknowledgment, session restore and logout.
- [ ] Admin: invited login, invitation acceptance, forgot/reset password, mandatory TOTP enrollment/challenge/recovery and foundation access.
- [ ] Admin: loading, unavailable, empty/foundation states and normal laptop/desktop responsiveness; keyboard-only focus and screen-reader labels.

## Remaining manual gates and limitations

Real Google, reCAPTCHA, email delivery, authenticator scans and physical Android interactions were not exercised with personal accounts. Existing configured providers remain necessary for those checks; no new setup is introduced. iOS icons are generated, but no macOS/iOS build was performed. Flutter reports future-support warnings for the repository's existing Gradle, AGP and Kotlin versions; the Android build still succeeds, and those versions were not changed during UI work. Google-hosted error pages remain under Google's control. Operational marketplace/Admin queues remain unavailable by design.

Suggested commit: `feat(ui): refine phase-one account experiences and branding`
