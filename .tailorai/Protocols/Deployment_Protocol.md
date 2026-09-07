# Deployment Protocol & CI/CD — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Deployment Environments & Build Commands
- **Development (Local):** Run locally on emulator or connected device:
  ```bash
  fvm flutter run
  ```
- **Staging / QA Testing:**
  - Android: Generate release APK for manual distribution / Google Play Internal Testing:
    ```bash
    fvm flutter build apk --release
    ```
  - iOS: Generate build for Apple TestFlight:
    ```bash
    fvm flutter build ipa --release
    ```
- **Production Deployment:**
  - Google Play Store:
    ```bash
    fvm flutter build appbundle --release
    ```
  - Apple App Store:
    ```bash
    fvm flutter build ipa --release
    ```

## 2. Pre-Deployment Checklist
- [ ] Automated tests pass with zero failures (`fvm flutter test`).
- [ ] Static type checking and linting pass with zero errors (`fvm flutter analyze`).
- [ ] Version and build number updated in `pubspec.yaml` (`version: X.Y.Z+build`).
- [ ] Keystore and signing keys properly configured (`key.jks` / Google Play Signing / Apple Distribution Certificates).
- [ ] Verify audio assets and notification sounds in native directories (`android/app/src/main/res/raw/` and iOS Runner bundle).
- [ ] Verify `firebase_options.dart` points to active production project.

## 3. Post-Deployment Verification
- Perform smoke tests on core flows:
  - Periodic audio dhikr alarm triggering.
  - Quran audio streaming and background playback notification controls.
  - Tawba counter and SQLite local queries.
- Check Firebase Crashlytics dashboard for immediate crash reports after release rollout.
