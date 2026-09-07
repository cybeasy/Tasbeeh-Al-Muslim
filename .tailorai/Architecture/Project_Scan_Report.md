# Project Scan Report
- **Scan Date:** 2026-09-07
- **Project Name:** tsbeh (Flutter Tasbeeh Al Muslim)
- **Tech Stack:**
  - Client / Framework: Flutter (Dart SDK ^3.8.1, Flutter 3.47.2 via FVM)
  - Target Platforms: Android, iOS, Web, macOS, Linux, Windows
  - State Management: BLoC / Cubit (flutter_bloc ^9.1.1, bloc ^9.0.0), Provider (^6.0.1)
  - Backend / Cloud Services: Firebase (Core, Analytics, Crashlytics, Cloud Messaging)
  - Database: SQLite (sqflite ^2.0.0+4, preloaded DB assets/db/databaseV1.db), SharedPreferences (^2.5.3)
  - Storage: Local File Storage (path_provider, SQLite, SharedPreferences)
  - Audio Engine: just_audio (^0.10.4), just_audio_background (^0.0.1-beta.17), audio_session (^0.2.2)
  - Notifications: flutter_local_notifications (^19.4.0), timezone (^0.10.1)
- **Locales & Languages:** Multilingual (Arabic: ar, English: en)
- **Directory Layout:**
  ```
  .
  ├── analysis_options.yaml
  ├── android/
  ├── assets/
  │   ├── convertdate.html
  │   ├── db/
  │   ├── images/
  │   └── sounds/
  ├── devtools_options.yaml
  ├── firebase.json
  ├── ios/
  ├── lib/
  │   ├── AppRoutes.dart
  │   ├── Bloc/
  │   ├── firebase_options.dart
  │   ├── helper/
  │   ├── l10n/
  │   ├── language/
  │   ├── main.dart
  │   ├── models/
  │   ├── Notifications/
  │   ├── screens/
  │   ├── Theme/
  │   └── widget/
  ├── linux/
  ├── macos/
  ├── pubspec.yaml
  ├── README.md
  ├── screenShots/
  ├── test/
  ├── web/
  └── windows/
  ```
- **Legacy Agent Detected:** No
