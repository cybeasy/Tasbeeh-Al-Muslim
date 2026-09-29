# Security Protocol & Data Protection — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Architecture Overview
Security in **Tasbeeh Al Muslim** is implemented across two distinct layers:
1. **Client-Side Security:** Offline-first mobile and web application sandboxing, SQLite parameterized queries, and scoped OS runtime permissions.
2. **Server-Side API Security & Anti-Bot Protection:** Multi-layer request verification, sliding-window IP rate limiting, automated scraper blocking, domain-restricted CORS, and source code isolation.

---

## 2. Server-Side Security & Anti-Bot Engine (`api/v3/security.php`)

### 2.1 Multi-Layer Defense Topology
```text
[ Incoming Request ]
        │
        ▼
[ 1. Web Server (.htaccess) ] ──> Blocks access to code/, .git, .env, hidden files
        │
        ▼
[ 2. security.php ] ────────────> Resolves real client IP (Cloudflare / Proxies / Direct)
        │
        ├──> [ A. CORS Validation ] ─────────> Enforces origin: cybeasy.com or localhost
        │
        ├──> [ B. Bad Bot / Scraper Filter ] ─> 403 Forbidden for curl, python, scrapy, sqlmap
        │
        └──> [ C. Sliding Window Rate Limiter]─> 429 Too Many Requests if > 60 req/min
        │
        ▼
[ 3. API Endpoint Execution ] ──> Returns JSON response with dual keys & cache controls
```

### 2.2 IP Sliding-Window Rate Limiting
- **Window Size:** 60 seconds sliding window.
- **Request Cap:** 60 requests per IP per minute.
- **Storage:** Atomically written JSON cache in temporary directory (`/tmp/tasbeeh_rate_*.json`).
- **Violation Behavior:** Returns `HTTP 429 Too Many Requests` with a JSON envelope and `Retry-After: 60` response header.
- **Localhost Exemption:** Localhost and CLI scripts (`api_test.php`) bypass rate limits for automated health testing.

### 2.3 Bad Bot & Automated Scraper Filtering
- Automatically inspects the `User-Agent` string.
- Known malicious patterns, automated tools, and headless scrapers are immediately blocked with `HTTP 403 Forbidden`:
  - `curl`, `python-requests`, `aiohttp`, `scrapy`, `sqlmap`, `nikto`, `wpscan`, `libwww-perl`, `urllib`, `wget`.
  - Empty or missing `User-Agent` headers.
- Verified mobile and web clients transmitting valid app headers (`X-App-Platform`) bypass scraper blocking.

### 2.4 Domain-Restricted CORS
Cross-Origin Resource Sharing is locked down to authorized domains:
```http
Access-Control-Allow-Origin: https://cybeasy.com
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Origin, Accept, X-App-Platform, X-App-Version, X-App-Client
```
Requests from unauthorized third-party origins attempting to embed or scrape API v3 data in web browsers are blocked.

### 2.5 Source Code Isolation (`code/.htaccess`)
- The complete Flutter source code resides inside `code/`.
- Apache rules strictly enforce:
  ```apache
  Require all denied
  ```
  Preventing direct HTTP access to `.dart` files, `pubspec.yaml`, `.env`, and source trees.
- Root `.htaccess` blocks access to `.git`, `.env`, and sensitive dotfiles.

---

## 3. Client-Side Security & Network Headers

### 3.1 Custom App Identity Headers
The Flutter client's unified `HttpClient` (`code/lib/helper/connection/http_client.dart`) injects identification headers into all outgoing API calls:
- `X-App-Platform`: e.g. `Tasbeeh-Flutter-Web`, `Tasbeeh-Flutter-Android`, `Tasbeeh-Flutter-iOS`
- `X-App-Version`: Current application version (e.g. `3.0.0`)
- `X-App-Client`: Canonical client signature (`TasbeehAlMuslim-Client`)

### 3.2 Dynamic Origin & Subpath Resolution
When running on Web, `HttpClient` detects whether it is running on `cybeasy.com` and automatically normalizes relative subpath URLs to avoid CORS friction:
- Translates `/Tasbeeh-Al-Muslim/api/v3/...` paths correctly based on `window.location.origin`.

---

## 4. Authentication, Permissions & Data Protection

### 4.1 Authentication & Authorization
- **Mechanism:** Standalone client application. No user credentials or session tokens are stored on the server.
- **Device Identifiers:** Anonymous device identifier utilized exclusively for Firebase Cloud Messaging (FCM) topic delivery.
- **OS Runtime Permissions:**
  - Android 13+: Dynamic runtime requests for `POST_NOTIFICATIONS`.
  - iOS: Background audio entitlements (`UIBackgroundModes: audio`).

### 4.2 Input Validation & SQL Protection
- **Data Integrity:** Dart Sound Null Safety, strong typing, and JSON model parsing (`ApiModel`, `ZekerModel`).
- **Database Security:** SQLite queries executed via parameterized statements in `sqflite` (native) and `sqflite_common_ffi_web` (Wasm) to eliminate SQL injection.

### 4.3 Sandbox Storage & Transport Security
- **Local Sandbox Storage:** Pre-packaged SQLite database and user preferences reside exclusively within the application's private sandbox directory (`getApplicationDocumentsDirectory()` / IndexedDB).
- **Transport Security:** All remote communication with audio APIs and Firebase strictly enforces HTTPS/TLS encryption.
- **Credential Storage:** No private API keys or database passwords committed to source control. Config managed via `code/.env` and `code/lib/config/AppConfig.dart`.

---

## 5. Security Verification & Test Harness
Run the automated security suite to verify bot protection, CORS headers, and rate limits:
```bash
# Verify API v3 endpoints pass health tests
php api/v3/api_test.php

# Test bad bot blocking (should return 403 Forbidden)
curl -s -o /dev/null -w "%{http_code}\n" -A "python-requests/2.28" "https://cybeasy.com/Tasbeeh-Al-Muslim/api/v3/radio.php"
# Expected: 403
```
