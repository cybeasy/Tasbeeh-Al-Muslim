# Task: Automated Build ID, Cache-Busting, and Stale Cache Invalidation
- **Date:** 2026-09-14
- **Category:** feature
- **Target Files:**
  - `scripts/build_server.sh`
  - `code/web/index.html`
  - `app/.htaccess`
  - `app/index.html`

## 1. Objective
Ensure that every production web build automatically generates and embeds a unique Build ID (timestamp + git hash) across entry points (`index.html`, `flutter_bootstrap.js`, `version.json`), appends cache-busting query strings to scripts (`main.dart.js?v=BUILD_ID`), sets strict zero-cache HTTP headers on entry points in `.htaccess`, and includes client-side cache auto-purge logic to prevent browsers from serving stale cached code.

## 2. Atomic Execution Steps
- [x] [Step 1: Enhance `code/web/index.html` with build-id placeholder, no-cache meta tags, and an automatic client-side cache invalidator script]
- [x] [Step 2: Update `scripts/build_server.sh` to generate a dynamic `BUILD_ID`, inject it into `index.html`, `flutter_bootstrap.js` (`mainJsPath`), and `version.json`, and configure strict no-cache headers for entry points in `app/.htaccess`]
- [x] [Step 3: Run `./scripts/build_server.sh` to build and deploy the new build with cache busting, verify HTTP headers with curl, and test build id injection]

## 3. Implementation Reality & Audit Log
- **Step 1 Completed:** Updated `code/web/index.html` with `Cache-Control`, `Pragma`, and `Expires` no-cache headers, added `{{BUILD_ID}}` placeholders to all icons, manifest, and `flutter_bootstrap.js`, and embedded self-cleaning JavaScript to wipe `CacheStorage` and unregister outdated Service Workers whenever the Build ID changes in `localStorage`.
- **Step 2 Completed:** Updated `scripts/build_server.sh` to automatically generate timestamped Git-hashed `BUILD_ID`, inject it into `app/index.html`, rewrite `mainJsPath` in `app/flutter_bootstrap.js` to `main.dart.js?v=$BUILD_ID`, update `version.json` with build timestamp and metadata, and configure `app/.htaccess` with strict zero-cache headers for entry points (`no-store, no-cache, must-revalidate, max-age=0`).
- **Step 3 Completed:** Executed `./scripts/build_server.sh` successfully with Build ID `20260914165247-e6ff9a8`. Verified live deployment at `https://cybeasy.com/Tasbeeh-Al-Muslim/app/`:
  - `index.html` served with `<meta name="app-build-id" content="20260914165247-e6ff9a8">` and `<script src="flutter_bootstrap.js?v=20260914165247-e6ff9a8">`.
  - `flutter_bootstrap.js` served with `"mainJsPath":"main.dart.js?v=20260914165247-e6ff9a8"`.
  - `app/version.json` contains valid metadata with timestamp `2026-09-14T13:52:47Z`.
  - Cache-busting query strings guarantee that browsers and Cloudflare fetch fresh assets on each build, while the embedded JS clears any client-side `CacheStorage` from prior sessions.
