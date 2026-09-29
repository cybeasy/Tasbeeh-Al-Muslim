# Task: Production Release v1.0.21+25 and Merge to Main
- **Date:** 2026-09-29
- **Category:** release
- **Target Files:**
  - `code/pubspec.yaml`
  - `.tailorai/ACTIVE_TASKS.md`
  - `.tailorai/PROJECT_MAP.md`

## 1. Objective
Release production version `1.0.21+25` of Tasbeeh Al Muslim:
- Verify application version in `code/pubspec.yaml` (`1.0.21+25`).
- Merge all stable feature, bugfix, and architecture commits from `Development` branch into `main`.
- Tag the release commit on `main` as `v1.0.21+25`.
- Push `main` and release tags to remote `origin`.
- Return to `Development` branch for ongoing development.

## 2. Atomic Execution Steps
- [x] [Step 1: Verify version configuration and archive completed tasks in `PROJECT_MAP.md`]
- [x] [Step 2: Checkout `main` and merge `Development` branch]
- [x] [Step 3: Create annotated release tag `v1.0.21+25`]
- [x] [Step 4: Push `main` and tag to `origin`, then switch back to `Development`]

## 3. Implementation Reality & Audit Log
- **Step 1 (Completed 2026-09-29):**
  - Confirmed `code/pubspec.yaml` has production version `1.0.21+25`.
  - Archived completed bugfix task `2026-09-19_fix_tawba_screen_buttons_touch_and_navigation.md` into `.tailorai/PROJECT_MAP.md` under Bugfixes.
  - Initialized release task in `.tailorai/ACTIVE_TASKS.md`.
- **Step 2 (Completed 2026-09-29):**
  - Switched to `main` branch.
  - Merged `Development` branch into `main` cleanly with merge commit `87bbbd5` (`Merge branch 'Development' into main (Release v1.0.21+25)`).
- **Step 3 (Completed 2026-09-29):**
  - Created annotated git release tag `v1.0.21+25` pointing to the release merge commit.
- **Step 4 (Completed 2026-09-29):**
  - Configured git remote origin to authenticated SSH (`git@github.com:cybeasy/Tasbeeh-Al-Muslim.git`).
  - Pushed `main` branch (`87bbbd5`), `Development` branch (`8c2dbc3`), and release tag `v1.0.21+25` to `origin`.
  - Returned working tree to `Development` branch.
