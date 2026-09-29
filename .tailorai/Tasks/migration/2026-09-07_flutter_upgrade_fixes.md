# Task: Fix Flutter & Dart Upgrade Issues
- **Date:** 2026-09-07
- **Category:** migration
- **Target Files:**
  - `pubspec.yaml`
  - `lib/screens/AzkarScreen/Controller/AzkarController.dart`
  - `lib/screens/HomeScreen/Controller/HomeController.dart`
  - `lib/screens/SplashScreen/Controller/SplashController.dart`
  - `lib/screens/TawbaScreen/View/TawbaScreen.dart`
  - `lib/widget/CustomSliverAppBarDelegate.dart`
  - `lib/screens/WebScreen/Controller/WebController.dart`
  - `lib/screens/listViewScreen/Controller/listViewController.dart`
  - `lib/Bloc/AppCubit.dart`
  - `lib/screens/scheduleNotificationsScreen/Controller/scheduleNotificationsController.dart`
  - `android/app/build.gradle.kts`

## 1. Objective
Fix compilation errors, dependency issues, and analyzer warnings caused by upgrading Flutter (3.38.3 / Dart 3.10.1):
1. Fix `pubspec.yaml` indentation for `flutter_lints`.
2. Fix 7 case-sensitive import paths (`AppRoutes.dart` and `HadesModel.dart`) causing 13 fatal compilation errors.
3. Encapsulate BLoC `emit` call properly in `AppCubit` to resolve protected member violations.
4. Align Android NDK version to `flutter.ndkVersion`.

## 2. Atomic Execution Steps
- [x] Step 1: Fix `pubspec.yaml` indentation for `flutter_lints` and run `flutter pub get`.
- [x] Step 2: Fix case-sensitive file imports in 7 files (`AppRoutes.dart` & `HadesModel.dart`).
- [x] Step 3: Fix BLoC `emit` protected member usage in `AppCubit` and `scheduleNotificationsController`.
- [x] Step 4: Fix Android NDK configuration in `android/app/build.gradle.kts` (`flutter.ndkVersion`).
- [x] Step 5: Verification via `flutter analyze` ensuring 0 compilation errors.

## 3. Implementation Reality & Audit Log
- **Step 1 Completed:**
  - Repositioned `flutter_lints: ^5.0.0` directly under `dev_dependencies:` in `pubspec.yaml`.
  - Ran `flutter pub get`, successfully fetching `flutter_lints 5.0.0` and `lints 5.1.1`.
  - Resolved `include_file_not_found` warning for `package:flutter_lints/flutter.yaml`.
- **Step 2 Completed:**
  - Updated case-sensitive imports in 7 files:
    - Replaced `package:tsbeh/appRoutes.dart` with `package:tsbeh/AppRoutes.dart` in:
      - `lib/screens/AzkarScreen/Controller/AzkarController.dart`
      - `lib/screens/HomeScreen/Controller/HomeController.dart`
      - `lib/screens/SplashScreen/Controller/SplashController.dart`
      - `lib/screens/TawbaScreen/View/TawbaScreen.dart`
      - `lib/widget/CustomSliverAppBarDelegate.dart`
    - Replaced `package:tsbeh/models/hadesModel.dart` with `package:tsbeh/models/HadesModel.dart` in:
      - `lib/screens/WebScreen/Controller/WebController.dart`
      - `lib/screens/listViewScreen/Controller/listViewController.dart`
  - Re-analyzed codebase: **0 errors found** (all 13 compilation errors resolved!).
- **Step 3 Completed:**
  - Added `void resetToInitial() => emit(InitialAppStates());` inside `AppCubit`.
  - Replaced direct `cubit.emit(...)` call in `scheduleNotificationsController.dart` with `cubit.resetToInitial()`.
  - Removed unused import `dart:convert` in `AppCubit.dart`.
  - Resolved `invalid_use_of_protected_member` and `invalid_use_of_visible_for_testing_member`.
- **Step 4 Completed:**
  - In `android/app/build.gradle.kts`, replaced hardcoded `ndkVersion = "27.0.12077973"` with `ndkVersion = flutter.ndkVersion`.
- **Step 5 Completed:**
  - Full project verification with `flutter analyze`: verified **0 compilation errors**.
