# Task: Replace Default Web Favicon and PWA Icons with Official Brand Logo
- **Date:** 2026-09-14
- **Category:** bugfix
- **Target Files:**
  - `code/web/favicon.png`
  - `code/web/favicon.ico`
  - `code/web/icons/Icon-192.png`
  - `code/web/icons/Icon-512.png`
  - `code/web/icons/Icon-maskable-192.png`
  - `code/web/icons/Icon-maskable-512.png`
  - `code/web/index.html`
  - `app/favicon.png`
  - `app/favicon.ico`
  - `app/icons/`
  - `app/index.html`
  - `vapp-landing/img/favicon.ico`
  - `index.html`

## 1. Objective
Replace the blurry default Flutter blue icons and low-resolution icons across the Flutter Web application (`app/` and `code/web/`) and the marketing landing page (`index.html` / `vapp-landing/img/`) with high-definition, multi-resolution favicons and PWA icons generated from the official high-resolution brand emblem (`code/assets/images/logo.png`), complete with cache-busting query strings for instant browser display.

## 2. Atomic Execution Steps
- [x] [Step 1: Generate high-definition multi-resolution `favicon.ico`, `favicon.png`, `apple-touch-icon`, and PWA icons (192, 512, maskable) from official `logo.png`]
- [x] [Step 2: Update `code/web/` and sync directly to live `app/` and `vapp-landing/img/`]
- [x] [Step 3: Update `code/web/index.html`, `app/index.html`, and root `index.html` with cache-busted icon links (`?v=2`)]
- [x] [Step 4: Verify icon endpoints over HTTP and test in browser]

## 3. Implementation Reality & Audit Log
1. **High-Definition Multi-Resolution Asset Generation:**
   - Sourced the official high-resolution brand logo from `code/assets/images/logo.png` (408×435 transparent PNG).
   - Generated multi-size `favicon.ico` containing 16x16, 32x32, 48x48, and 64x64 with unsharp mask filter for crisp calligraphy rendering.
   - Generated standalone `favicon.png` (32x32), `favicon-64.png` (64x64), and `favicon-16.png` (16x16).
   - Generated `apple-touch-icon.png` (180x180) for iOS home screen bookmarks.
   - Generated full PWA web app icons: `Icon-192.png`, `Icon-512.png`, and maskable variants `Icon-maskable-192.png`, `Icon-maskable-512.png` with 80% safe zone margins.
2. **Asset Deployment & Distribution:**
   - Updated source directory `code/web/` with all generated icon assets.
   - Synchronized directly to live production web app `app/` for immediate browser availability.
   - Replaced `vapp-landing/img/favicon.ico` and added `vapp-landing/img/favicon.png` for marketing landing page.
   - Set proper ownership (`cybeasy_admin:www-data`) and permissions (`0644`).
3. **HTML Head & Cache-Busting Integration:**
   - Updated `code/web/index.html` and `app/index.html` with explicit `<link rel="icon" ...>` and `<link rel="apple-touch-icon" ...>` referencing `?v=2` query parameters.
   - Updated root `index.html` with cache-busted favicon and Apple touch icon references.
   - Synchronized `manifest.json` across `code/web/` and `app/`.
4. **Live HTTP Verification:**
   - Verified 100% success rate (HTTP 200 OK) for all icon endpoints across `app/` and `vapp-landing/`.
