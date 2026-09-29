import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:tsbeh/main.dart';
import '../../../models/AudioModel/common.dart';
import '../../../models/Base/ApiModel.dart';

import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerController {
  final Function() refresh;

  AudioPlayerController(this.refresh);

  List<AudioSource> playlist = [];
  late List<ApiModel> list;
  late ApiModel model;

  void update() {
    refresh();
  }

  Future<void> onInit(List<ApiModel> newList, ApiModel newModel) async {
    list = newList;
    model = newModel;
    await _init();
    update();
  }

  Future<void> _init() async {
    if (!kIsWeb) {
      try {
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.music());
      } catch (e) {
        print('AudioSession configure error: $e');
      }
    }

    try {
      await player.stop();
      await player.setLoopMode(LoopMode.off);
    } catch (e) {
      print('AudioPlayer reset error: $e');
    }

    // Listen to errors during playback.
    player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
    try {
      await buildPlaylist();
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
  }

  String urlSupportedExtension(String url) {
    return url.replaceAll(".pls", ".weba");
  }

  // استبدال ConcatenatingAudioSource بالطريقة الحديثة باستخدام setAudioSources

  Future<void> buildPlaylist() async {
    playlist.clear();

    // 1. إضافة المقطع الرئيسي (model) إذا كان مسموح به حسب المنصة
    if (kIsWeb) {
      playlist.add(
        AudioSource.uri(
          Uri.parse(urlSupportedExtension(model.url!)),
          tag: MediaItem(
            id: model.itemId,
            album: model.titleParent,
            title: model.title,
          ),
        ),
      );
    } else if (![
          TargetPlatform.windows,
          TargetPlatform.linux,
        ].contains(defaultTargetPlatform)) {
      playlist.add(
        ClippingAudioSource(
          child: AudioSource.uri(Uri.parse(urlSupportedExtension(model.url!))),
          tag: MediaItem(
            id: model.itemId,
            album: model.titleParent,
            title: model.title,
          ),
        ),
      );
    }

    // 2. إضافة باقي المقاطع من list
    for (int i = 0; i < list.length; i++) {
      ApiModel temp = list[i];
      playlist.add(
        AudioSource.uri(
          Uri.parse(urlSupportedExtension(temp.url!)),
          tag: MediaItem(
            id: temp.itemId,
            album: model.titleParent,
            title: temp.title,
            artist: temp.title,
            artUri: Uri.parse(
              'https://www.cybeasy.com/Tasbeeh-Al-Muslim/vapp-landing/img/logo.png',
            ),
          ),
        ),
      );
    }

    // إعداد قائمة التشغيل في المشغل
    await player.setAudioSources(
      playlist,
    );
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );
}
