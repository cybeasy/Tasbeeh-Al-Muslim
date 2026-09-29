# Task: Install Flutter SDK on Server and Build Production Web App
- **Date:** 2026-09-14
- **Category:** feature
- **Target Files:**
  - `/opt/flutter`
  - `/etc/profile.d/flutter.sh`
  - `scripts/build_server.sh`
  - `app/`
  - `.tailorai/Protocols/Deployment_Protocol.md`

## 1. Objective
Install and configure Flutter SDK (stable channel) directly on the Ubuntu production server (`cpanel.cybeasy.com`), export Flutter to system PATH, fix the PHP pcntl cli warning, execute `scripts/build_server.sh` to generate the Flutter Web release bundle into `app/`, verify the SPA routing and API test suite, and ensure zero runtime overhead on the server.

## 2. Atomic Execution Steps
- [x] [Step 1: Install Flutter SDK in `/opt/flutter`, configure system PATH (`/etc/profile.d/flutter.sh`), and resolve PHP pcntl warning]
- [x] [Step 2: Verify Flutter installation and prerequisites (`flutter --version`, `flutter doctor`)]
- [x] [Step 3: Execute `scripts/build_server.sh` to build Flutter Web into `app/`, copy Wasm and generate SPA `.htaccess`]
- [x] [Step 4: Verify production Web App URLs and update deployment documentation]

## 3. Implementation Reality & Audit Log
1. **Flutter SDK Installation & System PATH Configuration:**
   - Cloned Flutter SDK (stable branch) directly into `/opt/flutter`.
   - Created `/etc/profile.d/flutter.sh` to export `/opt/flutter/bin` system-wide into `$PATH`.
   - Configured `git config --global --add safe.directory /opt/flutter` for safe repo access across users.
   - Fixed PHP CLI startup warning by commenting out redundant dynamic extension loading in `/etc/php/8.3/cli/conf.d/pcntl.ini` and FPM config.
2. **Flutter Web Environment & Toolchain Verification:**
   - Created symlinks `/usr/local/bin/flutter` and `/usr/local/bin/dart` pointing to `/opt/flutter/bin/`.
   - Initialized Dart SDK and generated `flutter_tools.snapshot` (Flutter 3.47.4 / Dart 3.13.3).
   - Configured permissions, ownership, and user cache directories (`.dart-tool`, `.cache`, `.pub-cache`) for `cybeasy_admin`.
   - Precached all Web SDK artifacts via `flutter precache --web`.
   - Enhanced `scripts/build_server.sh` with explicit fallback PATH export and resilient version detection.
3. **Flutter Web Production Build Execution:**
   - Executed `./scripts/build_server.sh` creating release bundle in `app/`.
   - Successfully compiled Dart to Web with both WebAssembly and JavaScript (`main.dart.js`, `canvaskit`, `flutter_bootstrap.js`).
   - Verified `sqlite3.wasm` is in place for offline relational Azkar database.
   - Configured `app/.htaccess` with HTML5 SPA rewrite rules and compression headers.
   - Configured secure file permissions and ownership (`cybeasy_admin:www-data`).
4. **Endpoint Verification & Documentation Update:**
   - Verified live HTTP 200 responses on `/app/`, `/app/sqlite3.wasm`, and `/api/v3/radio.php`.
   - Updated `.tailorai/Protocols/Deployment_Protocol.md` to document the server-side Flutter SDK installation path and build script behavior.
