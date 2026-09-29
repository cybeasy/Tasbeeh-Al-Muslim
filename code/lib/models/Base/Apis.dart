import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../helper/connection/ApiResponse.dart';
import 'ApiBase.dart';
import 'ApiModel.dart';
import 'ApiModel__.dart';
import 'ApiRequest.dart';

// const String apiURL = "http://api.4topapps.com/APPS/tsbeh/v3";

class Apis {
  Apis({this.status, this.errorMessage});

  static final HttpClient _httpClient = HttpClient();

  int? status;

  String? errorMessage = "";

  Map<String, dynamic> response = Map();

  fromJson(Map<String, dynamic> json) {
    this.response = json;

    this.status = json['status'] ?? 0;
    this.errorMessage = json['message'] ?? "";
  }

  void checkApiStatus(Map<String, dynamic> json) {
    this.response = json;

    Map<String, dynamic> meta = json["meta"] ?? 0;

    this.status = meta["status"] ?? 0;
    this.errorMessage = meta['message'] ?? "";
  }

  void checkApiStatus_helpDesk(Map<String, dynamic> json) {
    // print(json);

    this.response = json;

    this.status = json["success"] ?? 0;
    this.errorMessage = json['message'] ?? "";
  }

  //========================================================================
  // USer
  //========================================================================
  // Future<List<ApiModel>> menuHome(bool isCaching) async {
  //   try {
  //     var request = ApiRequest();
  //     String? URL = apiURL + "/api.php?mod=menu_home";

  //     request.URL = "$URL/graphql.json";
  //     request.isCaching = true;
  //     request.returnCaching = false;
  //     request.isGet = true;

  //     ApiBase.requestApi(request, onResult: (response) {
  //       if (response.statusCode == 200) {
  //         // var _menu = ApiModel.fromList(response.responseMap!);
  //       }
  //     });

  //     // final List  res = await _httpClient.getRequest( apiURL + "/api.php?mod=menu_home",isCaching:isCaching);
  //     // var _menu = ApiModel.fromList(res);
  //     // // this.fromJson(res);

  //     // return _menu;
  //   } catch (e) {
  //     print("Could Not Load Data: $e");
  //     return [];
  //   }
  //   return [];
  // }

  void getList(
      {required String url,
      required int page,
      bool isCaching = true,
      String cashKey = "",
      required Function(List<ApiModel>, ApiResponse? response) onResult}) {
    try {
      Map<String, String> body = <String, String>{
        'page': page.toString(),
      };

      var request = ApiRequest();

      request.URL = url;
      request.isCaching = isCaching;
      request.returnCaching = false;
      request.isGet = true;
      request.cashKey = cashKey;

      ApiBase.requestApi(request, onResult: (response) {
        if (response.statusCode == 200) {
          var list = ApiModel.fromList(response.result);
          onResult(list, response);
        } else {
          // EasyLoading.showError(response.errorMessage);
          onResult([], response);
        }
      });

      // final List  res = await _httpClient.getRequest( url , bodyFields: body ,isCaching:isCaching);
      // var _menu = ApiModel.fromList(res);

      // return _menu;
    } catch (e) {
      print("Could Not Load Data: $e");
      onResult([], null);
    }
  }

  Future<ApiModel> getContent(String url, bool isCaching) async {
    try {
      // final List res = await _httpClient.getRequest( url   ,isCaching:isCaching);
      // var _menu = ApiModel.fromObject(res.first);

      // return _menu;
    } catch (e) {
      print("Could Not Load Data: $e");
      return ApiModel();
    }

    return ApiModel();
  }
}
