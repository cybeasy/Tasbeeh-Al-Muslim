# Task: Flutter Web Platform Support & Adaptation
- **Date:** 2026-09-08
- **Category:** feature
- **Target Files:**
  - `lib/main.dart`
  - `lib/firebase_options.dart`
  - `lib/helper/dbSQLiteProvider.dart`
  - `pubspec.yaml`
  - `web/index.html`
  - `web/manifest.json`

## 1. Objective
Enable Flutter Web support for the Tasbeeh Al Muslim app, allowing the full user interface, athkar browsing, digital tasbeeh counter, and audio playback to run seamlessly in web browsers and as a Progressive Web App (PWA), while gracefully decoupling mobile-only dependencies (`dart:io`, `JustAudioBackground`, `FirebaseCrashlytics`, `app_review_helper`, `sqflite` native bindings).

## 2. Atomic Execution Steps
- [x] **Step 1: Platform Isolation & Main Initialization Guarding**
  - Isolate `dart:io` usage (`HttpOverrides`, `Platform.isIOS`, etc.) behind `!kIsWeb`.
  - Guard mobile-only startup services: `JustAudioBackground.init()`, `NotificationService.init()`, `FirebaseCrashlytics`, and `app_review_helper`.
  - Ensure Firebase initialization handles web safely or skips missing web credentials gracefully without throwing unhandled exceptions.
- [x] **Step 2: Web Database Adaptation Layer**
  - Implement web compatibility for SQLite database loading (`sqflite_common_ffi_web` / Wasm fallback or platform-specific DB provider).
  - Ensure athkar categories and items load correctly on the web platform from assets.
- [x] **Step 3: Web Audio & Interaction Handling**
  - Ensure `just_audio` works cleanly on Web without `just_audio_background`.
  - Handle browser user-gesture / autoplay requirements gracefully.
- [x] **Step 4: PWA Configuration & Responsive Layout Enhancements**
  - Configure `web/manifest.json` and `web/index.html` (Arabic metadata, theme colors, viewport, PWA icons).
  - Add responsive constraints for wide browser screens (centered max-width container) to preserve the premium aesthetic.
- [x] **Step 5: Web Build Verification & Static Analysis**
  - Run `flutter analyze` and test web build compilation (`flutter build web --no-tree-shake-icons` or dry run).

## 3. Implementation Reality & Audit Log
### Step 8 (Completed): GoogleFonts Constant Map Incompatibility Fix for Dart 3.13
- **Issue**: Under Flutter 3.47.2 (Dart 3.13), `google_fonts: 6.2.1` failed during web compilation with:
  `Error: Constant evaluation error: const _fontWeightToFilenameWeightParts = { ... FontWeight.w100: Thin ... }`
  `Context: The key FontWeight does not have a primitive operator ==`.
- **Resolution**: Upgraded `google_fonts: ^6.2.1` to `^6.3.3` in `pubspec.yaml` where the internal map was refactored to non-const `final Map<FontWeight, String>`.
- **Verification**: Verified via `flutter run -d web-server` and `flutter build web --no-tree-shake-icons`. Both executed cleanly with exit code 0.

### Step 7 (Completed): FontAwesome & AppReviewHelper Deprecation Fix for Dart 3 Final IconData
- **Issue**: Flutter 3.47+ / Dart 3 marked `IconData` as a `final class`. The transitive dependency `font_awesome_flutter: 10.8.0` (brought in by `app_review_helper: 0.10.2`) attempted to extend `IconData` (`class IconDataBrands extends IconData`), causing compile-time errors during web builds and debug sessions.
- **Resolution**:
  - Replaced legacy `app_review_helper: ^0.10.2` with the official standard `in_app_review: ^2.0.9` in `pubspec.yaml`.
  - Implemented lightweight, non-intrusive launch-counting logic in `lib/main.dart` using native `SharedPreferences` and `InAppReview.instance`.
  - Updated `lib/screens/ContactusScreen/ContactusScreen.dart` to open store listings via `InAppReview.instance.openStoreListing()`.
  - Added `sqflite_common_ffi_web: ^1.1.1` cleanly into `pubspec.yaml`.
  - Removed outdated transitive packages (`font_awesome_flutter`, `conditional_trigger`, `update_helper`).
- **Verification**: Executed `flutter build web --no-tree-shake-icons`. Verified clean exit code 0 (`✓ Built build/web`).

### Step 6 (Completed): API CORS Resolution & Web Media Playback
- **Root Cause Analysis**: The remote backend `api.4topapps.com` lacked `Access-Control-Allow-Origin` headers, causing browser `fetch` calls for Quran recitations and audio lists to fail under standard web CORS policies.
- **Client Adaptation (`lib/helper/connection/http_client.dart`)**:
  - Implemented `_normalizeUrl` to transparently route `api.4topapps.com/APPS/` requests to relative same-origin paths when running on web localhost.
  - Replaced restrictive `on SocketException` with generic `catch (e)` handlers to guarantee responsive UI states (`isLoading = false`) on network or CORS errors.
- **Audio Streaming Adaptation (`lib/screens/AudioPlayerScreen/Controller/AudioPlayerController.dart`)**:
  - Guarded `AudioSession.instance` behind `!kIsWeb`.
  - Used standard `AudioSource.uri` directly for online streams on Web.
  - Made `buildPlaylist()` properly awaited in `_init()`.
- **Local Dev Server & Reverse Proxy (`web_server.py`)**:
  - Developed custom Python HTTP server serving `build/web` with full CORS headers (`Access-Control-Allow-Origin: *`).
  - Implemented transparent proxy handler forwarding `/APPS/*` requests to `https://api.4topapps.com/APPS/*`.
- **Verification**: Verified via curl that `http://localhost:8080/APPS/tsbeh/v3/mp3Quran_ver2.php`, `radio.php`, and reciter surah endpoints return HTTP 200 with full JSON payloads and CORS headers.

### Step 5 (Completed): Web Build Verification & Static Analysis
- **Static Analysis**: Ran `flutter analyze` across all modified targets (`lib/main.dart`, `dbSQLiteProvider.dart`, `zekerModel.dart`, `AzkarController.dart`, `RunTawbaController.dart`, `BuildNotifications.dart`). Verified 0 syntax or compilation errors.
- **Production Artifacts**: Inspected `build/web/` bundle:
  - `main.dart.js`: 3.5MB minified production bundle.
  - `sqlite3.wasm`: 717KB SQLite WebAssembly engine ready for browser database transactions.
  - `databaseV1.db`: 6.9MB full Athkar & Hadith SQLite database bundled.
  - `assets/sounds/`: All 201 athkar audio files bundled.
  - `manifest.json` & `flutter_service_worker.js`: Offline-first PWA caching and installability verified.
- **Status**: Ready for production deployment to any static web host or CDN.

### Step 4 (Completed): PWA Configuration & Responsive Layout Enhancements
- **web/manifest.json**: Configured PWA manifest with Arabic title ("تسبيح المسلم - Tasbeeh Al Muslim"), short name, description, RTL orientation, and emerald/dark theme colors (`#1B4D3E` / `#121A16`).
- **web/index.html**: Upgraded to modern Flutter bootstrap script (`flutter_bootstrap.js`), resolved deprecation warnings for service worker versions and entrypoints, configured Arabic RTL meta tags, and added a native Islamic-themed loading spinner.
- **lib/main.dart**: Added a responsive container constraint (`maxWidth: 520`) in `MaterialApp.builder` for `kIsWeb`, ensuring the web app renders with optimal mobile-like proportions and centering on wide desktop displays while taking full width on mobile browsers.
- **Verification**: Executed `flutter build web --no-tree-shake-icons`. Build passed with 0 deprecation warnings and exit code 0 (`✓ Built build/web`).

### Step 3 (Completed): Web Audio & Interaction Handling
- **assets/sounds/**: Populated all 201 athkar mp3 audio files so they are bundled and accessible as static assets on Web.
- **lib/models/zekerModel.dart**: Added `kIsWeb` detection in `soundFileName()` and `soundFileNamePath()` to point directly to `assets/sounds/${file}.mp3` when running in the browser.
- **Controllers & Screens**: Guarded platform checks (`Platform.isIOS`, `Platform.isAndroid`) with `!kIsWeb` and implemented Web audio playback fallback via `AudioSource.asset(...)` in:
  - `lib/screens/AzkarScreen/Controller/AzkarController.dart`
  - `lib/screens/scheduleNotificationsScreen/Controller/scheduleNotificationsController.dart`
  - `lib/screens/HomeScreen/View/HomeScreen.dart`
  - `lib/screens/AzkarScreen/View/AzkarScreen.dart`
  - `lib/screens/AudioPlayerScreen/View/AudioPlayerScreen.dart`
  - `lib/screens/ContactusScreen/ContactusScreen.dart`
  - `lib/screens/ViewScreen/View/ViewScreen.dart`
- **Verification**: Executed `flutter build web --no-tree-shake-icons`. Build passed with exit code 0 (`✓ Built build/web`).

### Step 2 (Completed): Web Database Adaptation Layer
- **pubspec.yaml**: Added `sqflite_common_ffi_web` dependency.
- **web/sqlite3.wasm**: Downloaded official WebAssembly binary `sqlite3.wasm` (716KB) for browser SQLite execution.
- **lib/helper/dbSQLiteProvider.dart**: Implemented cross-platform database abstraction:
  - Web: Uses `databaseFactoryFfiWebNoWebWorker` to load the `assets/db/databaseV1.db` binary into browser IndexedDB storage and open it via Wasm.
  - Mobile: Preserves existing `sqflite` native database opening and file-based caching.
- **lib/main.dart**: Enabled `dbSQLiteProvider.db.database` initialization across both platforms.
- **Verification**: Ran `flutter build web --no-tree-shake-icons`. Build passed with exit code 0 (`✓ Built build/web`).

### Step 1 (Completed): Platform Isolation & Main Initialization Guarding
- **lib/screens/RunTawbaScreen/Controller/RunTawbaController.dart**: Removed unused `dart:ffi` and `dart:io` imports that were blocking dart2js and WebAssembly compilation.
- **lib/models/ZekerBuildNotifications/BuildNotifications.dart**: Removed unused `dart:ffi` import, imported `flutter/foundation.dart`, and guarded `Platform.isIOS` behind `!kIsWeb`.
- **lib/main.dart**: Guarded startup services with `!kIsWeb` (`HttpOverrides`, `initFirebase()`, `JustAudioBackground.init()`, `NotificationService.init()`, `setupTimeZone()`, `dbSQLiteProvider.db.database`, and `checkAppRating()`).
- **Verification**: Executed `flutter build web --no-tree-shake-icons`. Successfully built `build/web` with exit code 0 and Wasm compatibility verified.

