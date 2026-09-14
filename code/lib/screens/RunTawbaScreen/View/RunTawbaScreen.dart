import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../models/Base/ApiModel.dart';
import '../Controller/RunTawbaController.dart';

class RunTawbaScreen extends StatefulWidget {
  const RunTawbaScreen({Key? key, required this.model}) : super(key: key);
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
          "أريد أن " + widget.model.title,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
                  ? Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    )
                  : Icon(Icons.volume_off, color: Colors.white)),
          IconButton(
              onPressed: () {
                _controller.showPopup();
              },
              icon: Icon(Icons.info, color: Colors.white)),
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
            // Use the properties stored in the State class.

            height: getBlackLayerHeight(context.height()),
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            // Define how long the animation should take.
            duration: const Duration(seconds: 1),
            // Provide an optional curve to make the animation feel smoother.
            curve: Curves.fastOutSlowIn,
          ),

          // new AnimatedSize(
          //   curve: Curves.fastOutSlowIn,
          //   child: Container(
          //     color: Colors.black87,
          //     height: getBlackLayerHeight(context.height()),
          //   ),
          //   duration: new Duration(seconds: 2),
          // ),
          Center(
              child: Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.8),
            ),
            padding: EdgeInsets.all(20),
            width: context.width(),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${_controller.model?.title}",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge!.apply(
                          fontWeightDelta: 3,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
                _controller.count == 0
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${_controller.count}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .apply(
                                      fontWeightDelta: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    )),
                            Text("/${_controller.model!.count}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                      fontWeightDelta: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    )),
                          ],
                        )),
              ],
            ),
          )),
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
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 45),
            ),
            child: Text(
              _controller.isRun ? "ايقاف" : "ابدأ",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            onPressed: () {
              _controller.btnRunCounterClick();
            },
          ),
        );
      },
      onClosing: () {},
    );
  }
}
