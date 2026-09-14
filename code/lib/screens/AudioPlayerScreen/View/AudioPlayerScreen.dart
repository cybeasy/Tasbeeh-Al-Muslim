import 'package:flutter/foundation.dart';
import 'dart:io';

// import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:tsbeh/helper/connection/cash/CashLocal.dart';
import 'package:tsbeh/screens/AudioPlayerScreen/View/ControlButtons.dart';

import '../../../main.dart';
import '../../../models/AudioModel/common.dart';
import '../../../models/Base/ApiModel.dart';
import '../Controller/AudioPlayerController.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key, required this.model, required this.list})
    : super(key: key);

  final ApiModel model;
  final List<ApiModel> list;

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late AudioPlayerController _controller;
  bool isIgnoringBattery = true;

  @override
  void initState() {
    super.initState();
    _controller = AudioPlayerController(refresh);
    _controller.onInit(widget.list, widget.model);
    ambiguate(WidgetsBinding.instance)!.addObserver(this);

    if (!kIsWeb) FirebaseAnalytics.instance.logEvent(name: 'AudioPlayerScreen');

    checkBatteryOptimization(false);
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      // _player.stop();
    }
  }

  void checkBatteryOptimization(bool forceShow) async {
    if (kIsWeb || !Platform.isAndroid) {
      isIgnoringBattery = true;
      return;
    }

    // isIgnoringBattery =
    //     await DisableBatteryOptimization.isBatteryOptimizationDisabled ?? false;
    if (isIgnoringBattery == false) {
      if (forceShow == false) {
        String skip = CashLocal.getStringCash("IgnoringBatteryOptimizations");
        if (skip == "1") {
          return;
        }
      }

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            "جهازك يقوم بغلق التطبيق فى الخلفيه",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          content: Text(
            "لكى يعمل التطبيق فى الخلفيه يرجي الغاء القيود على البطاريه",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('الغاء'),
                ),
                // TextButton(
                //   onPressed: () => DisableBatteryOptimization
                //       .showDisableBatteryOptimizationSettings(),
                //   child: const Text('فتح الاعدادات',
                //       style: TextStyle(fontWeight: FontWeight.bold)),
                // ),
              ],
            ),
            forceShow == true
                ? SizedBox()
                : TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      CashLocal.saveCash("IgnoringBatteryOptimizations", "1");
                    },
                    child: const Text('لا تظهر هذه الرساله مره اخرى'),
                  ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.titleParent),
        actions: [
          isIgnoringBattery == true
              ? SizedBox()
              : IconButton(
                  onPressed: () {
                    checkBatteryOptimization(true);
                  },
                  icon: Icon(Icons.battery_saver_sharp),
                ),
        ],
      ),
      body: Column(
        children: [
          Cover(),
          const SizedBox(height: 30.0),
          ControlButtons(player),
          seekBarConrollers(),
          const SizedBox(height: 8.0),
          headerlistMedai(),
          listMedai(),
        ],
      ),
    );
  }

  Widget listMedai() {
    return Expanded(
      child: StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final sequence = state?.sequence ?? [];
          return ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex--;
              // _controller.playlist.move(oldIndex, newIndex);
              moveItem(_controller.playlist, oldIndex, newIndex);
            },
            children: [
              for (var i = 1; i < sequence.length; i++) row(sequence, state, i),
            ],
          );
        },
      ),
    );
  }

  void moveItem<T>(List<T> list, int oldIndex, int newIndex) {
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
  }

  Widget headerlistMedai() {
    return Card(
      child: Row(
        children: [
          StreamBuilder<LoopMode>(
            stream: player.loopModeStream,
            builder: (context, snapshot) {
              final loopMode = snapshot.data ?? LoopMode.off;
              const icons = [
                Icon(Icons.repeat, color: Colors.grey),
                Icon(Icons.repeat, color: Colors.orange),
                Icon(Icons.repeat_one, color: Colors.orange),
              ];
              const cycleModes = [LoopMode.off, LoopMode.all, LoopMode.one];
              final index = cycleModes.indexOf(loopMode);
              return IconButton(
                icon: icons[index],
                onPressed: () {
                  player.setLoopMode(
                    cycleModes[(cycleModes.indexOf(loopMode) + 1) %
                        cycleModes.length],
                  );
                },
              );
            },
          ),
          Expanded(
            child: Text(
              "القائمه",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          StreamBuilder<bool>(
            stream: player.shuffleModeEnabledStream,
            builder: (context, snapshot) {
              final shuffleModeEnabled = snapshot.data ?? false;
              return IconButton(
                icon: shuffleModeEnabled
                    ? const Icon(Icons.shuffle, color: Colors.orange)
                    : const Icon(Icons.shuffle, color: Colors.grey),
                onPressed: () async {
                  final enable = !shuffleModeEnabled;
                  if (enable) {
                    await player.shuffle();
                  }
                  await player.setShuffleModeEnabled(enable);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget seekBarConrollers() {
    return StreamBuilder<PositionData>(
      stream: _controller.positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        if ((positionData?.duration ?? Duration.zero) == Duration.zero) {
          return SizedBox(height: 20);
        } else {
          return SeekBar(
            duration: positionData?.duration ?? Duration.zero,
            position: positionData?.position ?? Duration.zero,
            bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
            onChangeEnd: (newPosition) {
              player.seek(newPosition);
            },
          );
        }
      },
    );
  }

  Widget Cover() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black87,
            blurRadius: 15.0,
            offset: Offset(0.0, 0.75),
          ),
        ],
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Stack(
        children: [
          Image.asset(
            "$assetPath/cover.jpg",
            height: 200,
            width: double.maxFinite,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.maxFinite,
            height: 200,
            color: Colors.black38,
            child: Container(
              child: StreamBuilder<SequenceState?>(
                stream: player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        metadata.album!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        metadata.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget row(List<IndexedAudioSource> sequence, SequenceState? state, int i) {
    return Dismissible(
      key: ValueKey(sequence[i]),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (dismissDirection) {
        _controller.playlist.removeAt(i);
      },
      child: Material(
        color: i == state!.currentIndex ? Colors.grey.shade300 : null,
        child: ListTile(
          title: Text(
            sequence[i].tag.title as String,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          onTap: () {
            player.seek(Duration.zero, index: i);
          },
        ),
      ),
    );
  }
}
