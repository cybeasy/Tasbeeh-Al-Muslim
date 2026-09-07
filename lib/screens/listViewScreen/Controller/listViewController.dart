import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tsbeh/models/HadesModel.dart';

import '../../../models/AzkarElyomeModel.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/Base/Apis.dart';
import 'package:tsbeh/helper/dbSQLiteProvider.dart';

import '../../../models/DoaaInQuranModel.dart';
import '../../../models/FirstInIslamHadesModel.dart';
import '../../../models/IslamEventsModel.dart';

class listViewController {
  final Function() refresh;

  listViewController(this.refresh, this.model);
  var searchController = TextEditingController();

  List<ApiModel> listOrg = [];

  List<ApiModel> list = [];
  Apis api = Apis();
  // final loadMoreController = ScrollController();
  final ApiModel model;

  int page = 1;
  bool isLoading = true;

  String searchTxt = "";
  String categID = "1";
  bool ltr = false;

  bool? loadingMore;
  late bool hasMoreItems;
  int _maxItems = 30;
  int _numItemsPage = 10;
  Future? initialLoad;

  Future loadMoreItems() async {
    // final totalItems = list.length;
    // await Future.delayed(Duration(seconds: 3), () {
    //   for (var i = 0; i < _numItemsPage; i++) {
    //     items.add(Item('Item ${totalItems + i + 1}'));
    //   }
    // });

    // _hasMoreItems = list.length < _maxItems;

    hasMoreItems = false;
  }

  void update() {
    refresh();
  }

  Future<void> pullRefresh() async {
    page = 1;
    await getListOnline(false);
  }

  Future<void> onInit() async {
    initialLoad = Future.delayed(Duration(seconds: 1), () async {
      // Future.delayed(const Duration(milliseconds: 2000), () async {
      //   isLoading = false;

      if (model.subtype == ApiSubType.Open_list_db) {
        await getFromDB();
      } else {
        getFromApi();
      }
      hasMoreItems = true;
      update();
    });

    //   update();
    // });

    update();
  }

  Future<void> getFromDB() async {
    if (model.appModel == AppModel.hades) {
      listOrg = await HadesModel.getMainList();
    } else if (model.appModel == AppModel.firstInIslam) {
      listOrg = await FirstInIslamHadesModel.getList(model.catID);
    } else if (model.appModel == AppModel.doaaInQuran) {
      listOrg = await DoaaInQuranModel.getList();
    } else if (model.appModel == AppModel.azkarElyome) {
      listOrg = await AzkarElyomeModel.getList(categid: model.catID);
    } else if (model.appModel == AppModel.islamEvents) {
      listOrg = await IslamEventsModel.getList(categid: model.catID);
    }

    list.addAll(listOrg);
    // update();
  }

  void getFromApi() {
    getListOnline(true);
  }

  void _pullRefresh() {
    // page = 1;
    getListOnline(false);
  }

  Future<void> getListOnline(bool isCaching) async {
    isLoading = true;
    update();

    api.getList(
      url: model.url!,
      page: page,
      isCaching: isCaching,
      cashKey: model.title + "_$page",
      onResult: (lst, response) {
        if (list.isNotEmpty && response?.isCashed == false) {
          return;
        }
        isLoading = false;
        list.clear();
        list.addAll(lst);

        listOrg.clear();
        listOrg.addAll(lst);

        update();

        // if (page == 1) {
        //   loadMoreController.animateTo(
        //     0.0,
        //     curve: Curves.easeOut,
        //     duration: const Duration(milliseconds: 300),
        //   );
        // }

        if (lst.length == 0) {
          page = page - 1;
          if (page <= 0) {
            page = 1;
          }
        }
      },
    );
  }

  void search(String value) {
    isLoading = true;
    list.clear();
    update();

    getSearchResult(value).then((value) {
      list = value;
      isLoading = false;
      update();
    });
  }

  Future<List<ApiModel>> getSearchResult(String value) async {
    List<ApiModel> result = [];

    result.addAll(listOrg.where((elment) =>
        elment.title.contains(value) || elment.description.contains(value)));

    return result;
  }
}
