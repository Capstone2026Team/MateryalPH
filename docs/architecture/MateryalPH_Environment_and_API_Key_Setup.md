# MateryalPH Environment and API-Key Setup

**Purpose:** Safe Development, Staging, and Production configuration for the MateryalPH monorepo  
**Rule:** Paste real values only into ignored local environment files or protected provider secret fields. Never paste a real key into Codex, ChatGPT, source code, documentation, an issue, or a Git commit.

## 1. Environment Model

MateryalPH uses three completely isolated environments:

| Environment | Name suffix | Purpose | Allowed payment mode |
| --- | --- | --- | --- |
| Development | `DEV` | Local coding and automated tests | Fake gateway or Xendit Test Mode |
| Staging | `STAGING` | Hosted integration and UAT | Xendit Test Mode only |
| Production | `PROD` | Approved live users and transactions | Live mode only after all release gates |

Use the same variable names in each isolated environment. The file, cloud project, resource, and secret store identify the environment. Do not create error-prone names such as `DEV_DB_PASSWORD`, `STAGING_DB_PASSWORD`, and `PROD_DB_PASSWORD` inside one file.

### Local file names

| Application | Development | Optional local Staging check | Committed example |
| --- | --- | --- | --- |
| Laravel API | `services/api/.env` | `services/api/.env.staging` | `services/api/.env.example` |
| Vendor web | `apps/vendor-web/.env.development.local` | `.env.staging.local` | `apps/vendor-web/.env.example` |
| Admin web | `apps/admin-web/.env.development.local` | `.env.staging.local` | `apps/admin-web/.env.example` |
| Buyer Flutter | `apps/buyer-mobile/config/development.json` | `config/staging.json` | `apps/buyer-mobile/config/environment.example.json` |
| Android native config | `android/secrets.properties` | flavor-specific ignored file | `android/secrets.properties.example` |
| iOS native config | ignored `.xcconfig` | flavor-specific ignored file | committed `.xcconfig.example` |

Staging and Production hosted secrets belong in GitHub/Render/provider environment settings. Do not commit a populated `.env.staging` or `.env.production` file.

## 2. Create `.gitignore` Before the First Commit

Create the repository-root `.gitignore` before creating or downloading credentials. At minimum it must contain:

```gitignore
# Environment files
.env
.env.*
!.env.example
!**/.env.example
!**/*.example.json
!**/*.example.properties
!**/*.example.xcconfig

# Flutter environment and signing
apps/buyer-mobile/config/development.json
apps/buyer-mobile/config/staging.json
apps/buyer-mobile/config/production.json
apps/buyer-mobile/android/secrets.properties
apps/buyer-mobile/android/key.properties
apps/buyer-mobile/android/app/google-services.json
apps/buyer-mobile/ios/Runner/GoogleService-Info.plist
apps/buyer-mobile/ios/Flutter/*.xcconfig.local
*.jks
*.keystore
*.p12
*.mobileprovision

# OAuth and service-account material
services/api/storage/oauth-private.key
services/api/storage/oauth-public.key
**/*service-account*.json
**/credentials*.json

# Dependency/build output
services/api/vendor/
apps/*/node_modules/
apps/*/dist/
apps/buyer-mobile/.dart_tool/
apps/buyer-mobile/build/

# Local runtime data
services/api/storage/logs/*.log
.idea/
.vscode/settings.local.json

# impeccable-ignore-start
# Ephemeral design-review output, runtime state, and per-developer overrides.
.impeccable/config.local.json
.impeccable/hook.cache.json
.impeccable/hook.pending.json
.impeccable/*.png
.impeccable/review/
.impeccable/questions/
.impeccable/live/server.json
.impeccable/live/sessions/
.impeccable/live/previews/
.impeccable/live/annotations/
.impeccable/live/cache/
.impeccable/live/manual-edit-apply-transaction.json
.impeccable/live/manual-edit-events.jsonl
.impeccable/live/manual-edit-evidence/
.impeccable/live/pending-manual-edits.json
.impeccable/live/deferred-svelte-component-accepts.json
.impeccable/live/*.png
# impeccable-ignore-end
```

Keep `.impeccable/config.json`, `.impeccable/live/config.json`, `.impeccable/design.json`, `.impeccable/surfaces/*.md`, and `.impeccable/critique/*.md` tracked because they are reviewed shared design artifacts. The ignored screenshots and runtime files may contain page content or test data and must not enter Git accidentally.

Immediately verify before the first commit:

```bash
git status --short
git check-ignore -v services/api/.env
git check-ignore -v apps/vendor-web/.env.development.local
git check-ignore -v apps/buyer-mobile/config/development.json
```

If any populated credential file is not ignored, stop and fix `.gitignore` before continuing.

## 3. Secret Classification

An environment variable is not automatically secret. Anything placed in a web or mobile build can be recovered by a user. Client-side keys must therefore be treated as public identifiers and protected by platform restrictions and quotas.

| Value | Location | Secret? | Rule |
| --- | --- | :---: | --- |
| Laravel `APP_KEY` | API only | Yes | Different in every environment |
| Passport private signing key | API only | Yes | Never in a client or Git |
| Passport public key | API services | No | Still environment-specific |
| Google OAuth client secret | API only | Yes | Server exchange only |
| Google OAuth client IDs | Clients/API | No | Restrict redirect URI/package/bundle |
| Google Maps Android/iOS/browser key | Respective client | No | Separate key per platform and environment; restrict it |
| Google Maps server key | API only | Yes | IP/API restricted where the platform permits |
| Xendit secret API key | API only | Yes | Never use `VITE_` or Flutter config |
| Xendit callback token | API only | Yes | Constant-time comparison |
| Firebase service account | API only | Yes | Used only for server-to-FCM requests |
| Firebase client configuration | Client | No | Separate project/flavor and restrict where supported |
| SMTP/API credential | API only | Yes | Use a scoped sending credential |
| S3 access key/secret | API only | Yes | Bucket-scoped, least privilege |
| Sentry DSN | Each app | Usually public identifier | Separate project/environment; do not put auth token in clients |
| Sentry auth token | CI only | Yes | Used only for release/source-map tasks |
| reCAPTCHA site key | Client | No | Domain/app restricted |
| reCAPTCHA secret | API only | Yes | Never exposed to clients |

## 4. Backend `.env.example`

The committed `services/api/.env.example` documents names without real values:

```dotenv
APP_NAME=MateryalPH
APP_ENV=development
APP_KEY=
APP_DEBUG=false
APP_URL=http://localhost:8080
APP_TIMEZONE=UTC
BUSINESS_TIMEZONE=Asia/Manila

LOG_CHANNEL=stack
LOG_LEVEL=debug
LOG_REDACT_SENSITIVE=true

DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=materyalph_dev
DB_USERNAME=materyalph_dev
DB_PASSWORD=
DB_SSLMODE=prefer

CACHE_STORE=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
REDIS_URL=redis://redis:6379

FRONTEND_BUYER_REDIRECT_URI=
FRONTEND_VENDOR_URL=http://localhost:5173
FRONTEND_ADMIN_URL=http://localhost:5174
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://localhost:5174
SESSION_DOMAIN=localhost
COOKIE_SECURE=false
COOKIE_SAME_SITE=lax

PASSPORT_PRIVATE_KEY_BASE64=
PASSPORT_PUBLIC_KEY_BASE64=
PASSPORT_ACCESS_TOKEN_MINUTES=15
PASSPORT_REFRESH_TOKEN_DAYS=14

EMAIL_OTP_TTL_MINUTES=10
EMAIL_OTP_MAX_ATTEMPTS=5
EMAIL_OTP_RESEND_SECONDS=60
RECENT_AUTH_TTL_MINUTES=15

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_ENCRYPTION=
MAIL_FROM_ADDRESS=no-reply@materyalph.test
MAIL_FROM_NAME=MateryalPH

GOOGLE_OIDC_CLIENT_ID=
GOOGLE_OIDC_CLIENT_SECRET=
GOOGLE_OIDC_REDIRECT_URI=http://localhost:8080/api/v1/auth/google/callback
GOOGLE_OIDC_ANDROID_CLIENT_ID=
GOOGLE_OIDC_IOS_CLIENT_ID=
GOOGLE_MAPS_SERVER_API_KEY=

RECAPTCHA_ENABLED=false
RECAPTCHA_SECRET_KEY=
RECAPTCHA_MIN_SCORE=

XENDIT_MODE=test
XENDIT_SECRET_KEY=
XENDIT_WEBHOOK_TOKEN=
XENDIT_BASE_URL=
XENDIT_PLATFORM_ACCOUNT_ID=

FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=auto
AWS_BUCKET=materyalph-dev-private
AWS_ENDPOINT=http://minio:9000
AWS_USE_PATH_STYLE_ENDPOINT=true
AWS_URL=

FIREBASE_PROJECT_ID=
FIREBASE_SERVICE_ACCOUNT_JSON_BASE64=

BROADCAST_CONNECTION=reverb
REVERB_APP_ID=materyalph-dev
REVERB_APP_KEY=
REVERB_APP_SECRET=
REVERB_HOST=localhost
REVERB_PORT=8081
REVERB_SCHEME=http

SENTRY_LARAVEL_DSN=
SENTRY_ENVIRONMENT=development
SENTRY_TRACES_SAMPLE_RATE=0.0
```

Do not add a real value to this example. Tests must use isolated test configuration and fake providers.

## 5. Web Client Examples

Only values safe to expose in a browser bundle may use `VITE_`.

```dotenv
# apps/vendor-web/.env.example and apps/admin-web/.env.example
VITE_APP_ENV=development
VITE_API_BASE_URL=http://localhost:8080/api/v1
VITE_REVERB_APP_KEY=
VITE_REVERB_HOST=localhost
VITE_REVERB_PORT=8081
VITE_REVERB_SCHEME=http
VITE_GOOGLE_MAPS_BROWSER_KEY=
VITE_RECAPTCHA_SITE_KEY=
VITE_SENTRY_DSN=
```

Never add Xendit secret keys, Google OAuth client secrets, SMTP passwords, storage secrets, Passport private keys, or Firebase service-account JSON to a Vite variable.

## 6. Flutter Environment Example

The committed `config/environment.example.json` contains empty/public build-time values only:

```json
{
  "APP_ENV": "development",
  "API_BASE_URL": "http://10.0.2.2:8080/api/v1",
  "GOOGLE_OIDC_CLIENT_ID": "",
  "GOOGLE_OIDC_SERVER_CLIENT_ID": "",
  "SENTRY_DSN": "",
  "RECAPTCHA_SITE_KEY": ""
}
```

Native Google Maps keys belong in ignored flavor-specific properties/configuration consumed through manifest placeholders. Firebase client configuration files are environment-specific and ignored under the user's security policy. They are not server secrets, but they must not be reused across environments.

Run a Development build with an ignored configuration file:

```bash
flutter run --dart-define-from-file=config/development.json
```

## 7. Generate Local Application Secrets

### 7.1 Laravel application key

From `services/api`, copy the example and generate a key directly into the ignored `.env`:

```bash
cp .env.example .env
php artisan key:generate
```

`key:generate` updates `.env`. Do not use `--show` because that prints the key to the terminal.

### 7.2 Strong caller-generated secrets

On Windows PowerShell, the following creates 48 random bytes and copies the Base64 result to the clipboard without displaying it:

```powershell
$secretBytes = New-Object byte[] 48
[Security.Cryptography.RandomNumberGenerator]::Fill($secretBytes)
[Convert]::ToBase64String($secretBytes) | Set-Clipboard
Remove-Variable secretBytes
```

Paste it into the intended ignored `.env` line in VS Code, save, then clear the clipboard by copying harmless text. Generate a new value for every secret and every environment; never reuse one value.

### 7.3 Passport signing keys

Generate keys into the ignored Laravel storage paths:

```bash
php artisan passport:keys --force
```

Use PowerShell to copy each file as Base64 without printing it:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("storage/oauth-private.key")) | Set-Clipboard
```

Paste into `PASSPORT_PRIVATE_KEY_BASE64` in the ignored API `.env`. Then copy the public key:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("storage/oauth-public.key")) | Set-Clipboard
```

Paste into `PASSPORT_PUBLIC_KEY_BASE64`. The Phase 1 configuration decodes these at runtime. After confirming login works, remove the temporary key files from local storage if the application no longer needs them. Generate completely new keys for Staging and Production.

## 8. Google Cloud Setup

Create separate Google Cloud projects named clearly, for example:

- `MATERYALPH-DEV`
- `MATERYALPH-STAGING`
- `MATERYALPH-PROD`

Repeat the following per environment.

### 8.1 Create the project and billing boundary

1. Open Google Cloud Console.
2. Create or select the correct MateryalPH environment project.
3. Attach the intended billing account and configure a budget/usage alert.
4. Enable only required APIs:
   - Maps SDK for Android.
   - Maps SDK for iOS if iOS is built.
   - Maps JavaScript API for the Admin map.
   - Places API (New).
   - Routes API.
   - The selected geocoding capability.
5. Review quotas before enabling hosted traffic.

Google requires billing and credentials for Places and recommends key restrictions. See [Places setup](https://developers.google.com/maps/documentation/places/web-service/get-api-key) and [Maps API security](https://developers.google.com/maps/api-security-best-practices).

### 8.2 Create separate Maps keys

Create four keys rather than one shared key:

1. **Android key:** restrict by Android application, package name, and signing-certificate SHA fingerprint; restrict APIs to Maps SDK for Android.
2. **iOS key:** restrict by iOS bundle identifier; restrict APIs to Maps SDK for iOS.
3. **Browser key:** restrict by exact local/Staging/Production HTTP referrers; restrict APIs to Maps JavaScript API.
4. **Server key:** restrict APIs to Places API (New), Routes, and selected geocoding API. Apply server IP restrictions when stable outbound addresses are available; otherwise use the strongest supported platform control, quotas, and monitoring.

Paste locations:

| Key | Development destination |
| --- | --- |
| Android | ignored `apps/buyer-mobile/android/secrets.properties` |
| iOS | ignored environment `.xcconfig` |
| Browser | Vendor/Admin `.env.development.local` only if that portal uses Maps |
| Server | `services/api/.env` as `GOOGLE_MAPS_SERVER_API_KEY` |

### 8.3 Configure Google OpenID Connect

1. Configure the OAuth consent/branding screen for the correct environment.
2. Add only the minimum identity scopes: `openid`, `email`, and `profile`.
3. Create a Web OAuth client for the Laravel server exchange.
4. Add exact redirect URIs, for example Development `http://localhost:8080/api/v1/auth/google/callback` and the exact Staging/Production HTTPS callback.
5. Create Android and iOS clients using their package/bundle and signing identity.
6. Copy the Web client ID to `GOOGLE_OIDC_CLIENT_ID`.
7. Copy the Web client secret to backend `GOOGLE_OIDC_CLIENT_SECRET` only.
8. Copy platform client IDs to their public client configuration.
9. Never use email as the permanent Google identity. The backend validates the ID token and stores `sub`.

Google documents the server-side authorization-code exchange and ID-token validation in [OpenID Connect](https://developers.google.com/identity/openid-connect/openid-connect).

## 9. Xendit Test Mode Setup

Use Test Mode throughout Development, Staging, demonstrations, and automated integration testing.

1. Create and verify the authorized Xendit account.
2. Enter the Xendit dashboard and switch clearly to Test Mode.
3. Open API Keys settings.
4. Create a Development secret key with only the permissions required for the implemented payment/sub-account/refund endpoints.
5. Copy the secret once and paste it into `services/api/.env` as `XENDIT_SECRET_KEY`.
6. Set `XENDIT_MODE=test`.
7. Configure the local webhook through an approved HTTPS tunnel only for temporary Development testing, or use Staging for stable webhook tests.
8. In Xendit Webhook settings, register the exact Staging endpoint: `https://<staging-api>/api/v1/webhooks/xendit`.
9. Copy the callback token and paste it into the backend secret field as `XENDIT_WEBHOOK_TOKEN`.
10. Never put either value into Flutter, React, OpenAPI examples, Postman collections committed to Git, or screenshots.
11. Run Xendit's supported success and error simulations and verify duplicate/reordered webhook behavior.

Xendit states that Test Mode transactions do not interact with banking networks and that the secret key is used for API authentication; see [Xendit API quick setup](https://docs.xendit.co/apidocs/quick-setup). Xendit also recommends checking the callback token and matching webhook transaction details; see [integration security](https://docs.xendit.co/docs/integration-security).

For Production, do not simply replace `test` with `live`. First confirm:

- Live account approval.
- xenPlatform/sub-account capability.
- Permitted payment channels in the Philippines.
- Full and partial refund behavior per enabled channel.
- Fee treatment and contractual permission to pass the disclosed processing amount to the Buyer.
- Callback endpoints and live callback token.
- Legal, privacy, tax, and finance approval.

## 10. Firebase Cloud Messaging Setup

Create `MATERYALPH-DEV`, `MATERYALPH-STAGING`, and `MATERYALPH-PROD` Firebase projects or use matching isolated Firebase projects linked to the corresponding Google projects.

1. Add the Buyer Android application using the exact environment package ID.
2. Add iOS using the exact environment bundle ID if iOS is included.
3. Download environment-specific client configuration files.
4. Place them only in the ignored paths documented above.
5. Enable Cloud Messaging.
6. For the Laravel server, create a narrowly controlled service account or approved credential capable of sending FCM messages.
7. Download the JSON only to a secure temporary location.
8. Encode it to Base64 without printing it and paste into `FIREBASE_SERVICE_ACCOUNT_JSON_BASE64` in the backend environment.
9. Delete the temporary downloaded copy after verifying the protected copy and recovery process.
10. Request notification permission contextually in the Buyer app; do not block core use when denied.

Firebase documents platform permission and foreground/background/terminated behavior in [FCM for Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages).

## 11. Email Provider Setup

Development uses Mailpit and does not send external email. For Staging and Production:

1. Choose an approved transactional email provider supported by Laravel SMTP or API transport.
2. Create separate Staging and Production sender domains/subdomains.
3. Configure SPF, DKIM, and DMARC according to the provider.
4. Create a send-only environment credential.
5. Paste it into the protected backend mail variables.
6. Use a non-production recipient allowlist in Staging to prevent accidental messages to real users.
7. Test OTP, recovery, security alert, order, dispute, and compliance templates.
8. Monitor bounce and delivery failure without logging message secrets or excessive personal data.

## 12. Private Object Storage Setup

The local Docker environment uses S3-compatible storage. For hosted environments:

1. Create separate private buckets such as `materyalph-staging-private` and `materyalph-prod-private`.
2. Disable public listing and anonymous reads.
3. Create a bucket-scoped application credential with only required object operations.
4. Configure encryption, lifecycle rules, versioning where appropriate, and access logging.
5. Configure narrow CORS only if direct signed uploads are used.
6. Paste access key, secret, endpoint, region, and bucket into the backend protected environment.
7. Never expose raw object keys or permanent public URLs.
8. Test authorized short-lived signed download, cross-Vendor denial, expiry, and deleted/retained state.

## 13. Reverb Setup

Generate separate random `REVERB_APP_KEY` and `REVERB_APP_SECRET` values per environment. These are MateryalPH-owned values, not a third-party account key.

- `REVERB_APP_SECRET` is backend-only.
- The app key may be placed in the web client and Flutter public configuration because channel authorization still occurs on the backend.
- Production uses `wss`/HTTPS and exact allowed origins.
- Never authorize a private channel only by knowing its name.

## 14. reCAPTCHA and Sentry

These are introduced only in the hardening phase.

### reCAPTCHA

1. Create separate Development/Staging/Production sites or keys.
2. Restrict each site key to its exact domains/app identifiers.
3. Put the site key only in the relevant client environment.
4. Put the secret only in the backend environment.
5. Keep `RECAPTCHA_ENABLED=false` until server verification, accessible fallback, rate limiting, and error handling are implemented.
6. Do not use reCAPTCHA as the only abuse defense.

### Sentry

1. Create separate projects for Laravel, Vendor web, Admin web, and Buyer mobile.
2. Tag events with Development/Staging/Production.
3. Put DSNs in each app's environment configuration.
4. Keep source-map/release auth tokens only in protected CI secrets.
5. Configure personal-data scrubbing before enabling event transmission.
6. Test that passwords, tokens, OTPs, Xendit payload secrets, private file links, and unnecessary Buyer addresses are not captured.

## 15. GitHub Secrets and Environments

1. Create protected GitHub environments named `STAGING` and `PRODUCTION`.
2. Store only CI-required values there, such as signing credentials, source-map token, and deployment trigger/API values if used.
3. Use environment reviewers for Production.
4. Give workflows minimum `permissions` and do not expose secrets to untrusted pull requests.
5. Mask any nonstandard sensitive value if a tool might print it.
6. Keep provider runtime secrets in Render rather than copying every runtime secret into GitHub.

GitHub's official guidance covers repository, organization, and environment secrets and how they are referenced in workflows: [Using secrets in GitHub Actions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets).

## 16. Render Staging and Production Setup

The repository's `render.yaml` defines resources but never real secret values.

### Staging

1. Connect the Git repository to Render.
2. Create a `MATERYALPH-STAGING` project/environment in Singapore.
3. Review the Blueprint resources before applying them.
4. Create the managed PostgreSQL 16 database and enable:

   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   CREATE EXTENSION IF NOT EXISTS pg_trgm;
   CREATE EXTENSION IF NOT EXISTS pgcrypto;
   ```

5. Create the managed Redis-compatible Key Value service.
6. Create the API, worker, scheduler, Reverb, Vendor static, and Admin static services.
7. In each service's Environment page, paste only that service's required Staging values.
8. Mark secret values protected and prevent them from being copied into logs.
9. Use Xendit Test Mode.
10. Add exact Staging domains to CORS, cookie, OAuth callback, Google referrer, and Reverb-origin allowlists.
11. Set auto-deploy to occur only after CI checks pass.
12. Run migrations through the controlled pre-deploy step.
13. Run smoke tests and rehearse rollback.

### Production

Repeat with completely new `MATERYALPH-PROD` resources and credentials only after Phase 20 approval. Do not clone Staging secrets. Production must have backups, alerting, restricted Admin access, debug disabled, and test seeders blocked.

Render documents environment-group/resource configuration in its [Blueprint specification](https://render.com/docs/blueprint-spec), automatic deployment after CI in [Deploys](https://render.com/docs/deploys), and managed HTTPS in [TLS](https://render.com/docs/tls).

## 17. Quarterly Rotation Register

Maintain `docs/security/secret-register.example.md` without values. The protected operational copy belongs in an approved private system.

| Secret ID | Environment | Owner | Provider | Created | Rotate by | Last tested | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `APP_KEY` | STAGING | Assigned owner | MateryalPH | Date only | +90 days | Date only | Active |
| `XENDIT_SECRET_KEY` | STAGING | Assigned owner | Xendit | Date only | +90 days | Date only | Active |

Rotation procedure:

1. Identify all consumers without exposing the value.
2. Create a new environment-specific key with least privilege.
3. Add it through the protected secret interface.
4. Deploy/restart the affected services safely.
5. Run health and provider-specific smoke tests.
6. Revoke the previous key after the overlap period.
7. Record date, owner, result, and next rotation date without recording the value.
8. For signing/encryption keys, use the documented multi-key transition process so active sessions/data are not accidentally broken.

## 18. Exposure Response

If a secret is committed, posted, emailed, shown in chat, logged, or otherwise exposed:

1. Treat it as compromised even if the message or commit is deleted.
2. Revoke or rotate it immediately at the provider.
3. Replace it in each affected environment with a new non-reused value.
4. Review provider and application access logs.
5. Remove it from current files and, with explicit approval, clean Git history using a safe coordinated process.
6. Invalidate affected sessions, signing keys, or transactions as required.
7. Document the incident, impact, response, and prevention change without copying the secret.

Deleting `.env` or rewriting the latest commit alone does not restore control over an exposed key.

## 19. Pre-Commit Secret Check

Before every commit:

```bash
git status --short
git diff --cached --name-only
git diff --cached
gitleaks git --staged
```

If `gitleaks` is not installed, install it through the approved workstation process during Phase 1. CI repeats secret scanning; local review is still required.

## 20. Safe Key-Pasting Checklist

When this guide says “paste the key”:

1. Confirm the provider dashboard is in the correct `DEV`, `STAGING`, or `PROD` project.
2. Confirm the destination is an ignored local file or protected cloud secret field.
3. Confirm the variable belongs on the backend or client according to the classification table.
4. Paste the value without quotes unless the format requires quoting; multiline values should use the project's documented Base64 field.
5. Save and run `git check-ignore` for local files.
6. Clear the clipboard.
7. Test through a safe status/health operation.
8. Never ask Codex to print or repeat the value.

This process satisfies the user's non-negotiable requirement: `.env` is never committed, secrets are strong and environment-specific, example files contain names without values, and Development, Staging, and Production credentials remain isolated.
