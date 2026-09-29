import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/models/ZekerBuildNotifications/BuildAzkar.dart';
import 'package:tsbeh/models/ZekerBuildNotifications/SleepHourClass.dart';
import 'package:tsbeh/models/ZekerBuildNotifications/ZekerTime.dart';
import 'package:tsbeh/models/zekerModel.dart';
import 'package:tsbeh/services/web_notification/web_notification.dart';

/// Dedicated periodic Azkar audio service for Flutter Web.
/// Completely isolated from native Android/iOS alarm services.
class WebAzkarTimerService {
  WebAzkarTimerService._internal();
  static final WebAzkarTimerService instance = WebAzkarTimerService._internal();

  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();
  int _cursor = 0;
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  /// Resume timer on web startup if user previously enabled Azkar
  Future<void> initOnStartup() async {
    if (!kIsWeb) return;

    // Attach global listener to unlock AudioContext on user's first click/touch
    WebNotification.attachAudioUnlock(() {
      _unlockAudio();
    });

    if (BuildAzkar.isPlay()) {
      start();
    }
  }

  void _unlockAudio() {
    try {
      _player.stop();
    } catch (_) {}
  }

  /// Start the periodic timer for Web
  void start() {
    if (!kIsWeb) return;
    stop();

    List<ZekerModel> list =
        BuildAzkar.getZekerListFor(zekerListFor.createdChanel);
    if (list.isEmpty) {
      list = BuildAzkar.getZekerListFor(zekerListFor.selected);
    }
    if (list.isEmpty) {
      debugPrint("WebAzkarTimerService: No azkar selected to schedule.");
      return;
    }

    ZekerTime everyTime = BuildAzkar.getEveryTime();
    int totalMinutes = (everyTime.hours * 60) + everyTime.minutes;
    if (totalMinutes <= 0) {
      totalMinutes = 1;
    }

    _isRunning = true;
    _cursor = 0;

    debugPrint(
        "WebAzkarTimerService started with interval: $totalMinutes min, items: ${list.length}");

    _timer = Timer.periodic(Duration(minutes: totalMinutes), (timer) {
      _triggerNextZeker();
    });
  }

  /// Stop and cancel web timer and audio
  void stop() {
    if (!kIsWeb) return;
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    try {
      _player.stop();
    } catch (_) {}
    debugPrint("WebAzkarTimerService stopped.");
  }

  /// Play the next scheduled Zeker
  Future<void> _triggerNextZeker() async {
    if (!_isRunning) return;

    SleepHourClass sleepHours = SleepHourClass.get();
    if (_isSleepTime(sleepHours)) {
      debugPrint("WebAzkarTimerService: Currently in sleep hours. Skipping.");
      return;
    }

    List<ZekerModel> list =
        BuildAzkar.getZekerListFor(zekerListFor.createdChanel);
    if (list.isEmpty) {
      list = BuildAzkar.getZekerListFor(zekerListFor.selected);
    }
    if (list.isEmpty) return;

    if (_cursor >= list.length) {
      _cursor = 0;
    }
    final zeker = list[_cursor];
    _cursor = (_cursor + 1) % list.length;

    // 1. Dispatch native HTML5 desktop notification
    try {
      WebNotification.show(
        zeker.zeker_name,
        "تسبيح المسلم - اذكر الله",
        icon: "icons/Icon-192.png?v=2",
        tag: "tasbeeh_zeker",
      );
    } catch (e) {
      debugPrint("WebAzkarTimerService notification dispatch error: $e");
    }

    // 2. Play audio sound
    await playSingleZeker(zeker);
  }

  /// Play a specific Zeker sound on Web
  Future<void> playSingleZeker(ZekerModel zeker) async {
    try {
      final String path = zeker.soundFileNamePath();
      final audioSource = AudioSource.asset(
        path,
        tag: MediaItem(
          id: zeker.zeker_id,
          title: "    ${zeker.zeker_name}   ",
        ),
      );
      await _player.setAudioSource(audioSource);
      await _player.play();
    } catch (e) {
      debugPrint("WebAzkarTimerService playSingleZeker error: $e");
    }
  }

  /// Check if current time falls within user's configured sleep hours
  static bool _isSleepTime(SleepHourClass sleepHours) {
    if (!sleepHours.stopAt) return false;
    if (sleepHours.startTime.length < 2 || sleepHours.endTime.length < 2) {
      return false;
    }

    final now = DateTime.now();
    final int current = now.hour * 60 + now.minute;
    final int start = sleepHours.startTime[0] * 60 + sleepHours.startTime[1];
    final int end = sleepHours.endTime[0] * 60 + sleepHours.endTime[1];

    if (start > end) {
      // Overnight sleep period (e.g. 23:00 to 07:00)
      return current >= start || current <= end;
    } else {
      // Same-day sleep period (e.g. 13:00 to 15:00)
      return current >= start && current <= end;
    }
  }

  void dispose() {
    _timer?.cancel();
    _player.dispose();
  }
}
