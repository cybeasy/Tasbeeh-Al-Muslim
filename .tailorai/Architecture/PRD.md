# Product Requirements Document (PRD) — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Executive Summary
**Tasbeeh Al Muslim (تسبيح المسلم)** is an Islamic daily companion cross-platform application (Android, iOS, Web/PWA, and Marketing Landing Page) designed to help Muslims remember Allah throughout their day. The platform provides automated, customizable periodic audio dhikr reminders, step-by-step interactive repentance (Tawba) supplications, offline-first authentic Islamic reference texts (Quranic Duas, Hadiths, Daily Athkar, Historical Milestones), and high-quality online streaming of the Holy Quran recited by over 241 renowned reciters with Tafseer and 177 live Islamic radio stations, backed by an optimized, anti-bot-hardened PHP API v3 backend.

## 2. Target Users & Roles
| Role | Description | Key Permissions & Usage |
|------|-------------|-------------------------|
| General Muslim User | Everyday mobile or web user seeking consistent audio reminders, daily Islamic readings, and Quran streaming. | Full offline access to local Athkar, customization of reminder intervals, listening to Quran recitations, and participating in Tawba prayers on Android, iOS, or Web. |
| Web Visitor | Desktop or mobile browser user visiting the marketing landing page (`cybeasy.com/Tasbeeh-Al-Muslim/`). | Browses features, reviews privacy policy, downloads mobile apps via Google Play / App Store, or launches the Web App directly. |
| Maintainer / Developer | Engineer managing remote audio catalogs, API endpoints, web builds, and push campaigns. | Updating API endpoints, compiling Flutter Web releases, managing anti-bot rules, and publishing mobile builds. |

## 3. Core Modules & Scope
| # | Module | Status | Description |
|---|--------|--------|-------------|
| 1 | **Periodic Audio Dhikr (تسبيح المسلم)** | Production Ready | Configurable periodic audio notifications that play selected Dhikr at defined intervals (e.g. every 15, 30, 60 minutes) with quiet/sleep hour controls to avoid nighttime disturbance. |
| 2 | **Repentance & Istighfar (صلاة التوبة)** | Production Ready | Interactive screen guiding the user through the Salat Al-Tawba and authentic supplications, equipped with a digital counter, audio playback, and Quran/Sunnah references. |
| 3 | **Holy Quran Audio & Tafseer (صوتيات القرآن والتفسير)** | Production Ready | Online streaming catalog supporting 241+ Quranic reciters, Surah selection, full audio playback controls (seek, pause, resume), background execution with lock-screen notification controls, and audio Tafseer commentary. |
| 4 | **Islamic Radios (إذاعات إسلامية)** | Production Ready | Live streaming for 177+ Islamic radio channels broadcasting Quran recitations, fatwas, and lectures. |
| 5 | **Islamic Knowledge Library (اقرأ — المكتبة الإسلامية)** | Production Ready | High-speed offline access to authenticated SQLite database tables: Hadiths of the Prophet, Duas in the Quran, Historic Firsts in Islam, Daily Athkar, and Islamic Events. |
| 6 | **Calendar Converter (محول التقويم)** | Production Ready | Integrated offline tool to convert dates bi-directionally between the Hijri and Gregorian calendars. |
| 7 | **Settings, Theming & Support (الإعدادات والدعم)** | Production Ready | Dark/Light mode theme switching, in-app store reviews, app update alerts, social sharing with Hadith rewards, and developer support via email/phone/WhatsApp. |
| 8 | **Web App & Landing Page (صفحة الهبوط وتطبيق الويب)** | Production Ready | Standalone responsive marketing landing page (`index.html`) at root and compiled Flutter Web SPA (`/app/`) with Wasm SQLite relational store. |
| 9 | **Backend API v3 & Anti-Bot Protection (الواجهة الخلفية والحماية)** | Production Ready | Lightweight PHP 8.x backend (`/api/v3/`) protected by sliding-window rate limiting, bad bot scraper filtering, strict CORS, and client header identity verification. |

## 4. User Journeys

### Journey 1: Configuring & Running Periodic Audio Dhikr
1. User opens the application and taps **تسبيح المسلم**.
2. If scheduler is inactive, user selects desired audio athkar from the list, sets repetition frequency and interval duration, and defines sleep/silent hours.
3. User taps "Start / تفعيل التنبيهات". The app creates background local notification channels with custom audio files.
4. User receives scheduled audio notifications even when the device is locked or the app is closed.
5. User can view next scheduled reminder times or pause reminders at any time from `scheduleNotificationsScreen`.

### Journey 2: Listening to the Holy Quran & Tafseer
1. User navigates to **القرآن الكريم (صوت)** from the home screen.
2. The app fetches the reciter catalog from the remote API (`api/v3/mp3Quran_ver2.php`) and displays the reciter list.
3. User selects a reciter, browses the Surah index, and taps a Surah to play.
4. The audio player screen opens, streams the audio via `just_audio`, and shows metadata in system notification with playback controls.
5. User can navigate between surahs, adjust playback positions, or minimize the app while playback continues uninterrupted.

### Journey 3: Engaging in Tawba & Istighfar
1. User selects **التوبة** from the home screen.
2. User browses Tawba items and selects an adhkar or prayer guide.
3. User enters `RunTawbaScreen`, sees the target count, reads the authentic reference text, and taps the digital counter.
4. An optional audio recites the supplication to aid pronunciation and focus.
5. Upon reaching the count, the app confirms completion and congratulates the user.

### Journey 4: Accessing via Web & Landing Page
1. Visitor navigates to `https://cybeasy.com/Tasbeeh-Al-Muslim/`.
2. Visitor sees the responsive marketing page, feature overview, and store download links.
3. Visitor clicks "فتح تطبيق الويب" (Open Web App) to launch the Flutter Web SPA at `https://cybeasy.com/Tasbeeh-Al-Muslim/app/`.
4. Flutter Web SPA loads instantly with SQLite Wasm (`sqlite3.wasm`), Cairo typography, and connects seamlessly to `/api/v3/`.

## 5. Capacity & Offline Capabilities
- **100% Offline Core:** Audio dhikr files, Tawba data, and all Islamic reading libraries (Hadiths, Duas, Events) are stored locally in the 7.1 MB SQLite database and asset bundle. No internet connection is required for core functionality.
- **Online Enhancements:** Internet connectivity is strictly required for online Quran streaming, live Islamic radios, and Firebase push notifications.
- **Cross-Platform Storage:** Native SQLite on Android/iOS; WebAssembly SQLite (`sqflite_common_ffi_web` + `sqlite3.wasm`) on Web.

## 6. Non-Functional Requirements
- **Battery Optimization:** Local notifications leverage native Android and iOS alarms/channels with negligible battery consumption.
- **Audio Reliability:** Continuous background streaming with auto-recovery on network disruption and adherence to OS audio focus rules (`audio_session`).
- **Security & Anti-Abuse:** Backend endpoints protected against automated scrapers, flood attacks, and unauthorized origin framing.
- **Platform Compliance:** Fully compliant with Android 14/15 notification permissions (`POST_NOTIFICATIONS`), iOS background audio entitlements, and modern web PWA standards.
