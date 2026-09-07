# Visual Identity & Design System — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Color Palette & Material 3 Schemes
The application implements Google Material 3 with support for both Light and Dark modes, utilizing a primary spiritual purple paired with an energetic brand seed orange.

### Light Color Palette
| Role | Hex Code | Flutter Token | Usage |
|------|----------|---------------|-------|
| Brand Seed | `#FD5D00` | `colorSchemeSeed` | Accent buttons and highlight badges |
| Primary | `#6750A4` | `colorScheme.primary` | Active icons, key interactive elements |
| On Primary | `#FFFFFF` | `colorScheme.onPrimary` | Text/icons on primary surfaces |
| Primary Container | `#EADDFF` | `colorScheme.primaryContainer` | Subtle header badges and card highlights |
| Secondary | `#625B71` | `colorScheme.secondary` | Secondary buttons and contextual text |
| Tertiary / Accent | `#7D5260` | `colorScheme.tertiary` | Highlight indicators and badges |
| Error / Danger | `#B3261E` | `colorScheme.error` | Error indicators and delete/stop actions |
| Background | `#FFFBFE` | `colorScheme.background` | Primary scaffold background |
| Surface / Card | `#FFFBFE` | `colorScheme.surface` | Cards, dialogue sheets, bottom navigation |
| On Surface | `#1C1B1F` | `colorScheme.onSurface` | High-emphasis body and title typography |

### Dark Color Palette
| Role | Hex Code | Flutter Token | Usage |
|------|----------|---------------|-------|
| Primary | `#D0BCFF` | `colorScheme.primary` | Contrast icons and highlighted texts |
| Primary Container | `#4F378B` | `colorScheme.primaryContainer` | Card headers and container accents |
| Background | `#1C1B1F` | `colorScheme.background` | AMOLED-friendly dark canvas |
| Surface / Card | `#1C1B1F` | `colorScheme.surface` | Dark elevation surfaces |
| On Surface | `#E6E1E5` | `colorScheme.onSurface` | Crisp, legible typography in dark mode |
| Outline | `#938F99` | `colorScheme.outline` | Subtle borders and dividers |

## 2. Typography
- **Primary Font Family:** `Cairo` (implemented globally via `GoogleFonts.cairoTextTheme()`).
- **Directionality:** Primary **Right-to-Left (RTL)** for Arabic content, with adaptive Left-to-Right (LTR) for English locales.
- **Typographic Scale:**
  - **Display / Big Titles:** `24sp - 28sp`, Bold (`FontWeight.w700`) — used for Surah names, Hadith headers, and prayer names.
  - **Headlines / Card Titles:** `18sp - 20sp`, Semi-Bold (`FontWeight.w600`) — used for menu items and section dividers.
  - **Body Text:** `14sp - 16sp`, Normal/Medium (`FontWeight.w400 - w500`) — used for Athkar text and Quranic verses.
  - **Captions / Footers:** `12sp - 13sp`, Normal (`FontWeight.w300 - w400`) — used for references, timestamps, and versions.

## 3. Spacing, Elevation & Shapes
- **Grid Baseline:** Standard `8dp` increment grid (`8dp`, `16dp`, `24dp`, `32dp`).
- **Corner Radii:**
  - Standard Cards: `12dp - 16dp` rounded corners.
  - Action Chips & Counter Buttons: `20dp` circular rounded rectangles.
- **Shadows & Elevation:** Subtle elevation (`elevation: 2` to `4`) with soft ambient blur (`BoxShadow(color: Colors.black26, blurRadius: 8.0)`).

## 4. UI Component Guidelines
- **Custom Sliver App Bar:** Collapsible header on Home (`CustomSliverAppBarDelegate`) featuring Islamic artwork and quick dark mode toggle.
- **Counters & Action Buttons:** Large, tactile tap targets (`height >= 48dp`) with immediate visual feedback for seamless dhikr counting.
- **Audio Notification Player:** Persistent bottom player bar and system lock screen notification widget displaying reciter name, Surah title, and audio scrubber.
