# Task: Qibla Direction Compass & Prayer Times with Adhan Notifications
- **Date:** 2026-09-29
- **Category:** feature
- **Target Files:**
  - `code/lib/screens/PrayerTimesScreen/View/PrayerTimesScreen.dart`
  - `code/lib/screens/PrayerTimesScreen/Controller/PrayerTimesController.dart`
  - `code/lib/screens/QiblaScreen/View/QiblaScreen.dart`
  - `code/lib/screens/QiblaScreen/Controller/QiblaController.dart`
  - `code/lib/services/prayer/PrayerCalculationService.dart`
  - `code/lib/services/prayer/LocationService.dart`
  - `code/lib/services/prayer/QiblaCompassService.dart`
  - `code/lib/Notifications/Local/NotificationService.dart`
  - `code/lib/screens/HomeScreen/View/HomeScreen.dart`
  - `code/pubspec.yaml`

## 1. Objective
Build an accurate, offline-capable Islamic Prayer Times and Qibla Compass module (مواقيت الصلاة وتحديد اتجاه القبلة):
1. **Accurate Prayer Times Engine (مواقيت الصلاة الخمس والشروق):**
   - Pure offline astronomical calculations via standard algorithms (e.g. `adhan` Dart package).
   - Support multiple calculation authorities (Umm al-Qura Makkah, Egyptian General Authority of Survey, Muslim World League, ISNA, Karachi, etc.).
   - Support juristic calculation methods for Asr (Shafi'i/Hanbali/Maliki standard vs Hanafi).
   - Provide countdown timer to the upcoming prayer with dynamic visual highlight of the active prayer window.
   - Monthly prayer times calendar view with Hijri and Gregorian dates.
2. **Adhan Audio & Prayer Reminders (تنبيهات الأذان والتذكير):**
   - Individual customizable notification settings per prayer (Full Adhan audio, Takbeer audio, standard tone, vibration, or silent).
   - Optional pre-prayer reminder (e.g. 15 minutes before Adhan) to prepare for prayer.
   - Reliable background scheduling integrated with `flutter_local_notifications` exact alarms.
3. **Qibla Direction Compass (بوصلة تحديد اتجاه القبلة):**
   - Real-time digital compass utilizing device magnetometer (`flutter_compass` / sensors).
   - Precise spherical trigonometry calculating the angle to the Holy Kaaba (21.422487° N, 39.826206° E) relative to True North based on current coordinates.
   - Fluid magnetic needle animation with smooth low-pass filtering / dampening to prevent jitter.
   - Sensory feedback (haptic vibration and visual glow) when the device points directly towards the Qibla (tolerance ±2°).
   - Sensor calibration guide and map-based fallback for devices without hardware magnetometers.
4. **Location Engine & Privacy-Respecting Fallback:**
   - Automatic geolocation retrieval via GPS (`geolocator`).
   - Offline manual country/city picker fallback allowing users to use prayer times without granting location permissions.
   - Encrypted local cache of coordinates and city name to avoid repeated GPS battery drain.
5. **Home Screen Integration:**
   - Elegant widget / card on `HomeScreen` displaying today's prayer times, current prayer, and countdown to next prayer.

## 2. Atomic Execution Steps
- [ ] [Step 1: Dependencies & Engine — Add `adhan`, `geolocator`, and `flutter_compass` to `code/pubspec.yaml` and configure Android/iOS permissions]
- [ ] [Step 2: Service Layer — Implement `LocationService` (GPS + manual city database) and `PrayerCalculationService` (calculation methods, juristic rules, offline caching)]
- [ ] [Step 3: Qibla Service — Implement `QiblaCompassService` with true north heading calculations, sensor dampening filter, and haptic feedback]
- [ ] [Step 4: UI Implementation — Build `PrayerTimesScreen` with countdown cards, monthly schedule table, and prayer calculation settings]
- [ ] [Step 5: UI Implementation — Build `QiblaScreen` with custom Islamic compass dial, Kaaba indicator, calibration dialog, and alignment haptic feedback]
- [ ] [Step 6: Notification Scheduling — Extend `NotificationService` to schedule daily Adhan audio alerts and pre-prayer reminders]
- [ ] [Step 7: HomeScreen Integration — Add compact next-prayer banner and quick Qibla button to `HomeScreen`]
- [ ] [Step 8: Verification & Testing — Validate calculation accuracy against official tables, verify compass responsiveness, test exact alarm delivery, and check `flutter analyze`]

## 3. Implementation Reality & Audit Log
*(Future implementation log will be recorded here)*
