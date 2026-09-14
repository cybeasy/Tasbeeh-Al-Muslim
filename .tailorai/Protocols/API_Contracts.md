# API Contracts & Response Conventions — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Remote API Base URL
The application consumes JSON endpoints hosted at `https://cybeasy.com/Tasbeeh-Al-Muslim/api/v3/` (configurable via `AppConfig.dart` on client and `config.php` on server):

- **Production URL:** `https://cybeasy.com/Tasbeeh-Al-Muslim/api/v3/`
- **Local Dev URL:** `http://localhost:8080/api/v3/`

## 2. Multi-Layer Security & Anti-Bot Protection
All API v3 endpoints enforce centralized security via `security.php`:

### 2.1 Domain-Restricted CORS
```http
Access-Control-Allow-Origin: https://cybeasy.com
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Origin, Accept, X-App-Platform, X-App-Version, X-App-Client
Content-Type: application/json; charset=utf-8
```

### 2.2 Rate Limiting
- **Threshold:** 60 requests per 60-second sliding window per IP.
- **Violation Response:** `HTTP 429 Too Many Requests` with `Retry-After: 60`.

### 2.3 Bad Bot & Scraper Filtering
- Rejects requests matching automated scraper signatures (`curl`, `python-requests`, `aiohttp`, `scrapy`, `sqlmap`, empty UA) with `HTTP 403 Forbidden`.
- Accepts verified Flutter clients transmitting `X-App-Platform` (`Tasbeeh-Flutter-Web`, `Tasbeeh-Flutter-Android`, `Tasbeeh-Flutter-iOS`).

## 3. Data Model & Dual-Key Convention
To guarantee compatibility with legacy iOS/Android clients and modern Flutter Web, all responses provide dual keys:
- **Identifier:** `itemId` / `obj_itemid` (String)
- **Title:** `title` / `obj_title` (String)
- **Audio/Content URL:** `url` / `obj_url` (String)
- **Share Text:** `share` / `obj_share` (String)
- **Share URL:** `shareurl` / `obj_shareurl` (String)
- **Description:** `description` / `obj_description` (String)
- **Type:** `type` (e.g. `open`)
- **SubType:** `subtype` (e.g. `Open_radio`, `Open_list`, `Open_sound`, `Open_url`, `Open_email`)

## 4. Endpoints Catalog

### 4.1 Radio Stations (`/radio.php`)
- **Method:** `GET`
- **Query Params:** None or `?page=1`
- **Output:** Array of 170+ live Islamic radio stations with direct stream URLs.

### 4.2 Quran Reciters & Surahs (`/mp3Quran_ver2.php`)
- **Method:** `GET`
- **Variants:**
  - `GET /mp3Quran_ver2.php`: Lists all reciters (240+ reciters) with moshafs count.
  - `GET /mp3Quran_ver2.php?moshaf_id={reciter_id}`: Lists available moshafs for the specified reciter.
  - `GET /mp3Quran_ver2.php?id={reciter_id}&moshaf_id={moshaf_id}`: Lists all 114 Surahs for the specified reciter and moshaf with direct audio MP3 URLs and Ayah counts.

### 4.3 Quran Tafsir (`/mp3Quran_tafser.php`)
- **Method:** `GET`
- **Variants:**
  - `GET /mp3Quran_tafser.php`: Lists available Tafsir commentary stations.
  - `GET /mp3Quran_tafser.php?tafsir={id}&language=ar`: Lists audio surahs with spoken commentary.

### 4.4 App Information & Feeds
- `GET /about.php`: Application metadata, store ratings, developer contacts.
- `GET /menu_home.php`: Dynamic home screen navigation feed.
- `GET /slider.php`: Featured hadith and announcements slider feed.
- `GET /support.php`: Support and sharing channels.

## 5. Automated Health Verification
Every endpoint is continuously verified via the self-test harness:
```bash
php api/v3/api_test.php
```
All tests must report `[PASS]` before deployment.
