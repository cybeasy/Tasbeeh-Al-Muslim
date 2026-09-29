# Task: Production Deployment on tasbeeh.cybeasy.com, API v3 Modernization, and Server Build Automation
- **Date:** 2026-09-12
- **Category:** feature
- **Target Files:**
  - `api/v3/constants.php`
  - `api/v3/base.php`
  - `api/v3/radio.php`
  - `api/v3/mp3Quran_ver2.php`
  - `api/v3/mp3Quran_tafser.php`
  - `api/v3/about.php`
  - `api/v3/menu_home.php`
  - `api/v3/slider.php`
  - `api/v3/support.php`
  - `api/v3/api_test.php`
  - `lib/Bloc/AppCubit.dart`
  - `lib/helper/connection/http_client.dart`
  - `lib/models/Base/ApiModel.dart`
  - `scripts/build_server.sh`
  - `web/.htaccess`
  - `nginx-tasbeeh.conf`
  - `.tailorai/Architecture/Technical_Architecture.md`
  - `.tailorai/Protocols/API_Contracts.md`
  - `.tailorai/Protocols/Deployment_Protocol.md`
  - `README.md`

## 1. Objective
Prepare the application for production deployment on `tasbeeh.cybeasy.com`. Modernize and fix PHP 8+ compatibility issues, missing constants, and CORS in `api/v3/`. Update Flutter network client and domain configurations. Provide a production server build script (`scripts/build_server.sh`) with web server configs (Nginx / Apache), and update the project knowledge base and documentation.

## 2. Atomic Execution Steps
- [x] [Step 1: API v3 Modernization & PHP 8 Compatibility (constants.php, CORS, quote keys, dynamic base URL)]
- [x] [Step 2: API Testing & Validation (self-test script verifying radio, mp3Quran, tafser)]
- [x] [Step 3: Flutter App Integration (AppCubit URLs, http_client normalization, ApiModel robust parsing)]
- [x] [Step 4: Server Build Automation (scripts/build_server.sh, web/.htaccess, nginx-tasbeeh.conf)]
- [x] [Step 5: Knowledge Base & Documentation Update (Technical_Architecture.md, API_Contracts.md, Deployment_Protocol.md, README.md)]
- [x] [Step 6: End-to-End Build & API Verification]

## 3. Implementation Reality & Audit Log
1. **API v3 Modernization (`api/v3/`):**
   - Created `api/v3/constants.php` with full CORS headers, preflight OPTIONS handler, and all legacy/modern constants (`type_open`, `subtype_radio`, `subtype_list`, etc.).
   - Updated `api/v3/base.php` to include `constants.php` and dynamically compute `$baseUrl` with production fallback to `https://tasbeeh.cybeasy.com/api/v3`.
   - Updated `api/v3/radio.php`: Quoted array keys, eliminated PHP 8 bareword fatal errors, served 177 live Islamic radio channels.
   - Updated `api/v3/mp3Quran_ver2.php`: Quoted array keys, optimized `suranames.json` lookup using local file caching, served 241 reciters and all 114 Surahs.
   - Updated `api/v3/mp3Quran_tafser.php`: Quoted array keys, supported both Tafsir commentary stations and 307 audio surah tracks.
   - Updated `about.php`, `menu_home.php`, `slider.php`, and `support.php` for PHP 8 compatibility and updated Cybeasy contacts.
   - Created `api/v3/api_test.php` automated test harness — all 10 endpoint test suites pass with 100% success rate.
2. **Flutter Integration (`lib/`):**
   - Updated `lib/Bloc/AppCubit.dart` with `https://tasbeeh.cybeasy.com/api/v3/` endpoints.
   - Enhanced `lib/helper/connection/http_client.dart` with origin-aware URL normalization on Flutter Web.
   - Enhanced `lib/models/Base/ApiModel.dart` to support both modern keys and legacy `obj_*` keys seamlessly.
3. **Server Build & Deploy Automation:**
   - Created `scripts/build_server.sh` with flags (`-t`, `-b`, `-s`, `--no-test-api`), environment validation, automated build, asset copy, and artifact assembly into `dist/`.
   - Created `web/.htaccess` and `nginx-tasbeeh.conf` for SPA routing, PHP-FPM execution, and caching.
4. **Knowledge Base Updates:**
   - Updated `.tailorai/Architecture/Technical_Architecture.md` with Web & API v3 architecture.
   - Updated `.tailorai/Protocols/API_Contracts.md` with complete endpoint specifications and CORS policy.
   - Updated `.tailorai/Protocols/Deployment_Protocol.md` with server build commands.
   - Updated `README.md` with live web badge (`tasbeeh.cybeasy.com`), server build guide, and API documentation.
