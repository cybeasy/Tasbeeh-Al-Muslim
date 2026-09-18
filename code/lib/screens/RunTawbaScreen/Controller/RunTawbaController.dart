import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/models/Base/ApiModel.dart';
import 'package:tsbeh/models/TawbaModel.dart';

import 'package:tsbeh/main.dart';

class RunTawbaController {
  final Function() refresh;

  RunTawbaController(this.refresh);

  ApiModel? model;

  int count = 0;
  bool isRun = false;
  bool isPlaySound = true;
  bool stopAtTarget = true;

  AudioSource? audio;

  void update() {
    refresh();
  }

  Future<void> onInit(String id) async {
    model = await TawbaModel.getrow(id);
    initSound();
    showPopup();
    update();
  }

  void startSession({required bool stopAtTarget}) {
    this.stopAtTarget = stopAtTarget;
    if (model != null && count >= model!.count) {
      count = 0;
    }
    isRun = true;
    doInCounter();
    if (isPlaySound) {
      playSound();
    }
    runCounter();
    update();
  }

  void stopSession() {
    isRun = false;
    stopSound();
    update();
  }

  void btnRunCounterClick({bool? stopAtTargetMode}) {
    if (isRun) {
      stopSession();
    } else {
      startSession(stopAtTarget: stopAtTargetMode ?? true);
    }
  }

  void showPopup() {
    EasyLoading.showToast(
      model?.description ?? "",
      dismissOnTap: true,
      duration: const Duration(minutes: 1),
    );
  }

  void runCounter() {
    if (isRun == false) {
      update();
    } else {
      int time = ((model?.time ?? 0) > 0 ? model!.time : 3) * 1000;

      Future.delayed(Duration(milliseconds: time), () async {
        if (!isRun) return;
        doInCounter();
        runCounter();
      });
    }
  }

  void doInCounter() {
    count++;

    if (model != null && count >= model!.count) {
      if (stopAtTarget) {
        isRun = false;
        stopSound();
        EasyLoading.showSuccess(
          "غفر الله لك , لقد اتممت العدد جعله الله فى ميزان حسناتك",
          dismissOnTap: true,
          duration: const Duration(minutes: 10),
        );
      } else if (count == model!.count) {
        EasyLoading.showToast(
          "تم إتمام العدد المحدد (${model!.count})، والمتابعة مستمرة...",
          dismissOnTap: true,
          duration: const Duration(seconds: 4),
        );
      }
    }

    update();
  }

  void initSound() async {
    if (model == null || model!.soundfile.trim().isEmpty) return;
    String path = model!.soundfile.trim();
    audio = AudioSource.asset(
      "assets/sounds/$path",
      tag: MediaItem(
        id: "tawba_${model!.itemId}",
        title: "    ${model!.title}   ",
      ),
    );

    try {
      await player.stop();
      await player.setAudioSource(audio!);
      await player.setLoopMode(LoopMode.all);
    } catch (e) {
      debugPrint("Tawba audio init error: $e");
    }
  }

  void checkSound() async {
    if (isPlaySound && isRun) {
      playSound();
    } else {
      stopSound();
    }
  }

  void playSound() async {
    try {
      if (audio != null) {
        player.play();
      }
    } catch (e) {
      debugPrint("Tawba audio play error: $e");
    }
  }

  void stopSound() async {
    try {
      player.pause();
    } catch (e) {
      debugPrint("Tawba audio pause error: $e");
    }
  }

  void dispose() async {
    isRun = false;
    isPlaySound = false;
    try {
      await player.stop();
      await player.setLoopMode(LoopMode.off);
    } catch (e) {
      debugPrint("Tawba audio dispose error: $e");
    }
  }
}
