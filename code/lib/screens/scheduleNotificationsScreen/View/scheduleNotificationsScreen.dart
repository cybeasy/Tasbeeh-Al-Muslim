import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:tsbeh/Bloc/AppCubit.dart';
import '../../../models/zekerModel.dart';
import '../Controller/scheduleNotificationsController.dart';

class scheduleNotificationsScreen extends StatefulWidget {
  const scheduleNotificationsScreen({Key? key}) : super(key: key);

  @override
  scheduleNotificationsScreenState createState() =>
      scheduleNotificationsScreenState();
}

class scheduleNotificationsScreenState
    extends State<scheduleNotificationsScreen> {
  late scheduleNotificationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = scheduleNotificationsController(refresh);
    _controller.onInit();

    if (!kIsWeb) {
      FirebaseAnalytics.instance.logEvent(
        name: "scheduleNotificationsScreen",
      );
    }
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _controller.cubit = AppCubit.get(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("قائمه التنبيهات"),
        actions: [
          _controller.editSort == false
              ? Container()
              : TextButton(
                  onPressed: () {
                    _controller.saveSort();
                  },
                  child: Text(
                    "حفظ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
        ],
      ),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 45),
              ),
              child: _controller.loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "ايقاف الاذكار",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
              onPressed: () {
                _controller.stop();
              },
            ),
          );
        },
        onClosing: () {},
      ),
      body: body(),
    );
  }

  Widget body() {
    return azkarList();
  }

  Widget azkarList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: _controller.loading
          ? Loader()
          : _controller.pendingList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "لا توجد أذكار مجدولة حالياً",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                )
              : ReorderableListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  onReorder: (int startIndex, int endIndex) {
                    if (startIndex != endIndex) {
                      _controller.editSort = true;

                      if (startIndex < endIndex) {
                        endIndex -= 1;
                      }

                      setState(() {
                        ZekerModel moveItem =
                            _controller.pendingList[startIndex];
                        _controller.pendingList.removeAt(startIndex);
                        _controller.pendingList.insert(endIndex, moveItem);
                        _controller.updateSortTime();
                      });
                    }
                  },
                  children: <Widget>[
                    for (int index = 0;
                        index < _controller.pendingList.length;
                        index += 1)
                      Container(
                        key: Key('$index'),
                        child: cellList(
                          _controller.pendingList[index],
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget cellList(ZekerModel zeker) {
    return InkWell(
      onTap: () {
        _controller.playSound(zeker);
      },
      child: Dismissible(
        key: ValueKey(zeker.notficationId ?? zeker.zeker_id),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerRight,
          child: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (dismissDirection) {
          _controller.deleteNotification(zeker);
        },
        child: Container(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListTile(
                    title: Text(
                      zeker.zeker_name,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    subtitle: Text(
                      zeker.choose_repeat + " : عدد مرات التكرار",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    leading: zeker.notficationScheduledDate != null
                        ? Text(
                            zeker.scheduledDate(),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          )
                        : Text(
                            "فى الدقيقه  " +
                                zeker.notficationScheduledMinute.toString() +
                                "\n" +
                                " من كل ساعه",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
