# Task: Fix Tawba Audio Leaking into Quran Audio Player
- **Date:** 2026-09-10
- **Category:** bugfix
- **Target Files:**
  - `lib/screens/RunTawbaScreen/Controller/RunTawbaController.dart`
  - `lib/screens/RunTawbaScreen/View/RunTawbaScreen.dart`
  - `lib/screens/AudioPlayerScreen/Controller/AudioPlayerController.dart`

## 1. Objective
Fix the issue where playing audio in the Tawbah section (قسم التوبة) causes that same Tawbah audio to persist and play inside the Holy Quran audio screen (قسم القرآن الكريم صوت) instead of the selected Surah.

### Root Cause
1. `RunTawbaController` directly manipulated the single global `player` (`AudioPlayer`) declared in `main.dart` which is intended for the Quran/Radio media player. It loaded the Tawbah asset sound (`a7_1.mp3`) into `player` and set `player.setLoopMode(LoopMode.all)`.
2. When leaving `RunTawbaScreen`, only `player.pause()` was called, leaving the Tawbah audio loaded and paused at its current position with `LoopMode.all`.
3. When navigating to `AudioPlayerScreen`, `player` was not stopped or reset before loading the new playlist. The UI and stream listeners immediately exposed the stale Tawbah audio, and playing or interrupted loading caused the player to resume the Tawbah audio instead of playing the Quran recitation.

## 2. Atomic Execution Steps
- [x] Step 1: Isolate Tawba audio by giving `RunTawbaController` its own dedicated `AudioPlayer` instance with proper lifecycle disposal (`stop` and `dispose`), removing all dependency on the global `player`.
- [x] Step 2: Update `RunTawbaScreen.dart` to call `_controller.dispose()` on screen disposal.
- [x] Step 3: Fortify `AudioPlayerController.dart` by ensuring `player.stop()` is called and `player.setLoopMode(LoopMode.off)` is reset before loading any new playlist, and properly clearing the playlist before building.
- [x] Step 4: Verify with `flutter analyze` and rebuild Flutter web bundle.

## 3. Implementation Reality & Audit Log
1. **RunTawbaController Isolation**:
   - Replaced global `player` usage with private `final AudioPlayer _audioPlayer = AudioPlayer();`.
   - In `playSound()`, safely paused background Quran `player` if active to avoid overlapping playback.
   - Added `dispose()` method in `RunTawbaController` to call `_audioPlayer.stop()` and `_audioPlayer.dispose()`.
   - Cleaned up unused imports in `RunTawbaController.dart`.
2. **RunTawbaScreen Lifecycle**:
   - In `dispose()`, removed manual pause of global player and now calls `_controller.dispose()`.
3. **AudioPlayerController Defense**:
   - In `_init()`, explicitly called `await player.stop();` and `await player.setLoopMode(LoopMode.off);` before loading any playlist.
   - Added `playlist.clear()` before building audio playlist.
   - Fixed naming convention warnings and removed duplicate import of `just_audio_background`.
4. **Verification & Web Rebuild**:
   - Ran `flutter analyze` ensuring zero errors in modified controllers and views.
   - Rebuilt Flutter web distribution via `flutter build web --release` successfully.
