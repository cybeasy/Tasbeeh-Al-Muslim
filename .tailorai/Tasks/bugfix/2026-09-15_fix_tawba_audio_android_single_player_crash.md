# Task: Fix Tawba Audio on Android (Single Player Crash)
- **Date:** 2026-09-15
- **Category:** bugfix
- **Target Files:**
  - `code/lib/screens/RunTawbaScreen/Controller/RunTawbaController.dart`
  - `code/lib/screens/RunTawbaScreen/View/RunTawbaScreen.dart`

## 1. Objective
Fix audio playback failure in the Tawba screen (قسم التوبة) on Android caused by:
`PlatformException(error, just_audio_background supports only a single player instance, null, null)`

### Root Cause
1. `just_audio_background` replaces the underlying audio service platform on Android to enable lock-screen notifications and media controls. By design, `just_audio_background` strictly supports **only one single `AudioPlayer` instance** in the app.
2. In a previous commit to fix audio leakage on Web, `RunTawbaController` instantiated a separate `final AudioPlayer _audioPlayer = AudioPlayer();`.
3. When `RunTawbaController.initSound()` ran on Android and called `_audioPlayer.setAudioSource()`, `just_audio_background` rejected the second instance with `PlatformException(error, just_audio_background supports only a single player instance)`, crashing the audio initialization and preventing playback.

## 2. Atomic Execution Steps
- [x] Step 1: Refactor `RunTawbaController.dart` to use the global shared `player` from `main.dart` with robust lifecycle management (`stop` and `setLoopMode(LoopMode.off)` on `dispose`), and validate sound file paths before loading.
- [x] Step 2: Ensure `RunTawbaScreen.dart` properly triggers controller lifecycle cleanup on exit.
- [x] Step 3: Verify using `flutter analyze` and test audio playback on the running Android device/emulator.

## 3. Implementation Reality & Audit Log
1. **Refactored `RunTawbaController.dart`**:
   - Removed duplicate `AudioPlayer _audioPlayer` instantiation.
   - Connected playback to the shared global `player` from `main.dart`.
   - Added null/empty safety guards on `model?.soundfile` and `model?.time`.
   - Guaranteed full cleanup on `dispose()` (`await player.stop(); await player.setLoopMode(LoopMode.off);`).
   - Improved `checkSound()` to respect counter run state (`isRun`).
   - Handled session completion to stop sound and reset `isRun` when target count is reached.
2. **Verified Static Analysis**:
   - Ran `flutter analyze lib/screens/RunTawbaScreen/` with zero compile errors.

3. **User Verification**: Confirmed audio playback is working perfectly on Android emulator/device.
