# Task: Repository Restructuring (Landing, Code, App, API) & Multi-Layer Anti-Bot Security Hardening
- **Date:** 2026-09-13
- **Category:** feature
- **Target Files:**
  - `code/` (Flutter Project: lib, android, ios, web, assets, pubspec.yaml, etc.)
  - `app/` (Flutter Web release build, ignored in .gitignore)
  - `Tasbeeh-Al-Muslim/` (Landing Page & Privacy Policy)
  - `api/v3/config.php`
  - `api/v3/security.php`
  - `api/v3/constants.php`
  - `api/v3/base.php`
  - `api/v3/about.php`
  - `api/v3/support.php`
  - `api/v3/api_test.php`
  - `.gitignore`
  - `.vscode/settings.json`
  - `.vscode/launch.json`
  - `code/.env`
  - `code/.env.example`
  - `code/lib/config/AppConfig.dart`
  - `code/lib/Bloc/AppCubit.dart`
  - `code/lib/helper/connection/http_client.dart`
  - `scripts/build_server.sh`
  - `Tasbeeh-Al-Muslim/index.html`
  - `README.md`
  - `.tailorai/Protocols/Deployment_Protocol.md`

## 1. Objective
Restructure the repository to match the clean Git architecture:
- `Tasbeeh-Al-Muslim/` -> Landing page (`index.html`, `vapp-landing/`, `PrivacyPolicy/`)
- `code/` -> Complete Flutter source code
- `app/` -> Target directory for compiled Flutter Web (added to `.gitignore`)
- `api/` -> Backend PHP API with multi-layer anti-bot security
Then implement the multi-layer anti-bot security engine and automate builds to `app/`.

## 2. Atomic Execution Steps
- [x] [Step 1: Restructure Repository into `code/`, `app/`, and Configure `.gitignore` & `.vscode`]
- [x] [Step 2: Implement Multi-Layer Anti-Bot Security Engine (`api/v3/security.php`)]
- [x] [Step 3: Update Flutter Network Layer & Endpoints in `code/lib/`]
- [x] [Step 4: Landing Page Integration & Web Button in `Tasbeeh-Al-Muslim/index.html`]
- [x] [Step 5: Update Build Script (`scripts/build_server.sh`) to Build from `code/` to `app/`]
- [x] [Step 6: Verification & Automated Security Tests]
  - Verified Rate Limiter, Bad Bot Filter, and CORS Domain Whitelist.
  - Verified all 10 API endpoints via `api_test.php`.
  - Updated `README.md` and `Deployment_Protocol.md`.

## 3. Implementation Reality & Audit Log
1. **Step 1 Completed (Repository Restructuring & Environment Setup):**
   - Created `code/` directory and safely relocated all Flutter components (`lib/`, `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`, `assets/`, `test/`, `pubspec.yaml`, `pubspec.lock`, configs, `.fvm`, etc.) preserving full Git rename history (`git mv`).
   - Created `code/.htaccess` protecting source files with Apache `Require all denied`.
   - Created `app/` target directory with `app/.gitkeep`.
   - Updated `.gitignore` to ignore `/app/*`, `/dist/`, and `/code/build/`.
   - Updated `.vscode/settings.json` with `"dart.projectSearchPaths": ["code"]` and adjusted SDK and SQLite database path.
   - Updated `.vscode/launch.json` with `"cwd": "code"` and `"program": "code/lib/main.dart"` across all debug & build configurations.
   - Ran `flutter pub get` and `flutter analyze` inside `code/`: dependencies resolved cleanly with zero compilation errors.
2. **Step 2 Completed (Multi-Layer Anti-Bot Security Engine):**
   - Created `api/v3/security.php` with real client IP resolution, CLI/Localhost whitelist, strict CORS domain whitelist (`https://cybeasy.com`, `localhost`), bad bot blocker, and sliding window IP rate limiting (60 req/min).
   - Wired `security.php` into `api/v3/constants.php` and `api/v3/base.php`.
   - Updated `api/v3/base.php` to dynamically compute `$baseUrl` via `$_SERVER['SCRIPT_NAME']`.
   - Updated `api/v3/about.php` and `api/v3/support.php` URLs to `cybeasy.com/Tasbeeh-Al-Muslim/`.
   - Ran `api/v3/api_test.php`: all 10 endpoint test suites passed with 100% success rate.
3. **Step 3 Completed (Centralized Environment Configuration & Flutter Network Security):**
   - Created `code/lib/config/AppConfig.dart` with centralized domain & path configuration (`String.fromEnvironment` with fallback to `cybeasy.com`).
   - Created `code/.env` and `code/.env.example` with `APP_DOMAIN`, `API_BASE_PATH`, `APP_BASE_PATH`.
   - Created `api/v3/config.php` centralizing domain, paths, rate limits, and CORS patterns for backend.
   - Updated `code/lib/Bloc/AppCubit.dart` to use `AppConfig.quranApiUrl`, `AppConfig.radioApiUrl`, and `AppConfig.tafserApiUrl`.
   - Updated `code/lib/helper/connection/http_client.dart` with `_buildDefaultHeaders` (`X-App-Platform`, `X-App-Version`, `X-App-Client`) and origin/subfolder-aware `_normalizeUrl`.
   - Ran `flutter analyze` inside `code/`: zero compilation errors.
4. **Step 4 Completed (Landing Page Web App Integration):**
   - Updated `Tasbeeh-Al-Muslim/index.html` with desktop navbar, mobile menu, hero CTA, and download section buttons linking directly to `./app/`.
5. **Step 5 Completed (Build Script Automation & Artifact Assembly):**
   - Updated `scripts/build_server.sh` to compile Flutter Web from `code/` with `--base-href "/Tasbeeh-Al-Muslim/app/"`.
   - Generated SPA `.htaccess` in `app/` (`RewriteBase /Tasbeeh-Al-Muslim/app/`).
   - Packaged complete server bundle in `dist/Tasbeeh-Al-Muslim/` containing landing page, `app/`, and `api/`.
   - Successfully executed `./scripts/build_server.sh`: build passed and verified `<base href="/Tasbeeh-Al-Muslim/app/">`.
6. **Step 6 Completed (Verification & Documentation Updates):**
   - Automated tests verified: Bot signature rejection, CORS whitelist blocking, and sliding window rate limiting.
   - Full API v3 self-tests passed 10/10 test suites.
   - Synchronized documentation in `README.md` and `Deployment_Protocol.md`.

7. **Root Landing Page Promotion:**
   - Moved all landing files (`index.html`, `index2.html`, `vapp-landing/`, `PrivacyPolicy/`, `vendor/`) directly to the repository root.
   - Removed the nested subfolder `Tasbeeh-Al-Muslim/`.
   - Updated `scripts/build_server.sh` to copy landing page assets directly from root.
   - Re-verified packaging: `dist/Tasbeeh-Al-Muslim/` contains all landing assets at root, `app/` web app, and `api/` backend.
