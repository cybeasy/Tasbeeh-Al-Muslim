import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tsbeh/AppRoutes.dart';
import 'package:tsbeh/main.dart';
import 'package:tsbeh/screens/YoutubeVideoScreen/View/YoutubeVideoScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/cubit/ThemeAppCubit.dart';
import '../models/ZekerBuildNotifications/BuildAzkar.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 120;
    final top = expandedHeight - shrinkOffset - size / 0.5;
    final width = context.width();

    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black26,
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75))
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          buildBackground(shrinkOffset, width),
          Positioned(
            top: top,
            left: 16,
            right: 16,
            child: buildFloating(shrinkOffset, context),
          ),
        ],
      ),
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildBackground(double shrinkOffset, double width) {
    return Opacity(
      opacity: disappear(shrinkOffset),
      child: Stack(
        children: [
          Image.asset("$assetPath/cover.jpg",
              height: 360, width: width, fit: BoxFit.cover),
          Container(
            padding: EdgeInsets.only(bottom: 16, top: 32),
            alignment: Alignment.topCenter,
            height: 360,
            decoration: boxDecorationWithRoundedCorners(
                // borderRadius: radius(0),
                backgroundColor: Colors.black.withOpacity(0.6)),
            child:
                Container(), //searchWidget(Colors.white).paddingSymmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }

  String getSatutsAzkar() {
    bool isPlay = BuildAzkar.isPlay();
    if (isPlay) {
      BuildAzkar builder = BuildAzkar();
      String time = builder.everyTime.toStringFormated();

      String timeStop = "";
      if (builder.sleepTime.stopAt) {
        timeStop =
            "\n" + "يتوقف الذكر من " + builder.sleepTime.toStringFormated();
      }
      return "التسبيح كل " + time + timeStop;
    }

    return "خاصيه التسبيح متوقفه";
  }

  Widget buildFloating(double shrinkOffset, BuildContext context) {
    return Opacity(
      opacity: disappear(shrinkOffset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: IconButton(
                onPressed: () async {
                  // navigateTo(router: YoutubeVideoScreen());

                  final Uri _url = Uri.parse("https://youtu.be/T2N4WomMICA");
                  if (!await launchUrl(_url)) {
                    // throw Exception('Could not launch $_url');
                  }
                },
                icon: Image.asset("$assetPath/youtubeBtn.png")),
          ),
          Text('تسبيح المسلم',
              style: boldTextStyle(
                  size: 30,
                  color: ThemeAppCubit.get(context).IsDark
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Colors.white)),
          Text('اذكر الله',
              style: boldTextStyle(
                  size: 20,
                  color: ThemeAppCubit.get(context).IsDark
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Colors.white)),
          8.height,
          Container(
            //height: 80,
            // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: boxDecorationWithShadow(
                backgroundColor: Theme.of(context).colorScheme.background,
                borderRadius: radius(12),
                offset: Offset(0, 5)),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(
                    "$assetPath/logo.png",
                    height: 80,
                    width: 80,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                8.width,
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('التسبيح',
                            style: boldTextStyle(
                                size: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                        4.height,
                        Text(getSatutsAzkar(),
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
