# MateryalPH - Hybrid Web + Mobile Project

A geolocation-based marketplace for construction material procurement and supplier recommendations.

## Project Structure

This workspace contains:

- **Backend API**: Laravel 11 in `Laravel_Main Application/`
- **Admin Frontend**: React 18 + Vite in `React_Web_interface_Admin/`
- **Vendor Frontend**: React 18 + Vite in `React_Web_interface_Vendor/`
- **Mobile App**: Flutter + Dart in `Flutter_Mobile_Interface_Buyer/`

## Prerequisites

- PHP 8.4+
- laravel 13
- Node.js 18+
- Flutter SDK
- PostgreSQL with PostGIS

## Quick Start

### 1. Start PostgreSQL, ( Database)

```bash
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -h 127.0.0.1 -p 5432 -U materyalph_app -d materyalph
```

### 2. Start the Laravel API

```bash
cd "Laravel_Main Application"
php artisan serve --host=127.0.0.1 --port=8000
```

### 3. Start the Web Applications

**Admin Frontend** (Port 5173):
```bash
cd "React_Web_interface_Admin"
npm install
npm run dev -- --host 127.0.0.1 --port 5173
```

**Vendor Frontend** (Port 5174):
```bash
cd "React_Web_interface_Vendor"
npm install
npm run dev -- --host 127.0.0.1 --port 5174
```

### 4. Start the Mobile App

```bash
cd "Flutter_Mobile_Interface_Buyer"
flutter pub get
flutter run
```

## API Endpoints

- **Health Check**: http://127.0.0.1:8000/api/health
- **Products**: http://127.0.0.1:8000/api/products

## Database Test

- **psql Test**:
```bash
psql -h 127.0.0.1 -p 5432 -U materyalph_app -d materyalph
```

```bash
Test-Path "C:\Program Files\PostgreSQL\18\bin\psql.exe"
```