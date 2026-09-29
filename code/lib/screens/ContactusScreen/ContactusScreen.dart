import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:in_app_review/in_app_review.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_review/in_app_review.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tsbeh/Bloc/cubit/ThemeAppCubit.dart';
import 'package:tsbeh/main.dart';

enum Availability { loading, available, unavailable }

class ContactusScreen extends StatefulWidget {
  @override
  ContactusScreenState createState() => ContactusScreenState();
}

class ContactusScreenState extends State<ContactusScreen> {
  final globalKey = RectGetter.createGlobalKey();

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) FirebaseAnalytics.instance.logEvent(name: 'ContactusScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(" عن التطبيق")),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 50,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 30,
                  child: Text(
                    "اتصل بنا",
                    style: Theme.of(context).textTheme.bodyLarge?.apply(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      rowViewIcon(
                        "البريد الالكترونى",
                        "",
                        Icon(Icons.mail, size: 20),
                        () {
                          requestUrl("mailto:khaled.he15@gmail.com");
                        },
                      ),
                      rowViewIcon(
                        "الهاتف :",
                        "+20 103 072 2286",
                        Icon(Icons.call, size: 20),
                        () {
                          requestUrl("tel:+201030722286");
                        },
                      ),
                      rowViewIcon(
                        "واتس :",
                        "+20 103 072 2286",
                        Icon(Icons.messenger_outline, size: 20),
                        () {
                          requestUrl("whatsapp://send?phone=+201030722286");
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: 30,
                      child: Text(
                        "عن التطبيق",
                        style: Theme.of(context).textTheme.bodyLarge?.apply(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          rowViewIcon(
                            "كود التطبيق كامل",
                            "",
                            Icon(Icons.app_shortcut, size: 20),
                            () {
                              requestUrl(
                                "https://github.com/cybeasy/Tasbeeh-Al-Muslim",
                              );
                            },
                          ),
                          rowViewIcon(
                            "صفحه التطبيق",
                            "",
                            Icon(Icons.pageview, size: 20),
                            () {
                              requestUrl(
                                "https://www.cybeasy.com/Tasbeeh-Al-Muslim",
                              );
                            },
                          ),
                          rowViewIcon(
                            "قيم التطبيق",
                            "",
                            Icon(Icons.rate_review, size: 20),
                            () async {
                              final InAppReview inAppReview =
                                  InAppReview.instance;
                              if (await inAppReview.isAvailable()) {
                                inAppReview.requestReview();
                              } else {
                                inAppReview.openStoreListing();
                              }
                            },
                          ),
                          RectGetter(
                            key: globalKey,
                            child: rowViewIcon(
                              "انشر التطبيق",
                              "",
                              Icon(Icons.share, size: 20),
                              () async {
                                String shareTxt =
                                    "قم بتحميل برنامج تسبيح المسلم \n" +
                                    "https://www.cybeasy.com/Tasbeeh-Al-Muslim/";
                                if (!kIsWeb && Platform.isIOS) {
                                  var rect = RectGetter.getRectFromKey(
                                    globalKey,
                                  );
                                  await Share.share(
                                    shareTxt,
                                    sharePositionOrigin: Rect.fromLTWH(
                                      rect!.left + 40,
                                      rect.top + 20,
                                      2,
                                      2,
                                    ),
                                  );
                                } else {
                                  await Share.share(shareTxt);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Divider(),
                rowViewIcon(
                  " الوضع المظلم",
                  "",
                  Icon(Icons.dark_mode_outlined, size: 20),
                  () {
                    ThemeAppCubit.get(context).ChangeAppMode();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> requestUrl(String url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      // throw Exception('Could not launch $_url');
    }
  }

  Widget rowViewIcon(
    String title,
    String value,
    Icon icon,
    GestureTapCallback? onClick,
  ) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: InkWell(
        onTap: onClick,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 05),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  child: icon, //Image.asset("$assetPath/$iconName"),
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.apply(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  // titleTextStyle().apply(color: appTheme.appPrimaryColor)
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    value,
                    // style: titleSubBoldTextStyle(),
                    style: Theme.of(context).textTheme.bodyMedium?.apply(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Icon(
                  size: 20,
                  Icons.chevron_right,
                  // color: appTheme.appIconColor //HexColor("#DD4CA3"),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
