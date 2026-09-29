import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

int _viewCounter = 0;

Widget getPlatformWebView({String? url, String? htmlContent}) {
  final String viewType = 'web-view-iframe-${++_viewCounter}';
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = html.IFrameElement()
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.backgroundColor = 'white';

    if (url != null && url.isNotEmpty) {
      iframe.src = url;
    } else if (htmlContent != null && htmlContent.isNotEmpty) {
      iframe.srcdoc = htmlContent;
    }

    return iframe;
  });

  return HtmlElementView(viewType: viewType);
}
