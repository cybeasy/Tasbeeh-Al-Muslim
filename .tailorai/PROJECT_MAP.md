# tsbeh (Flutter Tasbeeh Al Muslim) — Knowledge Base Map (Master Index)

## 1. Core Foundations (Mandatory Context)
- `.tailorai/Agent.md`: Core AI rules, identity, task creation protocols, and execution mandates.
- `.tailorai/Architecture/Technical_Architecture.md`: System architecture, tech stack layout, and folder structure.
- `.tailorai/Architecture/PRD.md`: Product requirements, user roles, and module scope.
- `.tailorai/Architecture/Visual_Identity.md`: UI/UX design tokens, color palette, typography, and styling rules.
- `.tailorai/Protocols/API_Contracts.md`: Standardized API responses, HTTP codes, and error formatting.
- `.tailorai/Protocols/Security_Protocol.md`: Authentication, authorization, and data security.
- `.tailorai/Protocols/Git_Workflow.md`: Branch naming, commit standards, and PR workflow.
- `.tailorai/Protocols/Testing_Standards.md`: Unit & integration testing guidelines.
- `.tailorai/Protocols/Deployment_Protocol.md`: Deployment procedures and CI/CD configuration.
- `.tailorai/Skills/Flutter_Clean_Arch_Skill.md`: Flutter & BLoC Clean Architecture guidelines (/flutter-arch).
- `.tailorai/Audits/Widget_Decomposition_Audit.md`: Flutter widget decomposition and rebuild audit prompt.

## 2. Application Modules & Architecture Map
### Module 1: Periodic Audio Dhikr (تسبيح المسلم والجدولة الصوتية)
- **Primary Screens:** `lib/screens/AzkarScreen/`, `lib/screens/scheduleNotificationsScreen/`
- **Logic & Services:** `lib/Notifications/Local/NotificationService.dart`, `lib/models/ZekerBuildNotifications/`
- **Data Source:** SQLite table `zeker`

### Module 2: Repentance & Istighfar (صلاة التوبة وأدعيتها)
- **Primary Screens:** `lib/screens/TawbaScreen/`, `lib/screens/RunTawbaScreen/`
- **Logic & Models:** `lib/models/TawbaModel.dart`
- **Data Source:** SQLite table `tawba`

### Module 3: Holy Quran & Islamic Radios (صوتيات القرآن الكريم والإذاعات والتفسير)
- **Primary Screens:** `lib/screens/AudioPlayerScreen/`, `lib/screens/listViewScreen/`
- **Logic & Models:** `lib/models/AudioModel/`, `lib/helper/connection/http_client.dart`
- **Engine:** `just_audio`, `just_audio_background`
- **Data Source:** Remote JSON APIs via `api.4topapps.com`

### Module 4: Islamic Knowledge Library (اقرأ — المكتبة الإسلامية المقروءة)
- **Primary Screens:** `lib/screens/listViewScreen/`, `lib/screens/ViewScreen/`
- **Logic & Models:** `HadesModel.dart`, `DoaaInQuranModel.dart`, `FirstInIslamHadesModel.dart`, `AzkarElyomeModel.dart`, `IslamEventsModel.dart`
- **Data Source:** SQLite tables `hades`, `doaaquran`, `firstinislam`, `azkar_elyome`, `islam_events`

### Module 5: Calendar Conversion (محول التقويم الهجري والميلادي)
- **Primary Screen:** `lib/screens/WebScreen/`
- **Asset:** `assets/convertdate.html` loaded via `webview_flutter`

### Module 6: Theming, Settings & App Support (الإعدادات والدعم والمشاركة)
- **Primary Screens:** `lib/screens/ContactusScreen/`, `lib/screens/HomeScreen/`
- **State Management:** `lib/Bloc/cubit/ThemeAppCubit.dart`
- **Services:** `UpdateNewVer.dart`, `app_review_helper`, `share_plus`

## 3. Tasks Archive & History
### Governance & Setup
- [x] `.tailorai/Tasks/feature/2026-09-07_initial_project_setup.md` — Project initialized with AI Agent workspace & architecture documentation
- [x] `.tailorai/Tasks/feature/2026-09-07_ai_agent_guide_in_readme.md` — Documented AI-Assisted Development guide in README.md for GitHub contributors

### Upgrades & Migrations
- [x] `.tailorai/Tasks/migration/2026-09-07_flutter_upgrade_fixes.md` — Fixed Flutter 3.38+ upgrade issues (pubspec dependencies, case-sensitive imports, BLoC emit encapsulation, and Android NDK)

## 4. Strict AI Operating Protocol (Always Active)
1. **Context Isolation:** NEVER attempt to read all folders at once. Consult this `PROJECT_MAP.md` first, then request to read ONLY the specific subdirectory relevant to the current task.
2. **Atomic Execution:** Work on ONE single sub-task at a time. Update `[ ]` to `[x]`, document technical changes, and STOP completely to prompt the user.
3. **Task Standardization & Code Sync:** All task files MUST follow the standard 3-section template (Objective, Steps, Implementation Reality). When auditing, update the `## 3. Implementation Reality` section to match current code state.
