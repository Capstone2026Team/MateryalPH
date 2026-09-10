# MateryalPH local infrastructure

The Docker stack provides PostgreSQL 16 with PostGIS, `pg_trgm`, and `pgcrypto`; Redis; Mailpit; private S3-compatible MinIO storage; the Laravel API; a queue worker; and the Laravel scheduler.

1. Run `powershell -ExecutionPolicy Bypass -File scripts/setup-local.ps1` once. It creates ignored local environment files and random development-only credentials without printing their values.
2. Run `docker compose up -d postgres redis mailpit minio`.
3. Run `docker compose run --rm api composer install`.
4. Run `docker compose run --rm api php artisan migrate --seed`.
5. Run `docker compose run --rm api php artisan passport:keys` if ignored local Passport keys do not exist.
6. Run `docker compose up api horizon scheduler`. Both `horizon` and `scheduler` are required: the worker sends queued mail, while the scheduler re-enqueues durable outbox events that were committed when the queue was unavailable.

On a new PostgreSQL volume, the container also creates the isolated `materyalph_test` database used by `services/api/phpunit.xml`. If the named volume predates this setup and that database is absent, create it once with `docker compose exec postgres sh -lc 'createdb -U "$POSTGRES_USER" -O "$POSTGRES_USER" "${POSTGRES_TEST_DB:-materyalph_test}"'`. Automated tests must never point at `materyalph_dev` or another working database because Laravel's database-refresh tests rebuild their target schema.

Email OTP and initial Admin-invitation events are committed to `outbox_events` in the same PostgreSQL transaction as their source credential record. Their recipient, OTP, and invitation URL are stored only inside an application-encrypted `sealed_payload`. The worker processes each event under a distributed lock and records `processed_at`; failures use bounded backoff and stop automatic dispatch after five recorded attempts. Operators can enqueue eligible pending events manually with `php artisan materyalph:outbox-dispatch --limit=100`. Exhausted events require investigation rather than an unlimited retry loop, and logs or support output must never include the decrypted payload.

Stop the application with `docker compose down`. Named PostgreSQL, Redis, MinIO, and Composer volumes are retained. Do not use `docker compose down -v` unless the development data has been deliberately backed up or is intentionally disposable.

Mailpit is available at `http://localhost:8025`; MinIO Console is at `http://localhost:9001`. Do not reuse generated development credentials in Staging or Production.

## Phase 1 bot-protection setup

Enable the reCAPTCHA Enterprise API in the Development Google Cloud project.
Create one Enterprise checkbox key for Vendor web and restrict it to the actual
Vendor hostname. Create a separate backend API key restricted to
`recaptchaenterprise.googleapis.com`. Enter values only in ignored local files.

Backend variables: `RECAPTCHA_ENABLED`, `RECAPTCHA_GOOGLE_CLOUD_PROJECT_ID`,
`RECAPTCHA_ENTERPRISE_API_KEY`, `RECAPTCHA_VENDOR_WEB_SITE_KEY`,
`RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES`,
and `BOT_STEP_UP_TTL_MINUTES` (default `5`).

Vendor uses `VITE_RECAPTCHA_SITE_KEY` in its ignored local environment file.
Buyer mobile and Admin web do not use reCAPTCHA. Android/iOS Google OIDC client
IDs remain separate OIDC configuration. Never put the backend API key in any
client. Restart processes after configuration changes. The Classic
`RECAPTCHA_SECRET_KEY` is retired.

Development may use an API-restricted backend key without an IP restriction;
`localhost` is not a supported API-key IP restriction. Staging hostname and
stable external egress IP must be supplied before Staging acceptance.
iOS smoke tests require macOS with Xcode and a supported iOS target.

### Safe Development preflight

Run `php scripts/recaptcha-preflight.php` from the repository root to check loaded
backend configuration without printing values. Add `--probe-provider` to make one
deliberately invalid-token Vendor web assessment. A rejected invalid token proves
connectivity only; it does not replace a real Vendor checkbox-token smoke test.

On this Windows installation, native PHP reported cURL error 60. The installed
Git for Windows CA bundle worked with certificate verification still enabled:

```powershell
php -d 'curl.cainfo=C:/Program Files/Git/mingw64/etc/ssl/certs/ca-bundle.crt' scripts/recaptcha-preflight.php --probe-provider
```

This override applies only to that command. Configure a maintained trusted CA bundle
for other native PHP processes, or use the approved Docker runtime. Never disable
TLS peer or hostname verification.

Backend site keys do not automatically configure clients. Create ignored
`apps/vendor-web/.env.local` using its `.env.example` and populate
`VITE_RECAPTCHA_SITE_KEY` with the Development Vendor web site key. Create ignored
`apps/buyer-mobile/config/development.json` from `environment.example.json` only
for Buyer runtime and Google OIDC settings; it has no reCAPTCHA fields. Pass that
file to Flutter with `--dart-define-from-file=config/development.json`. Do not copy
the backend API key to either client. Clear a shell's `DEBUG` variable before a
Windows Flutter build so Gradle's wrapper does not echo command-line defines.

The observed native `postgresql-x64-18` service is not evidence of the approved
PostgreSQL 16/PostGIS stack. Resolve any port 5432 conflict before starting Compose;
do not reset its password, delete its data, or stop unrelated services automatically.
Database-backed acceptance must use the disposable `materyalph_test` database.
