# Task: AI Voice Assistant & Natural Language Action Engine
- **Date:** 2026-09-29
- **Category:** feature
- **Target Files:**
  - `code/lib/services/ai/VoiceRecognitionService.dart`
  - `code/lib/services/ai/IntentRouterService.dart`
  - `code/lib/widgets/VoiceAssistantBottomSheet.dart`
  - `code/lib/screens/HomeScreen/View/HomeScreen.dart`
  - `api/v3/ai_assistant.php`
  - `code/pubspec.yaml`

## 1. Objective
Introduce an intelligent AI Voice Assistant (المساعد الصوتي الذكي) that enables hands-free operation and natural language command execution across the entire application:
1. **Natural Language Voice Input:**
   - Add a microphone floating action button (FAB) or quick-access bar in the home screen.
   - Listen to user voice commands in Arabic using Speech-to-Text (`speech_to_text` with offline/online Arabic models).
2. **Intent Parsing & Semantic Entity Extraction:**
   - **Quran Playback Intent:** Understand commands like *"شغل سورة البقرة بصوت سعد الغامدي"* or *"عايز اسمع الشيخ ماهر المعيقلي سورة الكهف"* -> fuzzy search reciters/surahs in the library -> instantly launch `AudioPlayerScreen` with the resolved audio stream.
   - **Audio Azkar Intent:** Understand commands like *"شغل أذكار الصباح"* or *"شغل أذكار المساء"* -> navigate to the audio azkar player and start recitation immediately.
   - **Periodic Scheduler Intent:** Understand commands like *"فكرني أقول الحمد لله كل 10 دقايق"* or *"ظبط التطبيق يقول استغفر الله كل نص ساعة"* -> extract target dhikr and duration interval -> automatically configure and activate `BuildNotifications` / periodic Azkar engine without manual configuration.
   - **Navigation & Search Intent:** Understand commands like *"افتح محول التاريخ"* or *"وريني أحاديث عن الصبر"* -> navigate directly to `ConvertDateScreen` or `listViewScreen` with pre-filtered results.
3. **Dual Architecture (Offline Fast-Path + Cloud AI Fallback):**
   - **Tier 1 (Local Regex / Fuzzy NLU):** Immediate, zero-latency execution for known patterns (Reciters, Azkar, Scheduler commands) even when offline.
   - **Tier 2 (Cloud AI Agent via `api/v3/ai_assistant.php`):** Resolves ambiguous or complex conversational inputs using LLM function calling to return structured JSON actions to the Flutter app.
4. **Interactive Assistant UI:**
   - Pulsing waveform / sound visualizer during speech capture.
   - Live transcription text bubble.
   - Confirmation card showing the resolved action with "تنفيذ الآن" / "إلغاء".

## 2. Atomic Execution Steps
- [ ] [Step 1: Core Service & Dependencies — Add speech recognition dependencies and implement `VoiceRecognitionService`]
- [ ] [Step 2: NLU Intent Router — Develop `IntentRouterService` with local semantic pattern matching for Quran, Azkar, and Scheduler actions]
- [ ] [Step 3: Backend Fallback Endpoint — Create `api/v3/ai_assistant.php` with structured JSON function calling for complex Arabic queries]
- [ ] [Step 4: UI Assistant Component — Design and integrate `VoiceAssistantBottomSheet` with audio wave animation and feedback states]
- [ ] [Step 5: Action Dispatch Integration — Connect resolved intents to Quran player, Azkar engine, and notification scheduler]
- [ ] [Step 6: Verification & Testing — Validate Arabic speech recognition, intent accuracy, offline fallbacks, and performance]

## 3. Implementation Reality & Audit Log
*(Future implementation log will be recorded here)*
