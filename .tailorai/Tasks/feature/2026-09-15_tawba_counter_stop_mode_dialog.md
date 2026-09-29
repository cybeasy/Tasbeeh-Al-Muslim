# Task: Tawba Counter Target vs Continuous Mode Dialog
- **Date:** 2026-09-15
- **Category:** feature
- **Target Files:**
  - `code/lib/screens/RunTawbaScreen/Controller/RunTawbaController.dart`
  - `code/lib/screens/RunTawbaScreen/View/RunTawbaScreen.dart`

## 1. Objective
Add an interactive selection dialog when the user taps "ابدأ" in the Tawba screen (قسم التوبة), giving the user the choice between:
1. **Stop at Target (التوقف عند العدد المحدد)**: e.g. stops automatically at 100, plays audio until complete, and shows the completion blessing.
2. **Continuous Mode (الاستمرار دون توقف)**: continues counting beyond the target count until the user manually taps "ايقاف".

## 2. Atomic Execution Steps
- [x] Step 1: Update `RunTawbaController.dart` with `stopAtTarget` state, separate `startSession({required bool stopAtTarget})` and `stopSession()`, and update `doInCounter()` logic to respect the chosen mode.
- [x] Step 2: Implement modern Arabic choice Dialog/BottomSheet in `RunTawbaScreen.dart` on "ابدأ" click matching the app's visual identity, and update the counter label when running in continuous mode.
- [x] Step 3: Verify with `flutter analyze` and test on device.

## 3. Implementation Reality & Audit Log
1. **Refactored `RunTawbaController.dart` (Step 1)**:
   - Added `bool stopAtTarget = true` state.
   - Added `startSession({required bool stopAtTarget})` which auto-resets `count` if previously finished, starts sound if unmuted, and launches `runCounter()`.
   - Added `stopSession()` which halts counter loop and pauses audio.
   - Updated `btnRunCounterClick({bool? stopAtTargetMode})` to support both modes seamlessly.
   - Enhanced `doInCounter()`: when reaching target count (`count == model.count`), if `stopAtTarget` is true it halts and shows completion blessing; if false it shows a progress toast and continues counting.
   - Verified with `flutter analyze` with 0 compile errors.

2. **Implemented Choice Bottom Sheet in `RunTawbaScreen.dart` (Step 2)**:
   - Added `_showModeSelectionDialog(BuildContext context)` with high-end Arabic styling and RTL alignment.
   - Option 1: 🎯 "التوقف عند الهدف (X مرة)" -> starts session with `stopAtTarget: true`.
   - Option 2: ♾️ "الاستمرار دون توقف" -> starts session with `stopAtTarget: false`.
   - Connected bottom button: if running, taps directly stop session (`stopSession()`); if stopped, taps open the choice sheet.
   - Updated counter display: shows `count / target` in target mode, and `count / مستمر` in continuous mode.
   - Upgraded deprecated `withOpacity` to modern Flutter `withValues(alpha: ...)`.
3. **Verification (Step 3)**:
   - Ran `flutter analyze lib/screens/RunTawbaScreen/` with zero errors or warnings.

4. **User Confirmation**: Feature tested and verified successfully by the user on Android.
