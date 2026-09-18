# tsbeh (Flutter Tasbeeh Al Muslim) — Knowledge Base Map (Master Index)

## 1. Core Foundations (Mandatory Context)
- `.tailorai/Agent.md`: Core AI rules, identity, task creation protocols, and execution mandates.
- `.tailorai/Architecture/Technical_Architecture.md`: System architecture, tech stack layout, and folder structure.
- `.tailorai/Architecture/PRD.md`: Product requirements, user roles, and module scope.
- `.tailorai/Architecture/Visual_Identity.md`: UI/UX design tokens, color palette, typography, and styling rules.
- `.tailorai/Protocols/API_Contracts.md`: Standardized API responses, HTTP codes, and dual-key data envelopes.
- `.tailorai/Protocols/Security_Protocol.md`: Authentication, client headers, anti-bot protection, and rate limiting.
- `.tailorai/Protocols/Git_Workflow.md`: Branch naming, commit standards, and PR workflow.
- `.tailorai/Protocols/Testing_Standards.md`: Unit, widget, backend API test harness, and security tests.
- `.tailorai/Protocols/Deployment_Protocol.md`: Server deployment script, Apache rules, and Android/iOS build guides.
- `.tailorai/Skills/Flutter_Clean_Arch_Skill.md`: Flutter & BLoC Clean Architecture guidelines (/flutter-arch).
- `.tailorai/Audits/Widget_Decomposition_Audit.md`: Flutter widget decomposition and rebuild audit prompt.

## 2. Application Modules & Architecture Map
### Module 1: Periodic Audio Dhikr (تسبيح المسلم والجدولة الصوتية)
- **Primary Screens:** `code/lib/screens/AzkarScreen/`, `code/lib/screens/scheduleNotificationsScreen/`
- **Logic & Services:** `code/lib/Notifications/Local/NotificationService.dart`, `code/lib/models/ZekerBuildNotifications/`
- **Data Source:** SQLite table `zeker`

### Module 2: Repentance & Istighfar (صلاة التوبة وأدعيتها)
- **Primary Screens:** `code/lib/screens/TawbaScreen/`, `code/lib/screens/RunTawbaScreen/`
- **Logic & Models:** `code/lib/models/TawbaModel.dart`
- **Data Source:** SQLite table `tawba`

### Module 3: Holy Quran & Islamic Radios (صوتيات القرآن الكريم والإذاعات والتفسير)
- **Primary Screens:** `code/lib/screens/AudioPlayerScreen/`, `code/lib/screens/listViewScreen/`
- **Logic & Models:** `code/lib/models/AudioModel/`, `code/lib/helper/connection/http_client.dart`
- **Engine:** `just_audio`, `just_audio_background`
- **Data Source:** Remote JSON APIs via `https://cybeasy.com/Tasbeeh-Al-Muslim/api/v3/`

### Module 4: Islamic Knowledge Library (اقرأ — المكتبة الإسلامية المقروءة)
- **Primary Screens:** `code/lib/screens/listViewScreen/`, `code/lib/screens/ViewScreen/`
- **Logic & Models:** `HadesModel.dart`, `DoaaInQuranModel.dart`, `FirstInIslamHadesModel.dart`, `AzkarElyomeModel.dart`, `IslamEventsModel.dart`
- **Data Source:** SQLite tables `hades`, `doaaquran`, `firstinislam`, `azkar_elyome`, `islam_events`

### Module 5: Calendar Conversion (محول التقويم الهجري والميلادي)
- **Primary Screen:** `code/lib/screens/ConvertDateScreen/View/ConvertDateScreen.dart`
- **Asset / Web Fallback:** `code/assets/convertdate.html`

### Module 6: Theming, Settings & App Support (الإعدادات والدعم والمشاركة)
- **Primary Screens:** `code/lib/screens/ContactusScreen/`, `code/lib/screens/HomeScreen/`
- **State Management:** `code/lib/Bloc/cubit/ThemeAppCubit.dart`
- **Services:** `UpdateNewVer.dart`, `app_review_helper`, `share_plus`

### Module 7: Web Application & Landing Page (صفحة الهبوط وتطبيق الويب)
- **Marketing Landing Page:** `index.html`, `vapp-landing/` (including `vendor/`), `PrivacyPolicy/` at repository root
- **Flutter Web App:** `app/` (compiled with `<base href="/Tasbeeh-Al-Muslim/app/">`)
- **Database Engine:** Wasm SQLite (`sqlite3.wasm`) with IndexedDB persistence

### Module 8: Backend API v3 & Anti-Bot Security Engine (الواجهة الخلفية والحماية)
- **Endpoints:** `api/v3/` (`radio.php`, `mp3Quran_ver2.php`, `mp3Quran_tafser.php`, `about.php`, `support.php`)
- **Security:** `api/v3/security.php` (IP sliding-window rate limiting, bot filter, strict CORS)
- **Configuration:** `api/v3/config.php` and `code/lib/config/AppConfig.dart`
- **Automated Health Harness:** `api/v3/api_test.php`

## 3. Tasks Archive & History
### Governance & Architecture Setup
- [x] `.tailorai/Tasks/feature/2026-09-07_initial_project_setup.md` — Project initialized with AI Agent workspace & architecture documentation
- [x] `.tailorai/Tasks/feature/2026-09-07_ai_agent_guide_in_readme.md` — Documented AI-Assisted Development guide in README.md for GitHub contributors

### Production Deployment & Repository Restructure
- [x] `.tailorai/Tasks/feature/2026-09-14_install_flutter_sdk_and_build_production_web_app.md` — Installed Flutter SDK 3.47.4 / Dart 3.13.3 on server, configured system PATH and permissions, resolved PHP pcntl warning, and executed full production web build into app/ with 10/10 API verification
- [x] `.tailorai/Tasks/refactor/2026-09-14_unify_landing_assets_and_vendor_structure.md` — Unified marketing landing assets by nesting vendor/ inside vapp-landing/vendor/, updating index.html and index2.html, and eliminating root directory clutter
- [x] `.tailorai/Tasks/feature/2026-09-13_repository_restructure_and_api_security_hardening.md` — Clean repository restructuring (root landing, code/, app/, api/v3/), multi-layer anti-bot security engine, environment centralization, and redundant dist removal
- [x] `.tailorai/Tasks/feature/2026-09-12_production_deployment_api_v3_and_server_build.md` — Production server deployment configuration, API v3 migration to cybeasy.com, and automated build script

### Features & UX Enhancements
- [x] `.tailorai/Tasks/frontend/2026-09-15_redesign_landing_page_with_emerald_theme.md` — Created `index-new.html` from scratch with Islamic emerald theme matching `PrivacyPolicy.html`, while restoring original `index.html` with privacy links for comparison
- [x] `.tailorai/Tasks/frontend/2026-09-15_arabic_privacy_policy_and_landing_links.md` — Created comprehensive Arabic Privacy Policy at `PrivacyPolicy.html` with CYBEASY identity, store compliance, and integrated navigation & footer links in `index.html`
- [x] `.tailorai/Tasks/feature/2026-09-15_tawba_counter_stop_mode_dialog.md` — Added interactive bottom sheet dialog on "ابدأ" in Tawba screen allowing users to choose between stopping at target count (100) or continuous uninterrupted mode with live counter updates

### Web & Cross-Platform Support
- [x] `.tailorai/Tasks/feature/2026-09-10_web_periodic_azkar_engine_and_scheduler.md` — Web periodic Azkar audio playback engine, interval & sleep hours scheduling, and cache-backed notification list
- [x] `.tailorai/Tasks/feature/2026-09-14_automated_build_id_and_cache_busting.md` — Automated unique Build ID generation on every server build, script cache busting (`main.dart.js?v=BUILD_ID`), client-side `CacheStorage` auto-purge script, and strict zero-cache `.htaccess` entry-point headers
- [x] `.tailorai/Tasks/feature/2026-09-14_web_html5_notifications_and_audio_unlock.md` — Multi-platform HTML5 desktop notification engine, user gesture listeners to unlock browser AudioContext autoplay restrictions across refreshes, and periodic Azkar notification integration
- [x] `.tailorai/Tasks/feature/2026-09-08_flutter_web_support.md` — Cross-platform Flutter Web & PWA support, Wasm SQLite database engine, web audio streaming, and responsive layout constraints

### Features
- [x] `.tailorai/Tasks/feature/2026-09-18_disable_notification_auto_open_and_home_random_hadith_popup.md` — Disabled fullScreenIntent and removed USE_FULL_SCREEN_INTENT to stop app from hijacking screen on unlock, added random Hadith database query in HadesModel, and built RandomHadithDialog with cold-start home integration

### Bugfixes
- [x] `.tailorai/Tasks/bugfix/2026-09-18_fix_schedule_notifications_stop_hang_and_navigate_home.md` — Fixed infinite loading spinner and app freeze on stop Azkar by converting stop() to async/await with error fallback, passing active BuildContext, and returning safely to Home screen
- [x] `.tailorai/Tasks/bugfix/2026-09-18_fix_azkar_creation_navigate_back_to_home.md` — Fixed Azkar creation screen remaining stuck after generating notifications by standardizing canonical main.dart imports, making AppRoutes.back multi-tiered with home fallback, and implementing direct safe navigation
- [x] `.tailorai/Tasks/bugfix/2026-09-16_fix_google_play_broken_functionality_loading_freeze.md` — Fixed Google Play Broken Functionality policy rejection by removing blocking awaits in main.dart, eliminating 7.16MB asset copy bottleneck in dbSQLiteProvider, adding Android 12+ exported attribute, configuring ProGuard keep rules, and securing notification entrypoints.
- [x] `.tailorai/Tasks/bugfix/2026-09-15_fix_convert_date_screen_responsive_overflow_mobile.md` — Fixed mobile UI rendering in ConvertDateScreen (right overflow on Gregorian header, ellipsis truncation on Year and Month dropdowns via flex 2:4:3 rebalancing, compact inner padding, and FittedBox scale-down protection)
- [x] `.tailorai/Tasks/bugfix/2026-09-15_fix_tawba_audio_android_single_player_crash.md` — Fixed Tawba audio playback crash on Android by removing secondary AudioPlayer instance and adhering to just_audio_background single-instance architecture with strict lifecycle cleanup
- [x] `.tailorai/Tasks/bugfix/2026-09-14_fix_android_startup_permission_and_home_touch_blocking.md` — Fixed Android startup touch blocking via post-frame notification permission request, upgraded HomeScreen buttons to InkWell with BuildContext passing, resolved Android 14 exact alarm PlatformException crash with dynamic exact/inexact fallback, and eliminated ANR loop freezing via sequential await scheduling
- [x] `.tailorai/Tasks/bugfix/2026-09-10_fix_view_screen_duaa_loading_web.md` — Resolved infinite loading spinner in Duaa screen on Web and created native bidirectional Gregorian/Hijri Calendar Converter
- [x] `.tailorai/Tasks/bugfix/2026-09-10_fix_tawba_audio_leak_to_quran_player.md` — Isolated dedicated AudioPlayer in RunTawbaController with lifecycle disposal preventing audio leaks into Quran audio player
- [x] `.tailorai/Tasks/bugfix/2026-09-14_update_app_and_landing_favicons.md` — Replaced default Flutter icons with official high-resolution brand logo (multi-resolution favicon.ico, favicon.png, apple-touch-icon, and PWA icons with cache busting) across web app and landing page
- [x] `.tailorai/Tasks/bugfix/2026-09-10_fix_appcubit_provider_not_found_web.md` — Resolved AppCubit ProviderNotFoundException on Flutter Web by standardizing all Bloc/Cubit imports to canonical `package:tsbeh/...` across main.dart, screens, and controllers

### Upgrades & Migrations
- [x] `.tailorai/Tasks/migration/2026-09-07_flutter_upgrade_fixes.md` — Fixed Flutter 3.38+ upgrade issues (pubspec dependencies, case-sensitive imports, BLoC emit encapsulation, and Android NDK)

## 4. Strict AI Operating Protocol (Always Active)
1. **Context Isolation:** NEVER attempt to read all folders at once. Consult this `PROJECT_MAP.md` first, then request to read ONLY the specific subdirectory relevant to the current task.
2. **Atomic Execution:** Work on ONE single sub-task at a time. Update `[ ]` to `[x]`, document technical changes, and STOP completely to prompt the user.
3. **Task Standardization & Code Sync:** All task files MUST follow the standard 3-section template (Objective, Steps, Implementation Reality). When auditing, update the `## 3. Implementation Reality` section to match current code state.
