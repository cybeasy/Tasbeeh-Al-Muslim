// import '../../helper/DartEnumHelperFunctions copy.dart';

// enum AppModel {
//   radioList,
//   quran,
//   zeker,
//   hades,
//   doaaInQuran,
//   firstInIslam,
//   azkarElyome,
//   islamEvents,
//   convertDate,
//   about,
//   unDefined
// }

// enum ApiType { unDefined, open }

// enum ApiSubType {
//   unDefined,
//   open,
//   Open_list,
//   Open_view,
//   Open_url,
//   Open_about,
//   Open_alert,
//   Open_twitter,
//   Open_facebookpage,
//   Open_buy,
//   Open_email,
//   Open_share,
//   Open_radio,
//   Open_radio_list,
//   Open_sound,
//   Zeker,
//   Open_list_db
// }

// enum ApiReadFrom { api, database, unDefined }

// class ApiModel {
//   ApiModel({Map<String, dynamic>? data}) {
//     if (data != null) map = data;
//   }

//   Map<String, dynamic> map = {};

//   int? get catID {
//     return map["catID"];
//   }

//   set catID(int? value) {
//     map["catID"] = value;
//   }

//   String get itemId {
//     return map["itemId"] ?? "";
//   }

//   set itemId(String value) {
//     map["itemId"] = value;
//   }

//   String get title {
//     return map["title"] ?? "";
//   }

//   set title(String value) {
//     map["title"] = value;
//   }

//   String get photo {
//     return map["photo"] ?? "";
//   }

//   set photo(String value) {
//     map["photo"] = value;
//   }

//   String get url {
//     return map["url"] ?? "";
//   }

//   set url(String? value) {
//     map["url"] = value;
//   }

//   String get free {
//     return map["free"] ?? "";
//   }

//   set free(String value) {
//     map["free"] = value;
//   }

//   String get html {
//     return map["html"] ?? "";
//   }

//   set html(String value) {
//     map["html"] = value;
//   }

//   String get share {
//     return map["share"] ?? "";
//   }

//   set share(String value) {
//     map["share"] = value;
//   }

//   String get shareUrl {
//     return map["shareurl"] ?? "";
//   }

//   set shareUrl(String value) {
//     map["shareurl"] = value;
//   }

//   String get shareTitle {
//     return map["sharetitle"] ?? "";
//   }

//   set shareTitle(String value) {
//     map["sharetitle"] = value;
//   }

//   String get description {
//     return map["description"] ?? "";
//   }

//   set description(String value) {
//     map["description"] = value;
//   }

//   ApiType get type {
//     String strType = map["type"] ?? "unDefined";
//     return enumFromString<ApiType>(strType, ApiType.values);
//   }

//   set type(ApiType value) {
//     map["type"] = enumToString(value);
//   }

//   ApiSubType get subtype {
//     String strSubtype = map["subtype"] ?? "unDefined";
//     return enumFromString<ApiSubType>(strSubtype, ApiSubType.values);
//   }

//   set subtype(ApiSubType value) {
//     map["subtype"] = enumToString(value);
//   }

//   ApiReadFrom get readFrom {
//     String strSubtype = map["readFrom"] ?? "unDefined";
//     return enumFromString<ApiReadFrom>(strSubtype, ApiReadFrom.values);
//   }

//   set readFrom(ApiReadFrom value) {
//     map["readFrom"] = enumToString(value);
//   }

//   AppModel get appModel {
//     String strSubtype = map["appModel"] ?? "unDefined";
//     return enumFromString<AppModel>(strSubtype, AppModel.values);
//   }

//   set appModel(AppModel value) {
//     map["appModel"] = enumToString(value);
//   }

//   String titleParent = "";

//   static List<ApiModel> fromList(List data,
//       {ApiType? type,
//       ApiSubType? subtype,
//       ApiReadFrom? readFrom,
//       AppModel? appModel}) {
//     List<ApiModel> arr = [];

//     for (int i = 0; i < data.length; i++) {
//       // ApiModel temp = ApiModel.fromObject(data[i],
//       //     type: type, subtype: subtype, readFrom: readFrom, appModel: appModel);
//       Map<String, dynamic> temp = Map.from(data[i]);

//       if (type != null) {
//         temp["type"] = enumToString(type);
//       }
//       if (subtype != null) {
//         temp["subtype"] = enumToString(subtype);
//       }
//       if (readFrom != null) {
//         temp["readFrom"] = enumToString(readFrom);
//       }
//       if (appModel != null) {
//         temp["appModel"] = enumToString(appModel);
//       }

//       ApiModel cls = ApiModel(data: temp);
//       arr.add(cls);
//     }

//     return arr;
//   }

//   // factory ApiModel.fromObject(Map<String, dynamic> map,
//   //     {ApiType? type,
//   //     ApiSubType? subtype,
//   //     ApiReadFrom? readFrom,
//   //     AppModel? appModel}) {
//   //   var cls = ApiModel();
//   //   // cls.itemId = map["itemId"] ?? "";
//   //   // cls.catID = map["catID"] ?? 0;

//   //   // cls.title = map["title"] ?? "";
//   //   // cls.photo = map["photo"] ?? "";
//   //   // cls.url = map["url"] ?? "";
//   //   // cls.free = map["free"] ?? "";
//   //   // cls.html = map["html"] ?? "";
//   //   // cls.share = map["share"] ?? "";
//   //   // cls.shareUrl = map["shareurl"] ?? "";
//   //   // cls.shareTitle = map["sharetitle"] ?? "";

//   //   if (readFrom != null) {
//   //     cls.readFrom = readFrom;
//   //   }

//   //   if (appModel != null) {
//   //     cls.appModel = appModel;
//   //   }

//   //   // if (type != null) {
//   //   //   cls.type = type;
//   //   // } else {
//   //   //   String strType = map["type"] ?? "unDefined";
//   //   //   cls.type = enumFromString<ApiType>(strType, ApiType.values);
//   //   // }

//   //   if (subtype != null) {
//   //     cls.subtype = subtype;
//   //   } else {
//   //     String strSubtype = map["subtype"] ?? "unDefined";

//   //     cls.subtype = enumFromString<ApiSubType>(strSubtype, ApiSubType.values);
//   //   }

//   //   return cls;
//   // }
// }
