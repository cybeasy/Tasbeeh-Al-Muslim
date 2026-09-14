# Task: Fix AppCubit ProviderNotFoundException on Flutter Web
- **Date:** 2026-09-10
- **Category:** bugfix
- **Target Files:**
  - `lib/main.dart`
  - `lib/screens/HomeScreen/View/HomeScreen.dart`
  - `lib/screens/AzkarScreen/View/AzkarScreen.dart`
  - `lib/screens/AzkarScreen/Controller/AzkarController.dart`
  - `lib/screens/scheduleNotificationsScreen/View/scheduleNotificationsScreen.dart`
  - `lib/screens/scheduleNotificationsScreen/Controller/scheduleNotificationsController.dart`
  - `lib/screens/HomeScreen/Controller/HomeController.dart`
  - `lib/screens/ContactusScreen/ContactusScreen.dart`
  - `lib/screens/ViewScreen/Controller/ViewController.dart`
  - `lib/widget/CustomSliverAppBarDelegate.dart`

## 1. Objective
Resolve the red screen error on Flutter Web (`Error: Could not find the correct Provider<AppCubit> above this BlocConsumer<AppCubit, AppStates> Widget`) caused by URI mismatch between relative imports (`import 'Bloc/AppCubit.dart'` / `import '../../../Bloc/AppCubit.dart'`) and package imports (`import 'package:tsbeh/Bloc/AppCubit.dart'`). Under Dart Development Compiler (DDC / Flutter Web debug mode), mismatched URI imports create distinct runtime Type keys, preventing `Provider.of<AppCubit>` from locating the provided instance in the widget tree. Standardize all Bloc and Cubit imports across the codebase to canonical `package:tsbeh/...` imports.

## 2. Atomic Execution Steps
- [x] **Step 1: Canonicalize Bloc Imports in `lib/main.dart`**
  - Replace relative imports (`Bloc/AppCubit.dart`, `Bloc/cubit/ThemeAppCubit.dart`, `Bloc/cubit/ThemeAppStates.dart`, `Notifications/Local/...`, `Theme/AppTheme.dart`, `firebase_options.dart`, `helper/...`) with canonical `package:tsbeh/...` imports.
- [x] **Step 2: Canonicalize Bloc Imports Across All Screens & Controllers**
  - Update `HomeScreen.dart`, `AzkarScreen.dart`, `AzkarController.dart`, `scheduleNotificationsScreen.dart`, `scheduleNotificationsController.dart`, `HomeController.dart`, `ContactusScreen.dart`, `ViewController.dart`, and `CustomSliverAppBarDelegate.dart` to use `package:tsbeh/Bloc/...` consistently.
- [x] **Step 3: Verification & Static Analysis**
  - Run `flutter analyze` to ensure 0 import or type errors.
  - Rebuild web artifacts (`flutter build web --no-tree-shake-icons`) and verify execution in headless Chrome / dev server.

## 3. Implementation Reality & Audit Log
- **2026-09-10 (Step 1 Completed):** Canonicalized all relative imports in `lib/main.dart` to standard `package:tsbeh/...` imports (`AppCubit`, `ThemeAppCubit`, `ThemeAppStates`, `NotificationService`, `AppTheme`, `firebase_options`, `CashLocal`, and `dbSQLiteProvider`). Verified with `git diff lib/main.dart`.
- **2026-09-10 (Step 2 Completed):** Replaced all relative `../../../Bloc/` and `../Bloc/` imports across 9 screen and controller files with canonical `package:tsbeh/Bloc/...` imports (`HomeScreen.dart`, `AzkarScreen.dart`, `AzkarController.dart`, `scheduleNotificationsScreen.dart`, `scheduleNotificationsController.dart`, `HomeController.dart`, `ContactusScreen.dart`, `ViewController.dart`, and `CustomSliverAppBarDelegate.dart`). Verified 0 relative Bloc imports remain in the codebase.
- **2026-09-10 (Step 3 Completed):** Ran `flutter analyze` with zero compile errors, successfully compiled web bundle with `flutter build web --no-tree-shake-icons` (exit code 0), and verified in live headless Chrome CDP session. Confirmed `BlocConsumer called` with `error found: False` and complete disappearance of the red screen error.
