# Task: Fix Android Startup Permission Dialog, Touch Blocking & Exact Alarms Crash
- **Date:** 2026-09-14
- **Category:** bugfix
- **Target Files:**
  - `code/lib/Notifications/Local/NotificationService.dart`
  - `code/lib/screens/HomeScreen/View/HomeScreen.dart`
  - `code/lib/screens/HomeScreen/Controller/HomeController.dart`
  - `code/lib/AppRoutes.dart`
  - `code/lib/models/ZekerBuildNotifications/BuildNotifications.dart`
  - `code/lib/screens/AzkarScreen/Controller/AzkarController.dart`
  - `code/lib/screens/scheduleNotificationsScreen/Controller/scheduleNotificationsController.dart`

## 1. Objective
1. Fix the issue where tapping grid item buttons (`listItem`) on `HomeScreen` produces no response on initial app startup on Android due to background/pending runtime notification permission and lack of foreground request / context passing.
2. Fix `PlatformException(exact_alarms_not_permitted)` and ANR freeze ("تسبيح المسلم isn't responding") when generating Azkar notifications on Android 14+ (API 34+) by introducing dynamic exact alarm detection, non-blocking fallback (`inexactAllowWhileIdle`), pre-flight permission guidance dialog, and sequential `await` scheduling.

## 2. Atomic Execution Steps
- [x] [Step 1: Reorder and streamline runtime permission handling in `NotificationService.dart` to request `POST_NOTIFICATIONS` first and prevent blocking intents]
- [x] [Step 2: Trigger explicit notification permission request and version check safely in `HomeScreen.dart` via `addPostFrameCallback`]
- [x] [Step 3: Upgrade `listItem` with `InkWell`/`HitTestBehavior.opaque` and wire `BuildContext` into `HomeController.openScreenBy` and `AppRoutes.openAction`]
- [x] [Step 4: Implement exact alarm check, graceful fallback (`exactAllowWhileIdle` vs `inexactAllowWhileIdle`), sequential `await`, and pre-flight guidance dialog in `AzkarController`]
- [x] [Step 5: Run Dart analysis and verify zero compilation errors across all affected files]

## 3. Implementation Reality & Audit Log
- **Step 1 (Completed 2026-09-14):**
  - Updated `code/lib/Notifications/Local/NotificationService.dart`.
  - Reordered permissions in `askNotifPermissionIfNeeded()`: requests `POST_NOTIFICATIONS` runtime permission on Android 13+ (`sdk >= 33`) directly and first, wrapped in try-catch.
  - Decoupled `requestExactAlarmsPermission()` into a dedicated helper `askExactAlarmPermissionIfNeeded()`.
- **Step 2 (Completed 2026-09-14):**
  - Updated `code/lib/screens/HomeScreen/View/HomeScreen.dart`.
  - Added explicit, non-blocking notification permission trigger inside `WidgetsBinding.instance.addPostFrameCallback((_) async { ... })` in `HomeScreenState.initState()`.
  - Moved `UpdateNewVer.check(false, context)` inside the post-frame callback with `mounted` check.
- **Step 3 (Completed 2026-09-14):**
  - Upgraded `listItem(ApiModel temp)` in `HomeScreen.dart` to use `Material(color: Colors.transparent)` + `InkWell(borderRadius: BorderRadius.circular(16), onTap: ...)`.
  - Updated `HomeController.openScreenBy(ApiModel model, {BuildContext? context})` to receive and forward `context`.
  - Updated `AppRoutes.openAction` and screen openers to accept optional `BuildContext? context` for direct `Navigator.push(context, ...)`.
  - Fine-tuned item container height from 140 to 150 for comfortable spacing on various screen densities.
- **Step 4 (Completed 2026-09-15):**
  - Updated `NotificationService.scheduleLocalNotifications`:
    - Checks `canScheduleExact()` dynamically via `AndroidFlutterLocalNotificationsPlugin.canScheduleExactNotifications()`.
    - Uses `AndroidScheduleMode.exactAllowWhileIdle` if permission is granted, and falls back gracefully to `AndroidScheduleMode.inexactAllowWhileIdle` if denied, preventing `PlatformException(exact_alarms_not_permitted)`.
    - Wrapped in `try-catch` to avoid uncaught exception stops in debug mode.
    - Preserved per-Zeker dedicated notification channel architecture with dedicated sound files.
  - Updated `code/lib/models/ZekerBuildNotifications/BuildNotifications.dart`:
    - Added `await` to `scheduleLocalNotifications(zekerModel)` in the 480-notification generation loop, preventing MethodChannel saturation and ANR freezing.
    - Fixed `testPush` to be `async`.
  - Updated `code/lib/screens/scheduleNotificationsScreen/Controller/scheduleNotificationsController.dart`:
    - Replaced unawaited `pendingList.forEach((element) async { ... })` with sequential `for (final element in pendingList) { await ... }`.
  - Updated `code/lib/screens/AzkarScreen/Controller/AzkarController.dart`:
    - Added pre-flight check in `save()`: prompts the user to enable "Alarms & Reminders" in settings if exact timing is desired, while allowing seamless continuation if declined.
- **Step 5 (Completed 2026-09-15):**
  - Executed `dart analyze` on all modified files. Verified 0 compilation errors across the board.
  - Verified on Android Emulator: notification generation runs to completion smoothly without crash or ANR dialog.

## 4. Key Architectural Insights & Clarifications

### 4.1 Per-Zeker Notification Channel Architecture (`channelID = soundFileName`)
- **Reasoning**: In Android 8.0+ (API 26+), notification sounds and vibration patterns are bound permanently to the `NotificationChannel`. To play a specific audio recording for each individual Zeker, a distinct channel must exist for each sound asset.
- **Design Decision**: Preserved the dedicated channel per Zeker sound file. Channels are created safely during notification scheduling without collapsing them into a single generic channel, ensuring each Azkar sound plays as configured.

### 4.2 Background & Killed App Behavior with `AndroidScheduleMode.inexactAllowWhileIdle`
- **Does it work when the app is closed?** **Yes**. The `AllowWhileIdle` flag maps directly to Android's `AlarmManager.setAndAllowWhileIdle()` (or `setExactAndAllowWhileIdle()`). This instructs Android's system `AlarmManager` service to wake the device from low-power Doze mode and display the notification even if the app is killed, swiped away from recent apps, or the screen is locked.
- **Difference between Exact vs Inexact**:
  - `exactAllowWhileIdle`: Fires at the precise second scheduled (requires Android 12+ `SCHEDULE_EXACT_ALARM` or `USE_EXACT_ALARM` user approval).
  - `inexactAllowWhileIdle`: Android batches the alarm within a small execution window (typically within a few minutes) to save battery. It never crashes and does not require explicit user permission.
- **Pre-flight Dialog**: If exact timing is desired, `AzkarController` alerts the user with an option to open device settings, while seamlessly falling back to inexact mode if declined or denied.

### 4.3 Sequential Loop Scheduling vs ANR
- Scheduling 480 notifications asynchronously without `await` overwhelmed the Flutter MethodChannel / Binder IPC buffer, causing the Android OS to display the "App isn't responding" (ANR) dialog.
- Adding sequential `await` inside `BuildNotifications.dart` ensures orderly queue processing and prevents main-thread starvation.
