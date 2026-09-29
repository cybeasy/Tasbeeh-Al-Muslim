# Task: Web Periodic Azkar Engine & Notifications Scheduler Isolation
- **Date:** 2026-09-10
- **Category:** feature
- **Target Files:**
  - `lib/services/WebAzkarTimerService.dart`
  - `lib/models/ZekerBuildNotifications/BuildNotifications.dart`
  - `lib/models/ZekerBuildNotifications/ZekerTime.dart`
  - `lib/screens/scheduleNotificationsScreen/Controller/scheduleNotificationsController.dart`
  - `lib/screens/scheduleNotificationsScreen/View/scheduleNotificationsScreen.dart`
  - `lib/screens/AzkarScreen/Controller/AzkarController.dart`
  - `lib/main.dart`

## 1. Objective
Enable 100% functional periodic Azkar playback on Flutter Web while strictly preserving all existing native mobile (Android & iOS) background alarm and notification logic untouched:
1. Provide a dedicated `WebAzkarTimerService` running an active periodic timer with a dedicated `AudioPlayer` on Web that plays scheduled Azkar sequentially, respecting intervals and sleep hours.
2. Fix the infinite loading spinner in `scheduleNotificationsScreen` on Web by fetching scheduled Azkar from local cache instead of failing on mobile-only native notification channels.
3. Automatically resume the periodic web timer on app startup if Azkar was already active (`BuildAzkar.isPlay()`).
4. Ensure zero deletion, modification, or regression of existing Android & iOS notification code.

## 2. Atomic Execution Steps
- [x] Step 1: Create `lib/services/WebAzkarTimerService.dart` to handle periodic web playback, interval timing, sleep hours check, and dedicated audio playback.
- [x] Step 2: Update `BuildNotifications.dart` to compute and schedule the Web Azkar queue into `createdChanel` and launch `WebAzkarTimerService.start()`, leaving mobile code 100% intact.
- [x] Step 3: Update `scheduleNotificationsController.dart` and `scheduleNotificationsScreen.dart` to load scheduled Azkar on Web from cache with safe fallbacks and handle web stop/playback.
- [x] Step 4: Hook startup auto-resume in `main.dart` for Web and connect controller actions.
- [x] Step 5: Verify with `flutter analyze`, rebuild web release (`flutter build web`), and verify in browser.

## 3. Implementation Reality & Audit Log
1. **Isolated Web Timer Service (`lib/services/WebAzkarTimerService.dart`)**:
   - Implemented `WebAzkarTimerService.instance` managing an internal `Timer.periodic` scoped to `kIsWeb`.
   - Dedicated private `_player = AudioPlayer()` ensuring Azkar audio never mutates or conflicts with Quran audio playlists.
   - Built-in `_isSleepTime()` evaluating user's sleep configuration (`SleepHourClass`) for overnight and same-day periods.
   - Sequential circular cursor iteration over scheduled Azkar.
2. **Web Scheduler in `BuildNotifications.dart`**:
   - Preserved Android and iOS native notification channel builders untouched.
   - In `kIsWeb`, generates full 24-hour sequence of `ZekerModel` items with timestamps and time IDs, stores into `createdChanel`, and starts `WebAzkarTimerService.instance.start()`.
   - Added web stop routing to `WebAzkarTimerService.instance.stop()`.
3. **Resilient `scheduleNotificationsScreen` & Controller**:
   - In `scheduleNotificationsController.onInit()`, reads directly from local cache `BuildAzkar.getZekerListFor(zekerListFor.createdChanel)` on Web, completely bypassing mobile-only `NotificationService().pending()`.
   - Added `finally { loading = false; update(); }` eliminating the infinite loading spinner on Web.
   - Handled Web Azkar deletion, re-ordering save, manual preview sound, and cancellation.
   - Added empty state indicator ("لا توجد أذكار مجدولة حالياً") in `scheduleNotificationsScreen.dart`.
4. **App Initialization Hook**:
   - Added `await WebAzkarTimerService.instance.initOnStartup();` in `lib/main.dart` when running on Web.
   - Fortified `setupTimeZone()` in `main.dart` and `ZekerTime.scheduledDate()` with safe fallbacks across all platforms.
5. **Static Analysis & Production Build**:
   - Ran `flutter analyze` ensuring 0 compilation errors.
   - Cleaned unused imports.
   - Successfully built release web bundle via `flutter build web --release` in 80.2s with code 0.
