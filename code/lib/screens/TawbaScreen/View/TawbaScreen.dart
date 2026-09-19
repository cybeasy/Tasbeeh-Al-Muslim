import 'package:flutter/material.dart';
import 'package:tsbeh/AppRoutes.dart';
import 'package:tsbeh/main.dart';

import '../../../models/Base/ApiModel.dart';
import '../Controller/TawbaController.dart';

class TawbaScreen extends StatefulWidget {
  const TawbaScreen({Key? key}) : super(key: key);

  @override
  TawbaScreenState createState() => TawbaScreenState();
}

class TawbaScreenState extends State<TawbaScreen> {
  late TawbaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TawbaController(refresh);
    _controller.onInit();
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قسم التوبه"),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: body(),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                character(),
                SizedBox(height: 30),
                Text(
                  "أريد أن ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                buttons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttons() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 15, left: 15, bottom: 10),
      child: Wrap(
        // spacing: 25,
        // runSpacing: 20.0,
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          button("أصلى على رسول الله", 8),
          button("يغفر الله ذنوبى", 2),
          button("استغفر الله", 3),
          // button("أذكر الله", 6),
          // button("يعتقنى الله من النار", 7),
          button("يحفظنى الله من الشيطان", 1),
          button("أعتق رقبه لله", 1),
          button("يرفع الله درجتى", 1),
        ],
      ),
    );
  }

  Widget button(String title, int id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ApiModel model = ApiModel();
            model.itemId = id.toString();
            model.title = title;

            model.type = ApiType.open;
            model.subtype = ApiSubType.RunTawba;
            model.appModel = AppModel.tawba;

            AppRoutes.openAction(model, [], context: context);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget character() {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: EdgeInsets.only(top: 100, right: 20, left: 20, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("$assetPath/charc1.png", height: 300),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "أهلا بك فى قسم التوبه",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "غفر الله لك",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "ماذا تريد ان تفعل؟",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
