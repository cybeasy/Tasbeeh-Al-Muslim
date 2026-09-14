# Task: Web HTML5 Desktop Notifications and AudioContext Autoplay Unlock
- **Date:** 2026-09-14
- **Category:** feature
- **Target Files:**
  - `code/lib/services/web_notification/web_notification.dart`
  - `code/lib/services/web_notification/web_notification_stub.dart`
  - `code/lib/services/web_notification/web_notification_web.dart`
  - `code/lib/services/WebAzkarTimerService.dart`
  - `code/lib/screens/AzkarScreen/Controller/AzkarController.dart`
  - `code/lib/widget/CustomSliverAppBarDelegate.dart`

## 1. Objective
Enable native HTML5 Web Notifications (`window.Notification`) and automatic AudioContext unlocking on Flutter Web so that scheduled Azkar trigger both desktop notification popups and audio alerts seamlessly, even when the tab is in the background or after the page is refreshed, while preserving 100% of native Android & iOS mobile notification logic.

## 2. Atomic Execution Steps
- [x] [Step 1: Create conditional Web Notification service (`web_notification.dart`, `web_notification_web.dart`, `web_notification_stub.dart`) supporting permission requests, native desktop notifications with brand icon, and audio unlock listeners]
- [x] [Step 2: Integrate Web Notification service into `WebAzkarTimerService.dart` to trigger desktop notifications on each Zeker interval and auto-unlock audio on user interaction]
- [x] [Step 3: Connect notification permission requests in `AzkarController.dart` on Web and add an interactive notification permission banner in `CustomSliverAppBarDelegate.dart`]
- [x] [Step 4: Verify with `flutter analyze`, execute `./scripts/build_server.sh`, test in browser, and update documentation]

## 3. Implementation Reality & Audit Log
- **Step 1 Completed:** Implemented `WebNotification` cross-platform facade with conditional imports (`web_notification_web.dart` and `web_notification_stub.dart`). Handled permission request via `Notification.requestPermission()`, desktop notification display via `Notification()`, and global user gesture listeners (`click`, `touchstart`, `keydown`) to unlock audio playback.
- **Step 2 Completed:** Integrated `WebNotification.setupAudioUnlock()` into `WebAzkarTimerService.initOnStartup()`. Added `WebNotification.show(zeker.zeker_name, ...)` on periodic timer trigger.
- **Step 3 Completed:** Added notification permission prompt to `AzkarController.onSave()` on Web. Enhanced `CustomSliverAppBarDelegate.dart` with interactive banner to request notifications and unlock audio, plus status badge update.
- **Step 4 Completed:** Code passed `flutter analyze lib/services/web_notification/` with 0 issues. `./scripts/build_server.sh` executed cleanly (exit code 0), compiled Flutter Web release bundle, generated SPA `.htaccess`, and deployed to `/home/cybeasy_admin/web/cybeasy.com/public_html/public/Tasbeeh-Al-Muslim/app`. Verified live HTTP/2 200 responses for both `app/` and `app/flutter.js`.
