# Testing Standards & Quality Assurance — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Test Suite Hierarchy
- **Unit Tests:** `flutter_test` (BLoC/Cubit state machines, models, helper logic under `code/test/`).
- **Integration Tests:** Widget tests (`testWidgets` in `code/test/`) and end-to-end integration flows.
- **Backend API Tests:** Automated self-test harness (`api/v3/api_test.php`) verifying all 10 endpoints, HTTP status codes, and JSON response envelopes.
- **Security & Anti-Bot Tests:** Bot signature detection, rate limiter verification, and CORS origin policy checks.

## 2. Test Coverage Mandates
- Business domain logic and critical security paths MUST be fully covered by automated tests.
- API endpoints MUST validate expected success responses (`HTTP 200`), rate-limiting triggers (`HTTP 429`), and unauthorized scraper rejections (`HTTP 403`).
- Client data models MUST deserialize both legacy (`obj_*`) and modern keys reliably.

## 3. Execution Commands

### 3.1 Flutter Client Testing (Run from `code/`)
```bash
# Execute unit and widget test suite
cd code && fvm flutter test

# Static code analysis and lint verification
cd code && fvm flutter analyze
```

### 3.2 Backend API Health Verification
```bash
# Run automated API v3 test suite across all 10 endpoints
php api/v3/api_test.php
```

### 3.3 Security & Anti-Bot Verification
```bash
# Verify scraper blocking (returns 403 Forbidden)
curl -s -o /dev/null -w "%{http_code}\n" -A "python-requests/2.28" "http://localhost:8080/api/v3/radio.php"

# Verify legitimate client access (returns 200 OK)
curl -s -o /dev/null -w "%{http_code}\n" -H "X-App-Platform: Tasbeeh-Flutter-Web" "http://localhost:8080/api/v3/radio.php"
```

## 4. Test Verification Workflow Before Task Completion
1. Execute `php api/v3/api_test.php` and verify 10/10 test suites pass.
2. Execute `cd code && fvm flutter analyze` and confirm zero errors/warnings.
3. Execute `cd code && fvm flutter test` and verify zero regressions.
4. Execute `./scripts/build_server.sh` and verify successful compilation to `app/`.
