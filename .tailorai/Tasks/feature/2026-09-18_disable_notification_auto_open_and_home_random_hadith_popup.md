# Task: Disable Notification Auto-Open on Unlock & Add Random Hadith Popup on Home Startup
- **Date:** 2026-09-18
- **Category:** feature
- **Target Files:**
  - `code/lib/Notifications/Local/NotificationService.dart`
  - `code/android/app/src/main/AndroidManifest.xml`
  - `code/lib/models/HadesModel.dart`
  - `code/lib/widget/RandomHadithDialog.dart`
  - `code/lib/screens/HomeScreen/View/HomeScreen.dart`

## 1. Objective
1. **Prevent Automatic App Launch on Device Unlock:**
   When scheduled Azkar notifications fire while the device is locked and the app is closed, unlocking the screen triggers Android to automatically launch the app's activity into the foreground. This was caused by `fullScreenIntent: true` in `NotificationService.dart` and `<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>` in `AndroidManifest.xml`. The app must remain closed upon unlocking and only launch when the user explicitly clicks the notification or app icon.

2. **Display Random Hadith Dialog on Home Startup:**
   When the user opens the application, display an elegant Islamic popup dialog on `HomeScreen` containing a randomly selected Hadith from the SQLite database (`hades` table, containing 370 Hadiths), with clean text parsing, a Share button, a "حديث آخر" (next random Hadith) option, and a dismiss button.

## 2. Atomic Execution Steps
- [x] [Step 1: Remove `fullScreenIntent: true` from `NotificationService.dart` and remove `USE_FULL_SCREEN_INTENT` from `AndroidManifest.xml`]
- [x] [Step 2: Add `getRandomHadith()` query to `HadesModel.dart` with HTML text stripping / formatting]
- [x] [Step 3: Create `RandomHadithDialog` widget with Islamic styling and integrate cold-start display in `HomeScreen.dart`]
- [x] [Step 4: Verification with `dart analyze` / `flutter analyze` and audit log completion]

## 3. Implementation Reality & Audit Log
- **Step 1 (Completed 2026-09-18):**
  - Updated `code/lib/Notifications/Local/NotificationService.dart`: Changed `fullScreenIntent: true` to `fullScreenIntent: false` in `androidPlatformChannelSpecifics`. Notifications now retain `Importance.max` and `Priority.high` with full audio playback without locking onto full-screen launch intents.
  - Updated `code/android/app/src/main/AndroidManifest.xml`: Removed `<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT"/>` to adhere to Google Play Android 14+ policies and prevent unwanted foreground takeovers on device unlock.
  - Verified with `dart analyze code/lib/Notifications/Local/NotificationService.dart` (0 errors).

- **Step 2 (Completed 2026-09-18):**
  - Updated `code/lib/models/HadesModel.dart`.
  - Added `getRandomHadith()` method querying SQLite table `hades` using `SELECT * FROM hades ORDER BY RANDOM() LIMIT 1` (sampling from 370 verified Hadiths).
  - Added `getCleanText(ApiModel model)` helper utilizing `HtmlCharacterEntities.decode` and `HtmlToMarkdown` with regex normalization to convert raw HTML tags into clean, human-readable Arabic text.
  - Verified with `dart analyze code/lib/models/HadesModel.dart` (0 errors).

- **Step 3 (Completed 2026-09-18):**
  - Created `code/lib/widget/RandomHadithDialog.dart`:
    - Responsive Material 3 Islamic dialog styled in accordance with `.tailorai/Architecture/Visual_Identity.md`.
    - Features: "من هدي النبوة" spiritual badge, scrollable body with `Cairo` typography (1.8 line height), dynamic "حديث آخر" button to cycle through Hadiths without dismissing dialog, and "مشاركة" button to share via `SharePlus`.
  - Integrated into `code/lib/screens/HomeScreen/View/HomeScreen.dart`:
    - Added `_showInitialRandomHadith()` scheduled via `WidgetsBinding.instance.addPostFrameCallback` with session guard (`_hasShownInitialHadith`) to prevent repetitive popups on inner screen navigation.
    - Linked `shareAppText` widget on `HomeScreen` with an `InkWell` tap listener allowing users to re-open the random Hadith dialog on demand at any time.
  - Verified with `dart analyze` (0 errors).

- **Step 4 (Completed 2026-09-18):**
  - Ran comprehensive `dart analyze code/lib/` across the entire codebase. Verified 0 compile errors.
  - Cleaned up temporary test artifacts (`code/assets/db/main.db`).
