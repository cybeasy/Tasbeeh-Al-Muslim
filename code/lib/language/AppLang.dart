// import 'package:ShopyMob/app/language/AppLanguage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:nb_utils/nb_utils.dart';
// import 'package:provider/provider.dart';

// class AppLang extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appLanguage = Provider.of<AppLanguage>(context);
//     return Scaffold(
//       body: Observer(
//           builder: (_) => Directionality(
//                 textDirection: TextDirection.ltr,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         // Text(
//                         //   appLocalizations.of(context).translate('Message'),
//                         //   style: TextStyle(fontSize: 32),
//                         // ),
//                         Column(
//                           children: <Widget>[
//                             Container(
//                               height:
//                                   (MediaQuery.of(context).size.height) / 3.5,
//                               child: Stack(
//                                 children: <Widget>[
//                                   Image.asset(
//                                     "res/theme/t3_ic_background.png",
//                                     fit: BoxFit.fill,
//                                     width: MediaQuery.of(context).size.width,
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(left: 16),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Text("Choose language",
//                                             style: boldTextStyle(
//                                                 size: 34, color: t3_white)),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 50),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//                               child: T3AppButton(
//                                   textContent: "English",
//                                   onPressed: () {
//                                     appLanguage.changeLanguage(Locale("en"));
//                                     Navigator.of(context)
//                                         .pushReplacementNamed("/Splash");
//                                   }),
//                             ),
//                             SizedBox(height: 20),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//                               child: T3AppButton(
//                                   textContent: 'العربي',
//                                   onPressed: () {
//                                     appLanguage.changeLanguage(Locale("ar"));
//                                     Navigator.of(context)
//                                         .pushReplacementNamed("/Splash");
//                                   }),
//                             ),
//                             Container(
//                               alignment: Alignment.bottomLeft,
//                               margin: EdgeInsets.only(
//                                   top: 50, left: 16, right: 16, bottom: 20),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Image.asset("res/theme/t3_ic_sign2.png",
//                                       height: 50,
//                                       width: 70,
//                                       color: appStore.iconColor),
//                                   Container(
//                                       margin:
//                                           EdgeInsets.only(top: 25, left: 10),
//                                       child: Image.asset(
//                                           "res/theme/t3_ic_sign4.png",
//                                           height: 50,
//                                           width: 70,
//                                           color: appStore.iconColor)),
//                                   Container(
//                                       margin:
//                                           EdgeInsets.only(top: 25, left: 10),
//                                       child: Image.asset(
//                                           "res/theme/t3_ic_sign3.png",
//                                           height: 50,
//                                           width: 70,
//                                           color: appStore.iconColor)),
//                                   Image.asset("res/theme/t3_ic_sign1.png",
//                                       height: 80,
//                                       width: 80,
//                                       color: appStore.iconColor),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )),
//     );
//   }
// }
