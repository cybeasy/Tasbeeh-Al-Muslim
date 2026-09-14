
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tsbeh/models/Base/ApiModel.dart';
import 'package:tsbeh/models/TawbaModel.dart';

import '../../../main.dart';

class RunTawbaController {
  final Function() refresh;

  RunTawbaController(this.refresh);

  ApiModel? model;

  int count = 0;
  bool isRun = false;
  bool isPlaySound = true;

  final AudioPlayer _audioPlayer = AudioPlayer();
  late AudioSource audio;

  void update() {
    refresh();
  }

  Future<void> onInit(String id) async {
    model = await TawbaModel.getrow(id);
    initSound();
    showPopup();
    update();
  }

  void btnRunCounterClick() {
    isRun = !isRun;
    if (isRun) {
      doInCounter();
      playSound();
      runCounter();
    } else {
      stopSound();
      update();
    }
  }

  void showPopup() {
    EasyLoading.showToast(model?.description ?? "",
        dismissOnTap: true, duration: Duration(minutes: 1));
  }

  void runCounter() {
    if (isRun == false) {
      update();
    } else {
      int time = model!.time * 1000;

      Future.delayed(Duration(milliseconds: time), () async {
        doInCounter();
        runCounter();
      });
    }
  }

  void doInCounter() {
    count++;

    if (count == model!.count) {
      EasyLoading.showSuccess(
          "غفر الله لك , لقد اتممت العدد جعله الله فى ميزان حسناتك",
          dismissOnTap: true,
          duration: Duration(minutes: 10));
    }

    update();
  }

  void initSound() async {
    String path = model!.soundfile;
    audio = AudioSource.asset(
      "assets/sounds/$path",
      tag: MediaItem(
        id: "1",
        title: "    ${model!.title}   ",
      ),
    );

    try {
      await _audioPlayer.setAudioSource(audio);
      await _audioPlayer.setLoopMode(LoopMode.all);
    } catch (e) {
      print("Tawba audio init error: $e");
    }
  }

  void checkSound() async {
    if (isPlaySound) {
      playSound();
    } else {
      stopSound();
    }
  }

  void playSound() async {
    try {
      if (player.playing) {
        player.pause();
      }
      _audioPlayer.play();
    } catch (e) {
      print("Tawba audio play error: $e");
    }
  }

  void stopSound() async {
    try {
      _audioPlayer.pause();
    } catch (e) {
      print("Tawba audio pause error: $e");
    }
  }

  void dispose() {
    isRun = false;
    isPlaySound = false;
    try {
      _audioPlayer.stop();
      _audioPlayer.dispose();
    } catch (e) {
      print("Tawba audio dispose error: $e");
    }
  }
}
