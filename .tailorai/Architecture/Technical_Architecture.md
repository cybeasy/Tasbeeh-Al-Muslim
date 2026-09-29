# Technical Architecture Overview — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Tech Stack
| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| Client Framework | Flutter (Dart SDK) | Flutter 3.47.2 / Dart ^3.8.1 | Cross-platform client (Android, iOS & Web/PWA) |
| State Management | Flutter BLoC / Cubit | flutter_bloc ^9.1.1, bloc ^9.0.0 | Predictable, reactive state management (AppCubit, ThemeAppCubit) |
| Local Database | SQLite (sqflite + sqflite_common_ffi_web) | sqflite ^2.4.2, ffi_web ^1.1.1 | Cross-platform relational store (native file on mobile, Wasm/IndexedDB on web) |
| Key-Value Storage | SharedPreferences | shared_preferences ^2.5.3 | Settings, theme mode, quiet hours, cached states (`CashLocal`) |
| Audio Engine | just_audio + background | just_audio ^0.10.4, just_audio_background ^0.0.1-beta.17 | Offline sound playback and online background streaming with lock screen controls |
| Notifications | flutter_local_notifications | ^19.4.0 | Timezone-aware scheduled local notifications with custom sound channels |
| Cloud Services | Firebase Suite | Core ^3.1.1, Analytics ^11.1.0, Crashlytics ^4.0.2, Messaging ^15.0.2 | Telemetry, crash monitoring, and remote push notifications |
| Networking / Web | http & webview_flutter | http ^1.1.0, webview_flutter ^4.0.1 | Remote audio catalog APIs and offline HTML utility rendering |
| Client Security Headers | Custom HttpClient | Dart http wrapper | App verification (`X-App-Platform`, `X-App-Version`, `X-App-Client`) |
| Backend Runtime | PHP | 8.1+ | Lightweight REST JSON endpoints (`/api/v3/`) |
| Security Engine | Custom PHP Rate Limiter & Bot Filter | sliding window IP limiter | IP-based request throttle (60/min), User-Agent bot block, strict CORS |
| Web Server | Apache | 2.4+ (mod_rewrite, mod_headers) | Static landing page, Flutter Web SPA routing, API gateway, source code denial |
| Typography & UI | Google Fonts | google_fonts ^6.2.1 | Cairo Arabic typography with Material 3 theming |

## 2. Architecture Pattern
- **Pattern:** Layered Architecture with Controller/View + Cubit State Management.
- **Separation of Concerns:**
  - `code/lib/screens/[ScreenName]/View/`: Declarative UI widgets, responsive layouts, Material 3 theming.
  - `code/lib/screens/[ScreenName]/Controller/`: Presentation logic, lifecycle hooks, and interaction handlers.
  - `code/lib/Bloc/`: Global state containers (`AppCubit` for navigation/menu, `ThemeAppCubit` for light/dark mode).
  - `code/lib/models/`: Domain entities and data models (parsing SQLite rows and JSON envelopes).
  - `code/lib/helper/`: Database providers (`dbSQLiteProvider`), caching (`CashLocal`), HTTP client (`http_client.dart`), and extensions.
  - `code/lib/config/`: Centralized environment configurations (`AppConfig.dart`).
  - `code/lib/Notifications/`: Notification channels and background scheduling services (`NotificationService`).

## 3. Directory Structure
```text
Tasbeeh-Al-Muslim/ (Repository Root)
├── index.html                          # Marketing Landing Page (with direct Web App buttons)
├── index2.html                         # Secondary landing page variant
├── vapp-landing/                       # Landing page styles, scripts, visual assets & vendor libs
│   └── vendor/                         # Third-party vendor libraries
├── PrivacyPolicy/                      # Privacy policy document and HTML pages
├── app/                                # Production Flutter Web build (<base href="/Tasbeeh-Al-Muslim/app/">)
│   ├── index.html                      # Flutter Web entry point
│   ├── .htaccess                       # SPA History Routing & Security Headers
│   ├── sqlite3.wasm                    # Relational database engine for web
│   └── ...
├── code/                               # Complete Flutter Mobile & Web Source Code
│   ├── .env                            # Environment variables (APP_DOMAIN, API_BASE_PATH)
│   ├── .env.example                    # Template for environment settings
│   ├── pubspec.yaml                    # Flutter dependencies and asset registrations
│   ├── .htaccess                       # Source code protection (Require all denied)
│   ├── android/, ios/, web/            # Platform native implementations
│   └── lib/
│       ├── config/AppConfig.dart       # Centralized domain and endpoint resolver
│       ├── Bloc/AppCubit.dart          # Main application Cubit
│       ├── helper/connection/          # HttpClient with anti-bot headers
│       └── ...
├── api/                                # Backend PHP API v3 with Anti-Bot Engine
│   └── v3/
│       ├── security.php                # Multi-Layer Anti-Bot & Rate Limiting Engine
│       ├── config.php                  # Centralized domain, CORS, and rate limit settings
│       ├── constants.php               # API action and type definitions
│       ├── base.php                    # Dynamic base URL calculation
│       ├── radio.php                   # 177 Islamic Radio stations
│       ├── mp3Quran_ver2.php           # 241 Quran reciters & 114 surahs
│       ├── mp3Quran_tafser.php         # Tafsir commentary stations
│       └── api_test.php                # Automated test harness for API endpoints
├── scripts/
│   └── build_server.sh                 # Unified build script (builds into app/)
└── .htaccess                           # Root Apache config (protects code/ and routes to api/)
```

## 4. Key Design Patterns
- **Singleton Pattern:** `dbSQLiteProvider.db`, `CashLocal`, `NotificationService`, `HttpClient`.
- **Bloc/Cubit Pattern:** Unidirectional data flow for app modes and global lists.
- **Centralized Configuration:** `AppConfig.dart` on client and `config.php` on server for domain and environment portability.
- **Multi-Layer Security:** IP Sliding Window Rate Limiting, User-Agent Bot Filtering, and Domain-Restricted CORS.

## 5. Web & API v3 Production Architecture (cybeasy.com/Tasbeeh-Al-Muslim/)

### 5.1 System Topology
```text
                         [ Browser Visitor / Mobile App ]
                                         │
                                         ▼
                 [ Apache Web Server: cybeasy.com/Tasbeeh-Al-Muslim/ ]
                                         │
         ┌───────────────────────────────┼───────────────────────────────┐
         ▼                               ▼                               ▼
[ Landing Page: / ]             [ Flutter Web App: /app/ ]      [ PHP API v3: /api/v3/ ]
- index.html (Marketing)        - index.html (SPA)              - security.php (Anti-Bot)
- vapp-landing/ assets          - base href: .../app/           - 60 req/min Rate Limiter
- CTA: Open Web App             - sqlite3.wasm (Wasm FFI)       - Domain-restricted CORS
                                - SPA .htaccess rewrite         - Radio, Quran, Tafsir
```

### 5.2 Component Breakdown
- **Frontend SPA (`app/`):** Flutter Web compiled with CanvasKit/HTML. Configured with `<base href="/Tasbeeh-Al-Muslim/app/">` and local `.htaccess` handling HTML5 history routing.
- **Backend Services (`api/v3/`):** Lightweight PHP 8.x endpoints protected by `security.php`:
  - `security.php`: IP rate limiter (60 req/min, 429 status), bad bot blocker (403 status), CORS validation.
  - `config.php`: Centralized domain (`cybeasy.com`), base paths, and rate limits.
  - `base.php`: Computes `$baseUrl` dynamically relative to `$_SERVER['SCRIPT_NAME']`.
- **Flutter Client Integration (`code/lib/`):**
  - `AppConfig.dart`: Resolves full URLs dynamically.
  - `http_client.dart`: Automatically transmits official client headers (`X-App-Platform`, `X-App-Version`, `X-App-Client`) and normalizes subpath origins on web.
