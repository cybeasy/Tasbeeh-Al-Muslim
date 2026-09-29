import '../../helper/DartEnumHelperFunctions copy.dart';

enum AppModel {
  radioList,
  quran,
  zeker,
  hades,
  doaaInQuran,
  firstInIslam,
  azkarElyome,
  islamEvents,
  convertDate,
  about,
  unDefined,
  tawba
}

enum ApiType { unDefined, open }

enum ApiSubType {
  unDefined,
  open,
  Open_list,
  Open_view,
  Open_url,
  Open_about,
  Open_alert,
  Open_twitter,
  Open_facebookpage,
  Open_buy,
  Open_email,
  Open_share,
  Open_radio,
  Open_radio_list,
  Open_sound,
  Zeker,
  Open_list_db,
  TawbaHome,
  RunTawba
}

enum ApiReadFrom { api, database, unDefined }

class ApiModel {
  ApiModel();
  // ApiModel({Map<String, dynamic>? data}) {
  //   if (data != null) {
  //     map = data;
  //     ApiModel.fromObject(data);
  //   }
  // }

  Map<String, dynamic> map = {};

  int? catID;

  late String itemId;

  String title = "";

  late String photo;

  late String? url;

  late String free;

  late String html;

  late String share;

  late String shareUrl;

  late String shareTitle;

  late String description;

  late ApiType type;

  late ApiSubType subtype;

  ApiReadFrom? readFrom;

  late AppModel appModel;

  late String titleParent = "";
  String? headerInList;

  late int count;
  late String soundfile;
  late int time;

  static List<ApiModel> fromList(List data,
      {ApiType? type,
      ApiSubType? subtype,
      ApiReadFrom? readFrom,
      AppModel? appModel}) {
    List<ApiModel> arr = [];

    for (int i = 0; i < data.length; i++) {
      ApiModel cls = ApiModel.fromObject(data[i],
          type: type, subtype: subtype, readFrom: readFrom, appModel: appModel);
      // Map<String, dynamic> temp = Map.from(data[i]);

      // if (type != null) {
      //   temp["type"] = enumToString(type);
      // }
      // if (subtype != null) {
      //   temp["subtype"] = enumToString(subtype);
      // }
      // if (readFrom != null) {
      //   temp["readFrom"] = enumToString(readFrom);
      // }
      // if (appModel != null) {
      //   temp["appModel"] = enumToString(appModel);
      // }

      // ApiModel cls = ApiModel(data: temp);
      arr.add(cls);
    }

    return arr;
  }

  factory ApiModel.fromObject(Map<String, dynamic> map,
      {ApiType? type,
      ApiSubType? subtype,
      ApiReadFrom? readFrom,
      AppModel? appModel}) {
    var cls = ApiModel();
    cls.itemId = (map["itemId"] ?? map["obj_itemid"] ?? "").toString();
    cls.catID = map["catID"] ?? 0;

    cls.title = (map["title"] ?? map["obj_title"] ?? "").toString();
    cls.photo = (map["photo"] ?? map["obj_photo"] ?? "").toString();
    cls.url = (map["url"] ?? map["obj_url"] ?? "").toString();
    cls.free = (map["free"] ?? map["obj_free"] ?? "").toString();
    cls.html = (map["html"] ?? map["obj_html"] ?? "").toString();
    cls.share = (map["share"] ?? map["obj_share"] ?? "").toString();
    cls.shareUrl = (map["shareurl"] ?? map["obj_shareurl"] ?? "").toString();
    cls.shareTitle = (map["sharetitle"] ?? map["obj_sharetitle"] ?? "").toString();
    cls.description = (map["description"] ?? map["obj_description"] ?? "").toString();
    cls.count = map["count"] ?? 0;
    cls.time = map["time"] ?? 0;
    cls.soundfile = (map["soundfile"] ?? map["filename"] ?? "").toString();

    if (readFrom != null) {
      cls.readFrom = readFrom;
    }

    if (appModel != null) {
      cls.appModel = appModel;
    }

    if (type != null) {
      cls.type = type;
    } else {
      String strType = map["type"] ?? "unDefined";
      cls.type = enumFromString<ApiType>(strType, ApiType.values);
    }

    if (subtype != null) {
      cls.subtype = subtype;
    } else {
      String strSubtype = map["subtype"] ?? "unDefined";

      cls.subtype = enumFromString<ApiSubType>(strSubtype, ApiSubType.values);
    }

    return cls;
  }
}
