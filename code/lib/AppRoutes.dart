import 'package:tsbeh/screens/ConvertDateScreen/View/ConvertDateScreen.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tsbeh/screens/AudioPlayerScreen/View/AudioPlayerScreen.dart';
import 'package:tsbeh/screens/ContactusScreen/ContactusScreen.dart';
import 'package:tsbeh/screens/RunTawbaScreen/View/RunTawbaScreen.dart';
import 'package:tsbeh/screens/TawbaScreen/View/TawbaScreen.dart';
import 'package:tsbeh/screens/ViewScreen/View/ViewScreen.dart';
import 'package:tsbeh/screens/WebScreen/View/WebScreen.dart';
import 'package:tsbeh/screens/listViewScreen/View/listViewScreen.dart';
import 'package:tsbeh/screens/scheduleNotificationsScreen/View/scheduleNotificationsScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tsbeh/main.dart';
import 'models/Base/ApiModel.dart';
import 'models/ZekerBuildNotifications/BuildAzkar.dart';
import 'screens/AzkarScreen/View/AzkarScreen.dart';
import 'screens/HomeScreen/View/HomeScreen.dart';

void navigateTo({BuildContext? context, router, bool finsh = false}) {
  if (finsh) {
    navigateAndFinsh(context: context, router: router);
  } else {
    if (context != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => router));
    } else {
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (context) => router));
    }
  }
}

void navigateAndFinsh({BuildContext? context, router}) {
  if (context != null) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => router),
        (Route<dynamic> route) => false);
  } else {
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => router),
        (Route<dynamic> route) => false);
  }
}

class AppRoutes {
  // ========================================================================================================
  // App init

  static void back({BuildContext? context}) {
    if (context != null && Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    } else {
      openHomeScreen();
    }
  }

  static void openSplashScreen() {}

  static void openHomeScreen() {
    navigateAndFinsh(router: HomeScreen());
  }

  static void openAzkarScreen({BuildContext? context}) {
    navigateTo(context: context, router: AzkarScreen());
  }

  static void openScheduleNotificationsScreen({BuildContext? context, bool finsh = false}) {
    navigateTo(context: context, router: scheduleNotificationsScreen(), finsh: finsh);
  }

  static void openAction(ApiModel model, List<ApiModel> list, {BuildContext? context}) {
    if (model.subtype == ApiSubType.open) {
    } else if (model.subtype == ApiSubType.Open_list ||
        model.subtype == ApiSubType.Open_list_db) {
      openlistViewScreen(model, context: context);
    } else if (model.subtype == ApiSubType.Open_view) {
      openView(model, context: context);
    } else if (model.subtype == ApiSubType.Open_url) {
      if (model.url!.startsWith("tel")) {
        makeCall(model);
      } else {
        openUrl(model, context: context);
      }
    } else if (model.subtype == ApiSubType.Open_about) {
      // openAbout(model);
      navigateTo(context: context, router: ContactusScreen());
    } else if (model.subtype == ApiSubType.Open_alert) {
      openAlert(model);
    } else if (model.subtype == ApiSubType.Open_twitter) {
      openTwitter(model);
    } else if (model.subtype == ApiSubType.Open_facebookpage) {
      openFacebookPage(model);
    } else if (model.subtype == ApiSubType.Open_buy) {
    } else if (model.subtype == ApiSubType.Open_email) {
      openSendEmail(model);
    } else if (model.subtype == ApiSubType.Open_share) {
      openShare(model);
    } else if (model.subtype == ApiSubType.Open_radio) {
      openRadio(model, list, context: context);
    } else if (model.subtype == ApiSubType.Open_radio_list) {
      openRadioList(model, context: context);
    } else if (model.subtype == ApiSubType.Open_sound) {
      openSound(model, list, context: context);
    } else if (model.subtype == ApiSubType.Zeker) {
      bool isPlay = BuildAzkar.isPlay();
      if (isPlay == false) {
        AppRoutes.openAzkarScreen(context: context);
      } else {
        AppRoutes.openScheduleNotificationsScreen(context: context);
      }
    } else if (model.subtype == ApiSubType.TawbaHome) {
      navigateTo(context: context, router: TawbaScreen());
    } else if (model.subtype == ApiSubType.RunTawba) {
      navigateTo(
          context: context,
          router: RunTawbaScreen(
        model: model,
      ));
    }
  }

  static void openAbout(ApiModel model) {}
  static void openRadio(ApiModel model, List<ApiModel> list, {BuildContext? context}) {
    openSound(model, list, context: context);
  }

  static void openRadioList(ApiModel model, {BuildContext? context}) {
    openlistViewScreen(model, context: context);
  }

  static void openSound(ApiModel model, List<ApiModel> list, {BuildContext? context}) {
    navigateTo(context: context, router: AudioPlayerScreen(model: model, list: list));
  }

  static void openlistViewScreen(ApiModel model, {BuildContext? context}) {
    navigateTo(context: context, router: listViewScreen(model: model));
  }

  static void openUrl(ApiModel model, {BuildContext? context}) {
    if (model.appModel == AppModel.convertDate) {
      navigateTo(context: context, router: const ConvertDateScreen());
    } else {
      navigateTo(
          context: context,
          router: WebScreen(model, false, pages.link, urlLink: model.url));
    }
  }

  static void openAlert(ApiModel model) {}

  static void openTwitter(ApiModel model) {}

  static void openFacebookPage(ApiModel model) {}

  static void openShare(ApiModel model) {
    Share.share(model.share, subject: model.shareTitle);
  }

  static void makeCall(ApiModel model) {
    String phone = model.url!.replaceAll("tel:", "");
    canLaunchUrl(Uri(scheme: 'tel', path: phone)).then((bool result) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phone,
      );
      launchUrl(launchUri);
    });
  }

  static void openSendEmail(ApiModel model) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '', //'smith@example.com',
      query: encodeQueryParameters(
          <String, String>{'subject': model.shareTitle, 'body': model.share}),
    );

    launchUrl(emailLaunchUri);
  }

  static void openView(ApiModel model, {BuildContext? context}) {
    if (model.readFrom == ApiReadFrom.api) {
      navigateTo(
          context: context,
          router: WebScreen(model, false, pages.api, urlLink: model.url));
    } else {
      navigateTo(context: context, router: ViewScreen(model: model));
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           webview(model, false, pages.api, urlLink: model.url),
    //       fullscreenDialog: true),
    // ).then((value) {});
  }
}
