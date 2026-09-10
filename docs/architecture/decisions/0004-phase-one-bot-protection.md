# Phase 1 Vendor reCAPTCHA Enterprise checkbox and email risk verification

Status: implemented; real-provider acceptance remains open.

Phase 1 uses a reCAPTCHA Enterprise checkbox only for Vendor web email
registration, password login, and password recovery. Buyer mobile, Admin, and
Google OIDC do not use reCAPTCHA. The server fixes the protected actions as
`vendor_register`, `vendor_login`, and `vendor_password_recovery`; clients cannot
select a CAPTCHA platform.

Vendor renders the checkbox explicitly with `grecaptcha.enterprise.render(...)`
and an action bound to the protected operation. The token is cleared and the
widget is reset after submission, expiration, or provider error. Assessment
occurs only in Laravel through a replaceable gateway. The backend API key is sent
in `x-goog-api-key`, never a query string. Provider exceptions do not retain raw
request or response data. Laravel validates token validity, action, configured
Vendor site key, and allowed web hostname. No score threshold is used.

An invalid assessment, accessible email fallback, missing token, or temporary
provider failure requires a separate `BOT_RISK_STEP_UP` OTP. It does not replace
account verification or password reset. Login checks credentials before issuing
mail. Recovery of an unmatched account does not send mail.

Challenges bind the email hash, portal, server action, and internal channel. OTP
creation and encrypted outbox publication share the challenge transaction.
Verification and proof consumption lock challenge rows. Failed OTP attempts must
commit even when verification returns an error. Proofs expire after five minutes
and can be consumed once. Only proof hashes are persisted. Vendor web proof
delivery uses an HttpOnly auth-path cookie. Buyer retains a separate server-driven
email risk-proof foundation and never sends CAPTCHA evidence. No reCAPTCHA token
is persisted or logged.

The queue worker and scheduler remain mandatory. A queued email is not evidence
of delivery. Real Mailpit, Google OIDC, and Vendor checkbox assessment smoke tests
remain required before Phase 1 acceptance.

The Enterprise adapter uses a backend-only API key restricted to
`recaptchaenterprise.googleapis.com`. The Vendor checkbox key is restricted to
the approved Vendor hostname. Google OIDC Android/iOS client IDs remain separate
OIDC configuration and are not reCAPTCHA keys.

References: [Enterprise checkbox installation](https://docs.cloud.google.com/recaptcha/docs/instrument-web-pages-with-checkbox),
[website assessment](https://docs.cloud.google.com/recaptcha/docs/create-assessment-website),
[key restrictions](https://docs.cloud.google.com/recaptcha/docs/reference/rest/v1/projects.keys).
