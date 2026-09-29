# Deployment Protocol & CI/CD — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Multi-Platform Deployment Overview
Tasbeeh Al Muslim is deployed across three environments:
1. **Web & Server Environment:** Marketing landing page (`/`), Flutter Web SPA (`/app/`), and PHP Backend API (`/api/v3/`) hosted at `https://cybeasy.com/Tasbeeh-Al-Muslim/`.
2. **Android Release:** Google Play Store (App Bundle `.aab`) and direct APK distributions.
3. **iOS Release:** Apple App Store & TestFlight (`.ipa`).

---

## 2. Web & Server Deployment (cybeasy.com/Tasbeeh-Al-Muslim/)

### 2.1 Automated Web Build Script
The unified build script automates building the Flutter Web SPA directly into `app/`, verifying the API test harness, and configuring Apache `.htaccess`:

```bash
./scripts/build_server.sh [OPTIONS]
```

> [!NOTE]
> **Server Build Environment:** The production server (`cpanel.cybeasy.com`) has Flutter SDK installed in `/opt/flutter` (stable channel) with system symlinks in `/usr/local/bin/flutter` and `/usr/local/bin/dart`. `./scripts/build_server.sh` automatically exports the SDK path and compiles production web assets with WebAssembly and JavaScript.

**Supported Options:**
- `-b, --base-href <HREF>`: Custom base href for web routing (Default: `/Tasbeeh-Al-Muslim/app/`).
- `-s, --skip-build`: Skip Flutter Web compilation and only sync configuration files.
- `--no-test-api`: Skip API v3 health self-test before building.

### 2.2 Server Directory Layout
```text
Tasbeeh-Al-Muslim/ (Repository Root & Web Root)
├── index.html                  <-- Marketing Landing Page (with Web App CTAs)
├── index2.html                 <-- Alternative landing page variant
├── vapp-landing/               <-- Styles, scripts & landing assets (includes vendor/)
│   └── vendor/                 <-- Third-party libraries (WOW.js, Owl Carousel, etc.)
├── PrivacyPolicy/              <-- Privacy policy HTML & assets
├── .htaccess                   <-- Root Apache routing & security rules
├── app/                        <-- Compiled Flutter Web App (<base href="/Tasbeeh-Al-Muslim/app/">)
│   ├── index.html              <-- Flutter SPA entry point
│   ├── .htaccess               <-- SPA HTML5 History Routing Rules
│   ├── sqlite3.wasm            <-- Relational database Wasm engine
│   └── assets/
├── api/                        <-- PHP 8.x Backend with Anti-Bot Engine
│   └── v3/
│       ├── security.php        <-- Rate limiter & bot rejection filter
│       ├── config.php          <-- Domain, CORS & limit settings
│       ├── constants.php
│       └── base.php
└── code/                       <-- Flutter Source Code (protected: Require all denied)
```

### 2.3 Apache Web Server Rules
- **Root `.htaccess`:** Denies access to `.git`, `.env`, hidden files, and `code/`. Enables gzip/deflate compression for static assets.
- **`app/.htaccess`:** Configures HTML5 SPA history routing:
  ```apache
  RewriteEngine On
  RewriteBase /Tasbeeh-Al-Muslim/app/
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule ^ index.html [L]
  ```
- **`code/.htaccess`:** Blocks all web requests:
  ```apache
  Require all denied
  ```

---

## 3. Mobile Deployment (Android & iOS)

All Flutter mobile build commands MUST be executed within the `code/` directory using FVM:

```bash
cd code
```

### 3.1 Android Build Commands
- **Local Testing / Internal Distribution (APK):**
  ```bash
  fvm flutter build apk --release
  ```
- **Google Play Store Release (AAB):**
  ```bash
  fvm flutter build appbundle --release
  ```

### 3.2 iOS Build Commands
- **TestFlight & App Store Release (IPA):**
  ```bash
  fvm flutter build ipa --release
  ```

---

## 4. Pre-Deployment Checklist
- [ ] Backend API test harness passes 10/10 test suites (`php api/v3/api_test.php`).
- [ ] Static type checking and linting pass with zero errors (`cd code && fvm flutter analyze`).
- [ ] Automated unit and widget tests pass (`cd code && fvm flutter test`).
- [ ] Version and build number updated in `code/pubspec.yaml` (`version: X.Y.Z+build`).
- [ ] Environment variables verified in `code/.env` and `code/lib/config/AppConfig.dart`.
- [ ] Android keystore and signing keys properly configured (`key.jks` / Google Play App Signing).
- [ ] Apple distribution provisioning profiles and certificates valid.
- [ ] Sound assets verified in Android `res/raw/` and iOS Runner bundle.
- [ ] Web application verified with `<base href="/Tasbeeh-Al-Muslim/app/">`.

---

## 5. Post-Deployment Verification
1. **Web App Smoke Test:** Open `https://cybeasy.com/Tasbeeh-Al-Muslim/app/` in Chrome/Safari, verify Quran audio streams, Islamic radios play, and Azkar database loads from IndexedDB/Wasm.
2. **Landing Page CTA:** Open `https://cybeasy.com/Tasbeeh-Al-Muslim/` and confirm "فتح تطبيق الويب" launches `/app/`.
3. **API Security Test:** Confirm automated bot scrapers receive 403, and legitimate requests succeed with 200.
4. **Mobile Smoke Test:** Verify scheduled audio dhikr triggers at configured intervals, and background audio controls work on lock screen.
5. **Crashlytics:** Monitor Firebase Crashlytics dashboard for early crash reports after publishing updates.
