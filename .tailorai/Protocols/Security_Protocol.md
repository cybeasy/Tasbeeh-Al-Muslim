# Security Protocol & Data Protection — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Authentication & Authorization
- **Authentication Mechanism:** Standalone client application. No user credentials or session tokens are required for core features. Anonymous device identifier utilized for Firebase Cloud Messaging (FCM).
- **Authorization & OS Permissions:** 
  - Dynamic runtime permission requests managed via `permission_handler`.
  - Notification permission (`POST_NOTIFICATIONS`) for Android 13+.
  - Background audio playback permissions on iOS (`UIBackgroundModes: audio`).
- **Tenant Isolation:** N/A — Standalone single-tenant client application.

## 2. Input Validation & Data Integrity
- **Validation Engine:** Dart Strong Typing, Sound Null Safety, and model-level JSON validation (`ApiModel`, `ZekerModel`).
- **Database Query Protection:** All SQLite queries executed via parameterized queries in `sqflite` to eliminate SQL injection risks.
- **File Upload Security:** N/A — The application does not expose user file upload endpoints.

## 3. Data Protection & Secrets Management
- **Local Sandbox Storage:** Pre-packaged SQLite database and user preferences reside exclusively within the application's private sandbox directory (`getApplicationDocumentsDirectory()`).
- **Transport Security:** All remote communication with audio APIs and Firebase strictly enforces HTTPS/TLS encryption.
- **Credential Storage:** No private API keys or database passwords committed to source control. Firebase configuration configured via `firebase_options.dart`.

## 4. Network Optimization & Resilience
- **Client-Side Caching:** Remote API responses cached locally via `CashLocal` to reduce bandwidth consumption and ensure offline usability.
- **Anti-Disturbance (Quiet Hours):** User-defined sleep periods (`SleepHourClass`) prevent unwanted audio alerts during specified hours.
