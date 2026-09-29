# Task: Audio Morning/Evening Azkar & Custom Scheduled Audio Reminders
- **Date:** 2026-09-29
- **Category:** feature
- **Target Files:**
  - `code/lib/screens/AudioAzkarScreen/View/AudioAzkarScreen.dart`
  - `code/lib/screens/AudioAzkarScreen/Controller/AudioAzkarController.dart`
  - `code/lib/screens/CustomScheduleScreen/View/CustomScheduleScreen.dart`
  - `code/lib/Notifications/Local/NotificationService.dart`
  - `code/lib/models/ZekerBuildNotifications/BuildNotifications.dart`
  - `code/lib/models/zekerModel.dart`
  - `code/lib/helper/dbSQLiteProvider.dart`

## 1. Objective
Develop an audio-first Morning and Evening Azkar module (أذكار الصباح والمساء الصوتية) alongside a flexible custom audio scheduler:
1. **Morning & Evening Wake/Sleep Schedulers:**
   - Allow users to specify wake-up time (وقت الاستيقاظ) to automatically receive notifications and trigger full Morning Azkar recitation.
   - Allow users to specify sleep/evening time (وقت النوم) to receive notifications and trigger full Evening Azkar recitation.
   - Built-in continuous audio player with playlist queue, pause/resume, seek bar, and background playback support (`just_audio_background`).
2. **Custom Intermediate Audio Reminders (إشعارات صوتية مخصصة):**
   - Provide an interface for users to create custom scheduled reminders at any designated time of the day.
   - Enable users to assign custom titles (e.g., "أذكار ما بعد الظهر", "استغفار قبل الغروب").
   - Connect each reminder to the app's sound library (201+ audio dhikr files), allowing the user to pick specific audio tracks to be played or triggered with the notification.
3. **Cross-Platform Scheduling Persistence:**
   - Store custom user schedules in local SQLite database (`custom_audio_schedules` table) with SharedPreferences sync.
   - Schedule reliable exact alarms via `flutter_local_notifications` (Android exact alarms, iOS local triggers, Web periodic timer fallback).

## 2. Atomic Execution Steps
- [ ] [Step 1: Database & Model Layer — Create `CustomAudioScheduleModel` and SQLite schema migration for custom audio reminders]
- [ ] [Step 2: Notification & Audio Engine — Extend `NotificationService` and `BuildNotifications` to support exact time-of-day audio triggers and custom sound payloads]
- [ ] [Step 3: UI Implementation — Build `AudioAzkarScreen` (Morning/Evening player, wake/sleep time pickers, and audio controls)]
- [ ] [Step 4: UI Implementation — Build `CustomAudioReminderDialog` with audio selection list from `zeker` sound library and time picker]
- [ ] [Step 5: Verification & Testing — Validate with `flutter analyze`, test background audio, notification delivery, and lifecycle persistence]

## 3. Implementation Reality & Audit Log
*(Future implementation log will be recorded here)*
