import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tsbeh/Bloc/AppCubit.dart';
import 'package:tsbeh/Notifications/Local/NotificationService.dart';
import 'package:tsbeh/helper/HexColor.dart';
import 'package:tsbeh/helper/List+ext.dart';
import 'package:tsbeh/main.dart';
import 'package:tsbeh/screens/WebScreen/View/WebScreen.dart';

import 'package:tsbeh/Bloc/AppStates.dart';
import 'package:tsbeh/Bloc/cubit/ThemeAppCubit.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/UpdateNewVer.dart';
import '../../../widget/CustomSliverAppBarDelegate.dart';
import '../Controller/HomeController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late HomeController _controller;
  final globalKey = RectGetter.createGlobalKey();

  double expandHeight = 380;
  String version = "";
  String code = "";

  @override
  void initState() {
    super.initState();
    _controller = HomeController(refresh);
    _controller.onInit();

    if (!kIsWeb) FirebaseAnalytics.instance.logEvent(name: 'HomeScreen');
    UpdateNewVer.check(false, context);

    PackageInfo.fromPlatform().then((packageInfo) {
      version = packageInfo.version;
      code = packageInfo.buildNumber;
      setState(() {});
    });
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        _controller.cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  ThemeAppCubit.get(context).ChangeAppMode();
                  setState(() {});
                },
                icon: Icon(
                  Icons.dark_mode_outlined,
                  size: 30,
                  color: ThemeAppCubit.get(context).IsDark
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Colors.white,
                ),
              ),
            ],
          ),
          body: body(),
          extendBody: true,
          extendBodyBehindAppBar: true,
        );
      },
    );
  }

  Widget body() {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: CustomSliverAppBarDelegate(expandedHeight: expandHeight),
          pinned: false,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            shareAppText(),
            shareAppBtn(),
            lstButtons(),
            appInfo(),
          ]),
        ),
      ],
    );
  }

  Widget shareAppText() {
    return Padding(
      padding: EdgeInsets.only(top: 50, bottom: 20, right: 20, left: 20),
      child: Column(
        children: [
          Text(
            """قال رسول الله صلى الله عليه وسلم أنه قال: """,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 10),
          Text(
            """من دلَّ على خير، فله أجر فاعله. رواه مسلم.""",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget shareAppBtn() {
    return RectGetter(
      key: globalKey,
      child:
          Container(
            // height: 80,
            margin: EdgeInsets.only(top: 0, bottom: 10, right: 20, left: 20),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red[400]!,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 0.75),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.share_outlined, color: Colors.white),
                Text(
                  "ساعدنا وانشر التطبيق ولك أجر فاعله",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).onTap(() async {
            String shareTxt =
                "قم بتحميل برنامج تسبيح المسلم \n" +
                "https://www.cybeasy.com/Tasbeeh-Al-Muslim/";
            if (!kIsWeb && Platform.isIOS) {
              var rect = RectGetter.getRectFromKey(globalKey);
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
          }),
    );
  }

  Widget lstButtons() {
    var listSorted = _controller.cubit.menuList.sortedBy((it) => it.itemId);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        child: Wrap(
          // spacing: 25,
          // runSpacing: 20.0,
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[for (var item in listSorted) listItem(item)],
        ),
      ),
    );
  }

  Widget appInfo() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 50, bottom: 50),
      width: double.maxFinite,
      child: Text(
        "الاصدار :" + version + " (" + code + ")",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium!.apply(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget listItem(ApiModel temp) {
    if (temp.headerInList != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.maxFinite,
            child: Text(
              temp.headerInList!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.apply(
                fontWeightDelta: 5,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        child: Container(
          width: 110,
          height: 140,
          child: Column(
            children: [
              Image.asset(
                "$assetPath/${temp.photo}",
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text(
                temp.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _controller.openScreenBy(temp);
        },
      );
    }
  }
}
