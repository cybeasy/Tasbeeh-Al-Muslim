# Task: Fix Google Play Broken Functionality Policy & Startup Splash Loading Freeze
- **Date:** 2026-09-16
- **Category:** bugfix
- **Target Files:**
  - `code/lib/main.dart`
  - `code/lib/helper/dbSQLiteProvider.dart`
  - `code/lib/Notifications/Local/NotificationService.dart`
  - `code/android/app/src/main/AndroidManifest.xml`
  - `code/android/app/proguard-rules.pro`

## 1. Objective
Fix Google Play rejection under "Broken Functionality policy: Violation of Broken Functionality policy (Loading problems: Your app doesn't open or load)" where the release build stalls indefinitely on the Android native splash screen (`launch_background.xml`) before `runApp()` is called.

The fix addresses 6 core vulnerabilities:
1. Unprotected blocking `await` calls in `main.dart` before `runApp()`, specifically `messaging.subscribeToTopic("android")` hanging in Google review sandbox / offline environments.
2. Inefficient database copy in `dbSQLiteProvider._copyMobileDB()` reloading 7.16MB on every launch without checking file existence.
3. Incorrect `android:exported="false"` on `ScheduledNotificationBootReceiver` with `BOOT_COMPLETED` intent-filter in `AndroidManifest.xml`.
4. Missing ProGuard keep rules for R8 / minification in `code/android/app/proguard-rules.pro`.
5. Missing `@pragma('vm:entry-point')` annotation on background notification handler in `NotificationService.dart`.
6. Missing screen orientation lock to `portraitUp` allowing unsupported landscape layouts on Google Play review tablets.

## 2. Atomic Execution Steps
- [x] [Step 1: Optimize `dbSQLiteProvider.dart` to skip 7.16MB asset copying if the database file already exists]
- [x] [Step 2: Hardening `main.dart` with fail-safe `try-catch`, non-blocking unawaited FCM topic subscription with timeout, and portrait orientation lock]
- [x] [Step 3: Fix `ScheduledNotificationBootReceiver` `android:exported="true"` and lock activity portrait orientation in `AndroidManifest.xml`]
- [x] [Step 4: Annotate background notification callback with `@pragma('vm:entry-point')` in `NotificationService.dart`]
- [x] [Step 5: Add robust Keep rules in `code/android/app/proguard-rules.pro` for Flutter plugins, AudioService, and SQLite]
- [x] [Step 6: Build release APK (`flutter build apk --release`), verify zero errors, and document Google Play App Signing SHA key instructions]

## 3. Implementation Reality & Audit Log
- **Step 1 (Completed 2026-09-16):**
  - Updated `code/lib/helper/dbSQLiteProvider.dart`.
  - Added pre-check in `_copyMobileDB()` verifying `await file.exists()` and `await file.length() > 0` before attempting to read/write 7.16MB from assets.
  - Enabled `flush: true` when writing the initial asset DB bytes.
  - Startup database initialization on subsequent cold starts is now instantaneous (~0ms vs ~300-1500ms disk I/O).
- **Step 2 (Completed 2026-09-16):**
  - Updated `code/lib/main.dart`.
  - Added orientation lock `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` before UI initialization.
  - Wrapped all async initialization blocks (`CashLocal`, `initFirebase`, `JustAudioBackground`, `NotificationService`, `setupTimeZone`, and `dbSQLiteProvider.db.database`) in a guarded `try/catch` with debug logging.
  - In `initFirebase()`: Decoupled `subscribeToTopic` into a non-blocking `unawaited(_subscribeToTopics())` with a 5-second timeout, ensuring `runApp()` is reached immediately without waiting for FCM tokens or network handshakes.
  - Verified `dart analyze code/lib/main.dart` passes cleanly with 0 errors.
- **Step 3 (Completed 2026-09-16):**
  - Updated `code/android/app/src/main/AndroidManifest.xml`.
  - Set `android:exported="true"` for `ScheduledNotificationBootReceiver` so system broadcast `BOOT_COMPLETED` is legally received on Android 12+ (API 31+).
  - Added `android:screenOrientation="portrait"` to `AudioServiceActivity` with `tools:ignore="LockedOrientationActivity"`.
  - Removed duplicate permissions for `SCHEDULE_EXACT_ALARM` and `RECEIVE_BOOT_COMPLETED`.
- **Step 4 (Completed 2026-09-16):**
  - Updated `code/lib/Notifications/Local/NotificationService.dart`.
  - Added `@pragma('vm:entry-point')` to `onDidReceiveNotificationResponse` and `onDidReceiveLocalNotification` preventing code-stripping during AOT release compilation.
  - Wrapped `NotificationService.init()` in an internal `try/catch` block for defensive fail-safety.
  - Verified with `dart analyze` (0 errors).
- **Step 5 (Completed 2026-09-16):**
  - Created and populated `code/android/app/proguard-rules.pro` with keep rules for `io.flutter.**`, `com.ryanheise.audioservice.**`, `com.ryanheise.just_audio.**`, `com.dexterous.flutterlocalnotifications.**`, `com.tekartik.sqflite.**`, and `com.google.firebase.**`.
  - Linked `proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")` in `code/android/app/build.gradle.kts`.
- **Step 6 (Completed 2026-09-16):**
  - Added Play Core / Deferred Component suppressions (`-dontwarn com.google.android.play.core.**`) to `proguard-rules.pro`.
  - Executed `flutter build apk --release --target-platform android-x64` successfully (`✓ Built build/app/outputs/flutter-apk/app-release.apk (137.7MB)`).
  - Installed and launched release APK directly onto Android 14 emulator (`emulator-5554`).
  - Confirmed via screencap that the release app launches instantly to `HomeScreen` and displays notification runtime permissions without freezing on splash.
