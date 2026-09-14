import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tsbeh/helper/String+ext.dart';

import '../../../models/Base/ApiModel.dart';
import '../../../models/Base/Apis.dart';
import '../Controller/WebController.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html_character_entities/html_character_entities.dart';

import 'web_platform_view_stub.dart'
    if (dart.library.js_interop) 'web_platform_view_web.dart';

enum pages { none, api, youtubeLink, resources, link, database }

class WebScreen extends StatefulWidget {
  late ApiModel model;
  bool ltr = true;
  late pages loadpage;
  late String? url;

  WebScreen(ApiModel _model, bool _ltr, pages _loadpage, {String? urlLink}) {
    this.model = _model;
    this.ltr = _ltr;
    this.loadpage = _loadpage;
    this.url = urlLink;
  }

  @override
  WebScreenState createState() => WebScreenState();
}

class WebScreenState extends State<WebScreen> {
  late WebController _controller;

  bool loading = true;
  late final WebViewController _webcontroller;

  @override
  void initState() {
    super.initState();
    _controller = WebController(refresh, widget.model);
    _controller.onInit();

    if (widget.loadpage == pages.api && widget.url != null) {
      getApi();
    } else {
      loadWebContent(context);
    }

    if (!kIsWeb) {
      FirebaseAnalytics.instance.logEvent(
        name: "WebScreen",
      );
    }
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  void getApi() {
    final _apis = Apis();
    _apis.getContent(widget.url!, true).then((value) async {
      widget.ltr = false;
      _controller.model.html = value.html;
      loadWebContent(context);
    });
  }

  void loadWebContent(BuildContext context) async {
    if (kIsWeb) {
      loading = false;
      if (mounted) setState(() {});
      return;
    }

    try {
      late final PlatformWebViewControllerCreationParams params;
      params = const PlatformWebViewControllerCreationParams();

      final WebViewController controller =
          WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              log('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              log('Page started loading: $url');
            },
            onPageFinished: (String url) {
              log('Page finished loading: $url');
              loading = false;
              setState(() {});
            },
            onWebResourceError: (WebResourceError error) {
              log('''
                  Page resource error:
                    code: ${error.errorCode}
                    description: ${error.description}
                    errorType: ${error.errorType}
                    isForMainFrame: ${error.isForMainFrame}
            ''');
              loading = false;
              if (mounted) setState(() {});
            },
            onNavigationRequest: (NavigationRequest request) {
              log('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        );

      if (widget.loadpage == pages.youtubeLink) {
        // await controller.loadRequest( Uri.parse(  widget.html)  )  ;
      } else if (widget.loadpage == pages.link) {
        await controller.loadRequest(Uri.parse(widget.url!));
      } else if (widget.loadpage == pages.resources) {
        await controller.loadFlutterAsset("assets/${widget.url!}");
      } else {
        String text_align = "text-align: left;";
        if (widget.ltr == false) {
          text_align = "text-align: right;";
        }

        String enc_html = HtmlCharacterEntities.decode(_controller.model.html);
        enc_html = """<!DOCTYPE html>
      <html>
        <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
        <body style='margin: 0; padding: 10px;'>
          <div style='margin-top: 10px; $text_align '>
            $enc_html
          </div>
        </body>
      </html>""";
        await controller.loadHtmlString(enc_html);
      }

      _webcontroller = controller;
    } catch (e) {
      log('Error initializing WebViewController: $e');
      loading = false;
      if (mounted) setState(() {});
    }
  }

  Widget _buildWebIframe() {
    String? url;
    String? htmlContent;

    if (widget.loadpage == pages.resources) {
      url = 'assets/assets/${widget.url!}';
    } else if (widget.loadpage == pages.link ||
        widget.loadpage == pages.youtubeLink) {
      url = widget.url;
    } else if (_controller.model.html.isNotEmpty) {
      String text_align =
          widget.ltr ? "text-align: left;" : "text-align: right;";
      String enc_html = HtmlCharacterEntities.decode(_controller.model.html);
      htmlContent = """<!DOCTYPE html>
<html dir="${widget.ltr ? 'ltr' : 'rtl'}" lang="ar">
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Cairo">
    <style>
      body { font-family: "Cairo", sans-serif; margin: 0; padding: 16px; background-color: #fff; }
    </style>
  </head>
  <body>
    <div style='$text_align'>
      $enc_html
    </div>
  </body>
</html>""";
    } else if (widget.url != null && widget.url!.isNotEmpty) {
      url = widget.url;
    }

    return getPlatformWebView(url: url, htmlContent: htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.title)),
      body: Builder(builder: (BuildContext context) {
        if (loading) return Loader();
        if (kIsWeb) {
          return _buildWebIframe();
        }
        return Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              color: Color(0xFFF2F3F8),
              child: Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: WebViewWidget(controller: _webcontroller)),
            ));
      }),
    );
  }

  Widget btnShare() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
            width: double.maxFinite,
            height: 45,
            child: TextButton(
              onPressed: () {
                String enc_html =
                    HtmlCharacterEntities.decode(_controller.model.html);

                Share.share(enc_html.removeAllHtmlTags(),
                    subject: widget.model.title);
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                'قم بمشاركه المحتوى',
                style: boldTextStyle(size: 18),
              ),
            )));
  }
}
