# Skill: Flutter & BLoC Clean Architecture (/flutter-arch)

## Purpose
Enforce enterprise-grade Flutter architecture, reactive BLoC/Cubit state management, efficient widget decomposition, performance optimizations (eliminating unnecessary rebuilds), resource lifecycle hygiene, and RTL/multilingual best practices for **tsbeh (Flutter Tasbeeh Al Muslim)**.

## Directives & Best Practices

### 1. Widget Decomposition & Rebuild Optimization
- **Prefer `const` Constructors:** Mark all immutable widgets, paddings, decorations, and styles with `const` to allow Flutter to reuse element tree nodes without re-instantiation.
- **Extract to Separate Widget Classes:** When breaking down large views, create distinct `StatelessWidget` classes rather than private helper methods (e.g. `Widget _buildItem()`). Helper methods defeat Flutter's rebuild optimizations and dirty the parent widget's tree.
- **View Size Limit:** Presentation widgets must remain under 150 lines. Decompose complex screens into dedicated presentational widgets colocated in the feature folder.
- **Targeted Rebuilds:** Never wrap an entire `Scaffold` in a `BlocBuilder`. Wrap only the specific subtree that actually depends on the updated state. Use `BlocSelector` or `buildWhen` condition functions for fine-grained re-renders.

### 2. State Management & Decoupling (BLoC / Cubit)
- **Unidirectional Data Flow:** UI widgets dispatch events or call Cubit methods; Cubits process logic and emit new immutable states. UI renders purely based on current state.
- **Side Effects Handling:** Use `BlocListener` or the listener callback of `BlocConsumer` for navigation, dialogs, audio playback triggers, or toasts. Keep `builder` functions strictly pure and idempotent.
- **Zero Business Logic in Views:** `build()` methods must never initiate HTTP calls, open database connections, or compute heavy data transformations. Delegate all logic to Cubits or Services.

### 3. Resource Management & Lifecycle Hygiene
- **Explicit Disposal:** All stateful controllers must be cleanly disposed in `dispose()`:
  - `TextEditingController`, `ScrollController`, `TabController`, `AnimationController`.
  - `StreamSubscription`, `Timer`, and `AudioPlayer` instances.
- **Audio Session & Background Audio:** Audio streams using `just_audio` and `just_audio_background` must handle audio interruptions, phone calls, and proper release of OS audio focus via `audio_session`.
- **Notification Channels:** Ensure notification channel IDs and importance levels are created once during application startup or dynamically before notification scheduling.

### 4. Database & Asynchronous Operations
- **Non-blocking Execution:** Never perform synchronous file I/O or database locks on the UI thread.
- **Parameterized SQL:** All SQLite operations executed via `sqflite` must use parameterized placeholders (`?`) to guarantee safety and performance.
- **Safe JSON Decoding:** For large payloads, consider `compute()` isolates to avoid frame drops on lower-end devices.

### 5. Layout Directionality & Localization
- **RTL-First Design:** Since Arabic is the primary language, all spatial layouts must respect directional symmetry:
  - Use `EdgeInsetsDirectional` (`start` / `end`) instead of hardcoded `left` / `right`.
  - Use `AlignmentDirectional` instead of `Alignment.centerLeft / centerRight`.
- **No Hardcoded UI Strings:** All user-visible strings must be referenced from localization files (`AppLocalizations`) or organized domain constants.
