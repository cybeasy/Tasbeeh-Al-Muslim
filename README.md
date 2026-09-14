# Flutter Tasbeeh Al Muslim (تسبيح المسلم)

<p align="left">
  <a href="https://play.google.com/store/apps/details?id=com.tsbeh" target="_blank">
    <img alt="Get it on Google Play" src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" height="38"/>
  </a>
  <a href="https://apps.apple.com/us/app/%D8%AA%D8%B3%D8%A8%D9%8A%D8%AD-%D8%A7%D9%84%D9%85%D8%B3%D9%84%D9%85/id739018955" target="_blank">
    <img alt="Get it on Apple Store" src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/Download_on_the_App.svg" height="38"/>
  </a>
  <a href="https://cybeasy.com/Tasbeeh-Al-Muslim/app" target="_blank">
    <img alt="Live Web App" src="https://img.shields.io/badge/Web_Live-cybeasy.com%2FTasbeeh--Al--Muslim%2Fapp-2ea44f?style=for-the-badge&logo=googlechrome&logoColor=white" height="38"/>
  </a>
  <a href="https://cybeasy.com/Tasbeeh-Al-Muslim/" target="_blank">
    <img alt="Landing Page" src="https://img.shields.io/badge/Website-cybeasy.com%2FTasbeeh--Al--Muslim-007acc?style=for-the-badge&logo=internetexplorer&logoColor=white" height="38"/>
  </a>
</p>

#### Overview of the App

Tasbeeh Al Muslim that helps you to remember allah Almighty, as it contains a set of audio dhikr, which is played every specific period of time based on your desire to remember

- A variety of different audio dhikrs have been added
- Stop dhikr at a certain time
- The Holy Qur’an has been added with the voice of 241 reciters and 177 radio stations
- Verses of supplication were added in the Holy Quran
- The first section has been added
- Remembrances of the day has been added
- All Islamic events have been added according to the Hijri month
- Favorites have been added
- Converting from the Hijri date to the Gregorian date and vice versa
- Web & PWA cross-platform version support with offline Wasm SQLite

---

## 📸 ScreenShots

<p align="center">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/1.png" width="350" alt="Screenshot 1">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/2.png" width="350" alt="Screenshot 2">
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/3.png" width="350" alt="Screenshot 3">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/4.png" width="350" alt="Screenshot 4">
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/5.png" width="350" alt="Screenshot 5">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/6.png" width="350" alt="Screenshot 6">
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/7.png" width="350" alt="Screenshot 7">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/8.png" width="350" alt="Screenshot 8">
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/9.png" width="350" alt="Screenshot 9">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/10.png" width="350" alt="Screenshot 10">
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/cybeasy/Tasbeeh-Al-Muslim/main/screenShots/11.png" width="350" alt="Screenshot 11">
</p>

---

## ✨ Requirements

- Any Operating System (ie. MacOS X, Linux, Windows)
- Any IDE with Flutter SDK installed (ie. IntelliJ, Android Studio, VSCode etc)
- A little knowledge of Dart and Flutter

---

## 🏛️ Project Architecture

```text
Tasbeeh-Al-Muslim/ (Repository Root & Web Root)
├── index.html                # Marketing Landing Page (with Web App CTAs)
├── index2.html               # Secondary landing page variant
├── vapp-landing/             # Landing page styles, scripts, visual assets & vendor/
│   └── vendor/               # Third-party libraries
├── PrivacyPolicy/            # Privacy Policy document & web pages
├── app/                      # Compiled Flutter Web release (<base href="/Tasbeeh-Al-Muslim/app/">)
├── code/                     # Complete Flutter Mobile & Web Source Code
│   ├── lib/                  # BLoC Cubits, Screens, Models, and Services
│   │   ├── config/AppConfig.dart # Centralized domain & endpoint resolver
│   │   └── helper/connection/    # HttpClient with anti-bot headers
│   ├── android/              # Android native shell
│   ├── ios/                  # iOS native shell
│   ├── web/                  # Web shell with sqlite3.wasm
│   ├── .env                  # Environment variables (APP_DOMAIN, API_BASE_PATH)
│   ├── .htaccess             # Source code security (Require all denied)
│   └── pubspec.yaml          # Dependencies & assets
├── api/                      # PHP Backend API v3 with Anti-Bot Engine
│   └── v3/
│       ├── security.php      # IP Rate Limiting & Bot Filtering Engine
│       ├── config.php        # Centralized Domain, CORS & Limit Config
│       ├── constants.php     # API definitions
│       ├── base.php          # Dynamic base URL calculation
│       ├── radio.php         # 177 Islamic Radio stations
│       ├── mp3Quran_ver2.php # 241 Quran reciters & 114 surahs
│       ├── mp3Quran_tafser.php # Tafsir audio commentary stations
│       └── api_test.php      # Automated test harness for API endpoints
├── scripts/
│   └── build_server.sh       # Unified build script (builds directly into app/)
└── .htaccess                 # Root Apache routing & security rules
```

---

## 🛡️ Multi-Layer Anti-Bot Security Engine

The API backend (`api/v3/security.php`) provides production-grade protection against scrapers and DDoS:
1. **IP Sliding Window Rate Limiter:** 60 requests/minute per IP with automatic `429 Too Many Requests` responses.
2. **Bad Bot & Scraper Filtering:** Blocks automated scrapers (`curl`, `python-requests`, `aiohttp`, `scrapy`, `sqlmap`, empty UA) with `403 Forbidden`.
3. **CORS Hardening:** Whitelists `cybeasy.com` and local development environments.
4. **App Client Verification:** Enforces official client headers (`X-App-Platform`, `X-App-Version`, `X-App-Client`) transmitted by `HttpClient`.
5. **Source Code Isolation:** `code/.htaccess` strictly denies direct HTTP access (`Require all denied`).

---

## 💻 Development & Quick Start

All Flutter development takes place inside the `code/` directory using FVM:

```bash
# Navigate to Flutter project root
cd code

# Install dependencies
fvm flutter pub get

# Run on Android / iOS emulator
fvm flutter run

# Run on Web (Chrome)
fvm flutter run -d chrome

# Run static analysis
fvm flutter analyze
```

---

## 🧪 Automated API Testing

To verify the health and security of all 10 API v3 endpoints:

```bash
php api/v3/api_test.php
```

---

## 🚀 Server Deployment & Build Automation

To compile the Flutter Web application directly into `app/` and configure Apache routing:

```bash
./scripts/build_server.sh
```

**What this script does:**
1. Runs the automated API test harness (`api_test.php`).
2. Compiles the Flutter Web release from `code/` with `--base-href "/Tasbeeh-Al-Muslim/app/"`.
3. Populates `app/` and generates SPA `.htaccess` (`RewriteBase /Tasbeeh-Al-Muslim/app/`).

---

## 🤖 AI-Assisted Development (TailorAI Agent)

This project is equipped with an AI Architecture & Runtime Protocol in [`.tailorai/Agent.md`](.tailorai/Agent.md). It guides AI coding assistants (such as **Google Antigravity**, **Claude Code**, **Cursor**, or **GitHub Copilot**) to act as a strict Lead Flutter Architect that adheres to Clean Architecture, BLoC state management, and zero-regression principles.

### 🧭 How to Add Any Feature Using the Agent

Contributors can use the AI Agent to build features safely through 4 structured steps:

1. **Invoke the Protocol:**
   Reference the agent constitution in your AI prompt:
   > `@.tailorai/Agent.md We want to add a feature: [Brief description of the feature]`  
   > *Example:* `@.tailorai/Agent.md Add weekly Friday reminder for Surah Al-Kahf with a toggle in settings.`

2. **Automated Planning & Task Creation:**
   - The Agent inspects [`.tailorai/PROJECT_MAP.md`](.tailorai/PROJECT_MAP.md) to locate the relevant application modules.
   - It generates a dedicated, self-contained task specification file in `.tailorai/Tasks/`.
   - It registers the task in [`.tailorai/ACTIVE_TASKS.md`](.tailorai/ACTIVE_TASKS.md) and presents an atomic step-by-step implementation plan.

3. **Atomic Approval Loop:**
   - **No code is modified without approval:** The Agent waits for your explicit confirmation (`"Proceed"` or `"Approved"`).
   - It executes **one sub-task at a time**, updates the implementation audit log, and stops to request review before continuing to the next step.

4. **Verification & Archiving:**
   - The Agent verifies the changes via `flutter analyze` ensuring **0 compilation errors**.
   - Upon your final confirmation, the task is archived in [`.tailorai/PROJECT_MAP.md`](.tailorai/PROJECT_MAP.md) and cleared from [`.tailorai/ACTIVE_TASKS.md`](.tailorai/ACTIVE_TASKS.md).

### 🛡️ Why Use This System?
- **Zero Regressions:** Prevents accidental breakage of existing audio, prayer, or database services.
- **Full Traceability:** Every feature or bug fix has a permanent, audited record in `.tailorai/Tasks/`.
- **Clean Architecture & Separation of Concerns:** Enforces clear boundaries between UI widgets, BLoC cubits, SQLite models, and audio background services.
- **Effortless Contributor Onboarding:** Any new developer can understand the entire project architecture and task history in minutes via [`.tailorai/PROJECT_MAP.md`](.tailorai/PROJECT_MAP.md).

---

## 🤝 Contributing

Development is done in the `develop` branch and the `main` branch reflects the stable version in Google Play Store.

- PRs, issues (bugs, feedback and suggestions) are welcomed.

Thanks 😀

---

## 📬 Contact & Support

For business inquiries, feedback, or suggestions, please contact:
- **Company:** [CYBEASY](https://cybeasy.com)
- **Developer:** Khaled Gad
- **Email:** <a href="mailto:info@cybeasy.com">info@cybeasy.com</a>

---

## ⚖️ Copyright & License

<h3>Developed by Khaled Gad &bull; <a href="https://cybeasy.com">CYBEASY</a></h3>
<h4>Copyright (C) 2023 - 2026 CYBEASY / Khaled Gad</h4>

    This program is free software: you can redistribute it and/or modify
    it under no terms or License .

    This program is distributed in the hope that it will be useful .
