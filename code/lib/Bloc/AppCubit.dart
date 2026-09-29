
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsbeh/Bloc/AppStates.dart';

import '../models/Base/ApiModel.dart';
import '../config/AppConfig.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  static AppCubit get(context) => BlocProvider.of(context);
  List<ApiModel> menuList = [
    buildListHome(
      itemId: "01",
      headerInList: "أذكار",
      title: "",
      photo: "",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ),
    buildListHome(
      itemId: "01_1",
      title: "تسبيح المسلم",
      photo: "zeker.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ),
    buildListHome(
      itemId: "01_2",
      title: "التوبه",
      photo: "tawba.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.TawbaHome,
      appModel: AppModel.tawba,
    ),
    buildListHome(
      itemId: "02",
      headerInList: "صوتيات",
      title: "",
      photo: "",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ),
    buildListHome(
      itemId: "02_1",
      title: "القران الكريم (صوت)",
      photo: "quran.png",
      url: AppConfig.quranApiUrl,
      type: ApiType.open,
      subType: ApiSubType.Open_list,
      appModel: AppModel.quran,
    ),
    buildListHome(
      itemId: "02_2",
      title: "صوتيات",
      photo: "mic.png",
      url: AppConfig.radioApiUrl,
      type: ApiType.open,
      subType: ApiSubType.Open_radio_list,
      appModel: AppModel.radioList,
    ),
    buildListHome(
      itemId: "02_3",
      title: "تفسير",
      photo: "tafser.png",
      url: AppConfig.tafserApiUrl,
      type: ApiType.open,
      subType: ApiSubType.Open_radio_list,
      appModel: AppModel.radioList,
    ),
    buildListHome(
      itemId: "03",
      headerInList: "اقرأ",
      title: "",
      photo: "",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ),
    buildListHome(
      itemId: "03_1",
      title: "أحاديث نبويه",
      photo: "hades.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.hades,
    ),
    buildListHome(
      itemId: "03_2",
      title: "الدعاء فى القرآن",
      photo: "doaa.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.doaaInQuran,
    ),
    buildListHome(
      itemId: "03_3",
      title: "الأوائل",
      photo: "first.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.firstInIslam,
    ),
    buildListHome(
      itemId: "03_4",
      title: "أذكار اليوم",
      photo: "azkar-elyome.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.azkarElyome,
    ),
    buildListHome(
      itemId: "03_5",
      title: "الأحداث الاسلامية",
      photo: "events-islam.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_list_db,
      appModel: AppModel.islamEvents,
    ),
    buildListHome(
      itemId: "04",
      headerInList: "أخرى",
      title: "",
      photo: "",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Zeker,
      appModel: AppModel.zeker,
    ),
    buildListHome(
      itemId: "04_1",
      title: "محول التقويم",
      photo: "convertdate.png",
      url: "convertdate.html",
      type: ApiType.open,
      subType: ApiSubType.Open_url,
      appModel: AppModel.convertDate,
    ),
    buildListHome(
      itemId: "04_2",
      title: "عن التطبيق",
      photo: "about.png",
      url: "",
      type: ApiType.open,
      subType: ApiSubType.Open_about,
      appModel: AppModel.about,
    ),
  ];

  static ApiModel buildListHome({
    required String itemId,
    required String title,
    required String photo,
    String? url,
    String? headerInList,
    required ApiType type,
    required ApiSubType subType,
    required AppModel appModel,
  }) {
    ApiModel model = ApiModel();
    model.itemId = itemId;
    model.title = title;
    model.url = url;
    model.type = type;
    model.subtype = subType;
    model.appModel = appModel;
    model.photo = photo;
    model.headerInList = headerInList;

    return model;
  }

  void getHomeData(BuildContext context) async {}

  void resetToInitial() {
    emit(InitialAppStates());
  }
}
