import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:tsbeh/main.dart';
import '../../../models/Base/ApiModel.dart';
import '../Controller/RunTawbaController.dart';

class RunTawbaScreen extends StatefulWidget {
  const RunTawbaScreen({super.key, required this.model});
  final ApiModel model;

  @override
  RunTawbaScreenState createState() => RunTawbaScreenState();
}

class RunTawbaScreenState extends State<RunTawbaScreen>
    with TickerProviderStateMixin {
  late RunTawbaController _controller;

  @override
  void initState() {
    super.initState();

    _controller = RunTawbaController(refresh);
    if (mounted) _controller.onInit(widget.model.itemId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "أريد أن ${widget.model.title}",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black45,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              _controller.isPlaySound = !_controller.isPlaySound;
              _controller.checkSound();
              refresh();
            },
            icon: _controller.isPlaySound
                ? const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                  )
                : const Icon(Icons.volume_off, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _controller.showPopup();
            },
            icon: const Icon(Icons.info, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            "$assetPath/445q.gif",
            fit: BoxFit.cover,
            width: context.width(),
          ),
          AnimatedContainer(
            height: getBlackLayerHeight(context.height()),
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.8),
              ),
              padding: const EdgeInsets.all(20),
              width: context.width(),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${_controller.model?.title}",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge!.apply(
                          fontWeightDelta: 3,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  _controller.count == 0
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${_controller.count}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .apply(
                                      fontWeightDelta: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                              Text(
                                _controller.stopAtTarget
                                    ? "/${_controller.model!.count}"
                                    : " / مستمر",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                      fontWeightDelta: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: bottomSheetTawba(),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }

  double getBlackLayerHeight(double height) {
    if (_controller.model == null) return height;

    double pres = (_controller.count / _controller.model!.count) * 100;
    double heightProgress = height - ((pres * height) / 100);

    if (heightProgress < 0) {
      heightProgress = 0;
    }

    return heightProgress;
  }

  Widget bottomSheetTawba() {
    return BottomSheet(
      elevation: 10,
      enableDrag: false,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 45),
            ),
            child: Text(
              _controller.isRun ? "ايقاف" : "ابدأ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            onPressed: () {
              if (_controller.isRun) {
                _controller.stopSession();
              } else {
                _showModeSelectionDialog(context);
              }
            },
          ),
        );
      },
      onClosing: () {},
    );
  }

  void _showModeSelectionDialog(BuildContext context) {
    final targetCount = _controller.model?.count ?? 100;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  "اختر وضع التكرار",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "هل ترغب في التوقف عند إتمام العدد أم الاستمرار دون توقف؟",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 20),
                // Option 1: Stop at target
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pop(ctx);
                    _controller.startSession(stopAtTarget: true);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "التوقف عند الهدف ($targetCount مرة)",
                                textDirection: TextDirection.rtl,
                                style: boldTextStyle(
                                  size: 16,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "يتوقف العداد والصوت تلقائياً عند إتمام العدد",
                                textDirection: TextDirection.rtl,
                                style: secondaryTextStyle(
                                  size: 13,
                                  color: colorScheme.onPrimaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Option 2: Continuous mode
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pop(ctx);
                    _controller.startSession(stopAtTarget: false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          colorScheme.secondaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.all_inclusive_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "الاستمرار دون توقف",
                                textDirection: TextDirection.rtl,
                                style: boldTextStyle(
                                  size: 16,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "يستمر العداد والصوت حتى تضغط إيقاف بنفسك",
                                textDirection: TextDirection.rtl,
                                style: secondaryTextStyle(
                                  size: 13,
                                  color: colorScheme.onSecondaryContainer
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
