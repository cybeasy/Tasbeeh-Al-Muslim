# Task: Redesign Landing Page (index.html) with Islamic Emerald Theme
- **Date:** 2026-09-15
- **Category:** frontend
- **Target Files:**
  - `index.html`

## 1. Objective
Redesign and modernize the landing page (`index.html`) using the elegant visual identity established in `PrivacyPolicy.html` (Cairo typography, emerald/mint Islamic palette `#16a085` & `#27ae60`, soft shadows, modern cards, and badges) while strictly preserving ALL existing content, hadiths, videos, sliders, download links, and scripts, plus enriching sections with enhanced visual elements.

## 2. Atomic Execution Steps
- [x] Step 1: Add Cairo Google Font and modern CSS design system tokens matching `PrivacyPolicy.html` to `index.html` via `vapp-landing/css/theme-emerald.css`.
- [x] Step 2: Redesign the Hero Banner and Navbar with the emerald theme, modern store buttons, web app CTA, and add a quick highlights grid.
- [x] Step 3: Upgrade the Services/Features section, YouTube video frame, App Clips carousel, and About App features list with modern card styling and hover animations.
- [x] Step 4: Polish the Download / CTA section, verify all Owl carousels, mobile drawer, links, and HTML structure.

## 3. Implementation Reality & Audit Log
- **2026-09-15 (Original Restored & New Page Built):**
  - Restored `index.html` back to its original legacy code structure (preserving only the minimal `PrivacyPolicy.html` links in the desktop navbar, mobile drawer, and footer) so the user can easily compare it.
  - Built `index-new.html` completely from scratch without any of the old template bugs or conflicting CSS rules.
  - Applied the exact design system from `PrivacyPolicy.html` into `index-new.html`:
    - Embedded Cairo Google Font, RTL direction, responsive mobile drawer, and sticky glassmorphic navigation.
    - Hero section with Hadith quote card, web app CTA, and sleek download buttons (Google Play, App Store, GitHub Repo).
    - 4 floating highlight cards (مجاني وبدون إعلانات، القرآن الكريم والأدعية، تذكير دوري ذكي، مفتوح المصدر 100%).
    - Features section with Ayah callout box, responsive 16:9 YouTube video embed, and 4 modern floating cards.
    - Screenshots gallery with 4 app screens and hover effects.
    - About section with complete story, 4 feature detail cards, and visual phone mockup.
    - Download CTA section with modern badges and store links.
    - Dark emerald footer with CYBEASY identity, links, and contact info.
  - Validated HTML parser across both `index.html` and `index-new.html` (0 syntax errors, 0 missing assets).