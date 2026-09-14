# Task: Fix ViewScreen Duaa Loading Spinner & Native ConvertDateScreen (محول التقويم)
- **Date:** 2026-09-10
- **Category:** bugfix
- **Target Files:**
  - lib/screens/ViewScreen/Controller/ViewController.dart
  - lib/screens/ViewScreen/View/ViewScreen.dart
  - lib/screens/listViewScreen/Controller/listViewController.dart
  - lib/screens/ConvertDateScreen/View/ConvertDateScreen.dart
  - lib/AppRoutes.dart
  - web_server.py

## 1. Objective
1. Fix the issue where tapping on any Duaa in 'الدعاء فى القرآن' kept spinning a circular progress indicator indefinitely on Flutter Web.
2. Fix 'محول التقويم' (Calendar Converter) which displayed a blank screen by implementing a 100% native Flutter screen with bidirectional Gregorian/Hijri conversion.

## 2. Atomic Execution Steps
- [x] Step 1: Update `ViewController.dart` to bypass `initWeb` on Web (`kIsWeb`), ensure `readFromDB` has safe fallbacks, and guarantee `loading = false`.
- [x] Step 2: Update `ViewScreen.dart` to render `txtWidget()` on Web (`kIsWeb`) or when WebView is unavailable, with enhanced styling and text selection.
- [x] Step 3: Update `listViewController.dart` to guarantee `isLoading = false` in `getFromDB()`.
- [x] Step 4: Create native Flutter screen `ConvertDateScreen.dart` with modern UI, astronomical Julian day calculation algorithm, Arabic month names, copy/share actions, and connect it in `AppRoutes.dart`.
- [x] Step 5: Rebuild Flutter Web (`flutter build web --release`) and verify both Duaa and Calendar Converter on `http://localhost:8080`.

## 3. Implementation Reality & Audit Log
- In `lib/screens/ViewScreen/Controller/ViewController.dart`:
  - Added `kIsWeb` detection in `onInit` to immediately set `loading = false; update(); return;`.
  - Wrapped `initWeb` and `readFromDB` in `try / catch` blocks.
- In `lib/screens/ViewScreen/View/ViewScreen.dart`:
  - Switched body rendering from `web()` to `(kIsWeb ? txtWidget() : web())`.
  - Redesigned `txtWidget()` with an elegant card container, max-width constraints (800px), `SelectableText`, and clear Arabic typography.
- In `lib/screens/listViewScreen/Controller/listViewController.dart`:
  - Enclosed `onInit` and `getFromDB` in `try / finally` to ensure `isLoading = false;` is always set.
- In `lib/screens/ConvertDateScreen/View/ConvertDateScreen.dart`:
  - Created a 100% native Flutter screen for calendar conversion between Gregorian and Hijri with zero webview dependency.
  - Implemented the exact astronomical Julian day algorithm from `convertdate.html`.
  - Added modern interactive controls: tab switching, calendar picker, day/month/year dropdowns, copy and share actions, and responsive layout.
- In `lib/AppRoutes.dart`:
  - Routed `AppModel.convertDate` directly to `ConvertDateScreen`.
- Successfully built `flutter build web --release`.
