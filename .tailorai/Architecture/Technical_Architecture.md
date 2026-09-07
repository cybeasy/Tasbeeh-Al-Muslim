# Technical Architecture Overview — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Tech Stack
| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| Client Framework | Flutter (Dart SDK) | Flutter 3.47.2 / Dart ^3.8.1 | Cross-platform mobile client (Android & iOS primary) |
| State Management | Flutter BLoC / Cubit | flutter_bloc ^9.1.1, bloc ^9.0.0 | Predictable, reactive state management (AppCubit, ThemeAppCubit) |
| Local Database | SQLite (sqflite) | sqflite ^2.0.0+4 | Pre-populated offline relational store (`assets/db/databaseV1.db`) |
| Key-Value Storage | SharedPreferences | shared_preferences ^2.5.3 | Settings, theme mode, quiet hours, cached states (`CashLocal`) |
| Audio Engine | just_audio + background | just_audio ^0.10.4, just_audio_background ^0.0.1-beta.17 | Offline sound playback and online background streaming with lock screen controls |
| Notifications | flutter_local_notifications | ^19.4.0 | Timezone-aware scheduled local notifications with custom sound channels |
| Cloud Services | Firebase Suite | Core ^3.1.1, Analytics ^11.1.0, Crashlytics ^4.0.2, Messaging ^15.0.2 | Telemetry, crash monitoring, and remote push notifications |
| Networking / Web | http & webview_flutter | http ^1.1.0, webview_flutter ^4.0.1 | Remote audio catalog APIs and offline HTML utility rendering |
| Typography & UI | Google Fonts | google_fonts ^6.2.1 | Cairo Arabic typography with Material 3 theming |

## 2. Architecture Pattern
- **Pattern:** Layered Architecture with Controller/View + Cubit State Management.
- **Separation of Concerns:**
  - `lib/screens/[ScreenName]/View/`: Declarative UI widgets, responsive layouts, Material 3 theming.
  - `lib/screens/[ScreenName]/Controller/`: Presentation logic, lifecycle hooks, and interaction handlers.
  - `lib/Bloc/`: Global state containers (`AppCubit` for navigation/menu, `ThemeAppCubit` for light/dark mode).
  - `lib/models/`: Domain entities and data models (parsing SQLite rows and JSON envelopes).
  - `lib/helper/`: Database providers (`dbSQLiteProvider`), caching (`CashLocal`), HTTP client (`http_client.dart`), and extensions.
  - `lib/Notifications/`: Notification channels and background scheduling services (`NotificationService`).

## 3. Directory Structure
```text
tsbeh/
├── .fvm/                               # Flutter Version Management config (Flutter 3.47.2)
├── android/                            # Native Android project with custom notification sounds
├── ios/                                # Native iOS project with Podfile and audio background mode
├── assets/
│   ├── convertdate.html                # Offline Hijri/Gregorian date converter
│   ├── db/
│   │   └── databaseV1.db               # Pre-populated SQLite database (~7.1 MB)
│   ├── images/                         # Static icons and raster assets
│   └── sounds/                         # Athkar audio files (MP3/WAV)
├── lib/
│   ├── AppRoutes.dart                  # Centralized routing & intent dispatch
│   ├── main.dart                       # App entry point, background services & DI initialization
│   ├── firebase_options.dart           # Generated Firebase configuration
│   ├── Bloc/                           # App-wide Cubits and observers
│   ├── helper/                         # SQLite provider, HTTP client, local cache, extensions
│   ├── l10n/                           # Localization ARB files (app_ar.arb, app_en.arb)
│   ├── language/                       # Localization controllers and delegates
│   ├── models/                         # Domain models (Zeker, Hadith, Tawba, Audio, Quran)
│   ├── Notifications/                  # Notification service & channel configurations
│   ├── screens/                        # Feature screens (HomeScreen, AzkarScreen, AudioPlayer, etc.)
│   ├── Theme/                          # AppTheme, Material 3 color schemes, typography
│   └── widget/                         # Reusable UI widgets
└── .tailorai/                          # AI governance, architecture, and task tracker
```

## 4. Key Design Patterns
- **Singleton Pattern:** `dbSQLiteProvider.db`, `CashLocal`, `NotificationService` for single-instance resource management.
- **Bloc/Cubit Pattern:** Unidirectional data flow for app modes and global lists.
- **Adapter / Router Dispatcher:** `AppRoutes.openAction()` dynamically resolves action types (`ApiSubType`) to route destinations.
- **Observer Pattern:** `observer_bloc.dart` logs state transitions during debugging.

## 5. API Design & Remote Services
- **Base Endpoint:** `https://api.4topapps.com/APPS/tsbeh/v3/`
- **Core Endpoints:**
  - `mp3Quran_ver2.php`: Quran audio reciters and surah listings.
  - `radio.php`: Islamic live radio streams catalog.
  - `mp3Quran_tafser.php`: Quranic audio explanation (Tafseer).
- **Caching Strategy:** Network responses cached locally via `CashLocal` with fallback to offline data.

## 6. Database Schema (SQLite `databaseV1.db`)
- **`zeker`**: Pre-configured audio dhikr items, repetition counts, intervals, and display orders.
  - Columns: `id (INTEGER)`, `zeker_id (VARCHAR)`, `zeker_type_id (INTEGER)`, `zeker_type (VARCHAR)`, `zeker_name (VARCHAR)`, `zeker_repeat (INTEGER)`, `zeker_time (INTEGER)`, `zeker_order (INTEGER)`.
- **`islam_events`**: Islamic and Hijri historical events.
  - Columns: `id (INT)`, `h_day`, `h_month`, `h_month_number`, `h_year`, `h_date`, `m_date`, `m_day`, `m_moth`, `m_year`, `title`, `html`.
- **`azkar_elyome`**: Categorized daily athkar (Morning, Evening, Sleep, etc.).
  - Columns: `id (INT)`, `categid (INT)`, `categ (VARCHAR)`, `title (LONGTEXT)`.
- **`doaaquran`**: Supplications directly extracted from the Holy Quran.
  - Columns: `id (INT)`, `title (LONGTEXT)`, `categ (LONGTEXT)`.
- **`firstinislam`**: Historic firsts in Islamic history with references.
  - Columns: `id (INT)`, `categid (INT)`, `categ (VARCHAR)`, `title (LONGTEXT)`, `المصدر (VARCHAR)`, `الرابط (VARCHAR)`.
- **`hades`**: Prophetic traditions (Hadiths) with push notification markers.
  - Columns: `id (INT)`, `photo (VARCHAR)`, `titleOrg (LONGTEXT)`, `title (VARCHAR)`, `description (LONGTEXT)`, `html (LONGTEXT)`, `usedforpush (INT)`.
- **`tawba`**: Prayers, athkar, and supplications of repentance.
  - Columns: `id (INTEGER)`, `categid (INTEGER)`, `categ (VARCHAR)`, `title (LONGTEXT)`, `count (INTEGER)`, `reference (VARCHAR)`, `soundfile (VARCHAR)`, `time (INTEGER)`.

## 7. External Services & Integrations
- **Firebase Core & Cloud Messaging:** Push notifications and remote campaigns.
- **Firebase Analytics & Crashlytics:** User telemetry, event tracking, and runtime crash reporting.
- **Google Play & App Store Review Helper:** Prompting in-app ratings and store reviews.
- **App Update Notification:** Automatic version comparison (`UpdateNewVer`) against latest store releases.
