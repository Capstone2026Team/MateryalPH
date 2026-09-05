# MateryalPH

MateryalPH is a geolocation-based construction-material marketplace with separate Buyer, Vendor, and Admin experiences backed by one versioned API.

## Repository layout

- `apps/buyer-mobile` — Flutter/Dart Buyer application.
- `apps/vendor-web` — React 19, strict TypeScript, Vite 8, and Tailwind CSS Vendor portal.
- `apps/admin-web` — React 19, strict TypeScript, Vite 8, and Tailwind CSS Admin portal.
- `services/api` — Laravel 13 API; PHP 8.4 is the reference runtime.
- `packages/api-contract` — OpenAPI 3.1 contract foundation and generated-client boundary.
- `packages/design-tokens` — canonical semantic design tokens and generated platform outputs.
- `packages/web-ui` — shared accessible React primitives.
- `packages/shared-config` — shared strict TypeScript configuration.

Product behavior is defined by `docs/workflows`, architecture by `docs/architecture/MateryalPH_Technical_System_Design.md`, and interface implementation by `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`.

## Prerequisites

- PHP 8.4 and Composer 2
- Node.js 24 or newer
- Flutter and Dart
- PostgreSQL 16 with PostGIS, `pg_trgm`, and `pgcrypto`
- A Redis-compatible cache and queue service

Do not create local environment files until the repository-root `.gitignore` has been verified. Use only the safe committed examples described in `docs/architecture/MateryalPH_Environment_and_API_Key_Setup.md`; never commit real credentials.

## Local development

### API

```powershell
Set-Location services/api
composer install
php artisan serve --host=127.0.0.1 --port=8080
```

The scaffold API is exposed under `http://127.0.0.1:8080/api/v1`.

### Vendor portal — port 5173

```powershell
Set-Location apps/vendor-web
npm install
npm run dev
```

### Admin portal — port 5174

```powershell
Set-Location apps/admin-web
npm install
npm run dev
```

### Buyer application

```powershell
Set-Location apps/buyer-mobile
flutter pub get
flutter run
```

## Validation

Run the checks relevant to a change from the owning directory:

```powershell
# services/api
composer validate --strict
vendor/bin/pint --test
php artisan test

# each React portal
npm run typecheck
npm run lint
npm run build

# apps/buyer-mobile
flutter analyze
flutter test

# repository root after project-local installation
npx impeccable detect apps/vendor-web/src apps/admin-web/src
```

The approved authentication target is Laravel Passport. See `docs/adr/0001-api-authentication-passport.md` for the controlled transition from the scaffold's Sanctum dependency.
