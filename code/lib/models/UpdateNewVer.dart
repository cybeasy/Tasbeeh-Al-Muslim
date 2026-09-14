import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:new_version_plus/new_version_plus.dart';

class UpdateNewVer {
  static final newVersion = NewVersionPlus(
    iOSId: 'com.greatideas4ap.taspieh',
    androidId: 'com.tsbeh',
  );

  static check(bool simpleBehavior, BuildContext context) {
    if (kIsWeb) return;
    if (simpleBehavior) {
      basicStatusCheck(newVersion, context);
    } else {
      advancedStatusCheck(newVersion, context);
    }
  }

  static basicStatusCheck(NewVersionPlus newVersion, BuildContext context) {
    newVersion.showAlertIfNecessary(context: context);
  }

  static advancedStatusCheck(
      NewVersionPlus newVersion, BuildContext context) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint("releaseNotes:" + status.releaseNotes.toString());
      debugPrint("appStoreLink:" + status.appStoreLink.toString());
      debugPrint("localVersion:" + status.localVersion.toString());
      debugPrint("storeVersion:" + status.storeVersion.toString());
      debugPrint("canUpdate:" + status.canUpdate.toString());
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
            context: context,
            versionStatus: status,
            dialogTitle: "تحديث",
            dialogText: "يوجد تحديث جديد من تسبيح المسلم",
            updateButtonText: "حدث الان",
            dismissButtonText: "لاحقا");
      }
    }
  }
}
