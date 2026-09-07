# Product Requirements Document (PRD) — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Executive Summary
**Tasbeeh Al Muslim (تسبيح المسلم)** is an Islamic daily companion mobile application designed to help Muslims remember Allah throughout their day. The app provides automated, customizable periodic audio dhikr reminders, step-by-step interactive repentance (Tawba) supplications, offline-first authentic Islamic reference texts (Quranic Duas, Hadiths, Daily Athkar, Historical Milestones), and high-quality online streaming of the Holy Quran recited by over 64 renowned reciters with Tafseer and Islamic radio stations.

## 2. Target Users & Roles
| Role | Description | Key Permissions & Usage |
|------|-------------|-------------------------|
| General Muslim User | Everyday mobile user seeking consistent audio reminders and daily Islamic readings. | Full offline access to local Athkar, customization of reminder intervals, listening to Quran recitations, and participating in Tawba prayers. |
| Content Administrator / Developer | Maintainer managing remote audio catalogs and push notification campaigns. | Publishing remote push notifications via Firebase, updating remote audio streams, and releasing app store builds. |

## 3. Core Modules & Scope
| # | Module | Status | Description |
|---|--------|--------|-------------|
| 1 | **Periodic Audio Dhikr (تسبيح المسلم)** | Production Ready | Configurable periodic audio notifications that play selected Dhikr at defined intervals (e.g. every 15, 30, 60 minutes) with quiet/sleep hour controls to avoid nighttime disturbance. |
| 2 | **Repentance & Istighfar (صلاة التوبة)** | Production Ready | Interactive screen guiding the user through the Salat Al-Tawba and authentic supplications, equipped with a digital counter, audio playback, and Quran/Sunnah references. |
| 3 | **Holy Quran Audio & Tafseer (صوتيات القرآن والتفسير)** | Production Ready | Online streaming catalog supporting 64+ Quranic reciters, Surah selection, full audio playback controls (seek, pause, resume), background execution with lock-screen notification controls, and audio Tafseer. |
| 4 | **Islamic Radios (إذاعات إسلامية)** | Production Ready | Live streaming Islamic radio channels for continuous broadcasting. |
| 5 | **Islamic Knowledge Library (اقرأ — المكتبة الإسلامية)** | Production Ready | High-speed offline access to authenticated SQLite database tables: Hadiths of the Prophet, Duas in the Quran, Historic Firsts in Islam, Daily Athkar, and Islamic Events. |
| 6 | **Calendar Converter (محول التقويم)** | Production Ready | Integrated offline tool to convert dates bi-directionally between the Hijri and Gregorian calendars. |
| 7 | **Settings, Dark Mode & App Support (الإعدادات والتواصل)** | Production Ready | Dark/Light mode theme switching, in-app store reviews, app update alerts, social sharing with Hadith rewards, and developer support via email/phone/WhatsApp. |

## 4. User Journeys

### Journey 1: Configuring & Running Periodic Audio Dhikr
1. User opens the application and taps **تسبيح المسلم**.
2. If scheduler is inactive, user selects desired audio athkar from the list, sets repetition frequency and interval duration, and defines sleep/silent hours.
3. User taps "Start / تفعيل التنبيهات". The app creates background local notification channels with custom audio files.
4. User receives scheduled audio notifications even when the device is locked or the app is closed.
5. User can view next scheduled reminder times or pause reminders at any time from `scheduleNotificationsScreen`.

### Journey 2: Listening to the Holy Quran & Tafseer
1. User navigates to **القرآن الكريم (صوت)** from the home screen.
2. The app fetches the reciter catalog from the remote API and displays the reciter list.
3. User selects a reciter, browses the Surah index, and taps a Surah to play.
4. The audio player screen opens, streams the audio via `just_audio`, and shows metadata in system notification with playback controls.
5. User can navigate between surahs, adjust playback positions, or minimize the app while playback continues uninterrupted.

### Journey 3: Engaging in Tawba & Istighfar
1. User selects **التوبة** from the home screen.
2. User browses Tawba items and selects an adhkar or prayer guide.
3. User enters `RunTawbaScreen`, sees the target count, reads the authentic reference text, and taps the digital counter.
4. An optional audio recites the supplication to aid pronunciation and focus.
5. Upon reaching the count, the app confirms completion and congratulates the user.

## 5. Capacity & Offline Capabilities
- **100% Offline Core:** Audio dhikr files, Tawba data, and all Islamic reading libraries (Hadiths, Duas, Events) are stored locally in the 7.1 MB SQLite database and asset bundle. No internet connection is required for core functionality.
- **Online Enhancements:** Internet connectivity is strictly required for online Quran streaming, live Islamic radios, and Firebase push notifications.
- **Storage Footprint:** Compact baseline installation (< 50MB) with zero unnecessary caching bloat.

## 6. Non-Functional Requirements
- **Battery Optimization:** Local notifications leverage native Android and iOS alarms/channels with negligible battery consumption.
- **Audio Reliability:** Continuous background streaming with auto-recovery on network disruption and adherence to OS audio focus rules (`audio_session`).
- **Typography & Readability:** Built with Google Fonts `Cairo` optimized for Arabic ligature rendering across both dark and light modes.
- **Platform Compliance:** Fully compliant with Android 14/15 notification permissions (`POST_NOTIFICATIONS`) and iOS background audio entitlements.
