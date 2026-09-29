import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tsbeh/helper/String+ext.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../helper/html/HtmlToMarkdown.dart';
import '../../../models/Base/ApiModel.dart';
import '../Controller/ViewController.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key, required this.model}) : super(key: key);
  final ApiModel model;

  @override
  ViewScreenState createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  late ViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ViewController(refresh, widget.model);
    _controller.onInit(context);

    if (!kIsWeb) {
      FirebaseAnalytics.instance.logEvent(
        name: "ViewScreen",
      );
    }
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  final globalKey = RectGetter.createGlobalKey();

  @override
  Widget build(BuildContext context) {
    final titleText = widget.model.titleParent.isNotEmpty
        ? widget.model.titleParent
        : widget.model.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: [btnShare()],
      ),
      body: _controller.loading ? Loader() : (kIsWeb ? txtWidget() : web()),
    );
  }

  Widget txtWidget() {
    final displayText =
        _controller.txt.isNotEmpty ? _controller.txt : widget.model.title;

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 50),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SelectableText(
                displayText,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 21,
                  wordSpacing: 3,
                  height: 2.1,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget web() {
    if (kIsWeb) {
      return txtWidget();
    }
    try {
      return WebViewWidget(controller: _controller.webcontroller);
    } catch (e) {
      return txtWidget();
    }
  }

  Widget btnShare() {
    if (!kIsWeb && Platform.isIOS) {
      return btnShareIpad();
    } else {
      return IconButton(
          onPressed: () async {
            final shareTxt = _controller.txt.isNotEmpty
                ? _controller.txt
                : widget.model.title;
            await Share.share(
              shareTxt,
              subject: widget.model.title,
            );
          },
          icon: Icon(Icons.share));
    }
  }

  Widget btnShareIpad() {
    return RectGetter(
      key: globalKey,
      child: IconButton(
          onPressed: () async {
            var rect = RectGetter.getRectFromKey(globalKey);
            final shareTxt = _controller.txt.isNotEmpty
                ? _controller.txt
                : widget.model.title;
            await Share.share(
              shareTxt,
              subject: widget.model.title,
              sharePositionOrigin:
                  Rect.fromLTWH(rect!.left + 40, rect.top + 20, 2, 2),
            );
          },
          icon: Icon(Icons.share)),
    );
  }
}
