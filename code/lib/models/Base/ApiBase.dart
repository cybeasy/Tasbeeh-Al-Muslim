import 'dart:developer';

 
import '../../helper/connection/ApiResponse.dart';
import '../../helper/connection/http_client.dart';
import 'ApiRequest.dart';

class ApiBase {
  static final HttpClient _httpClient = HttpClient();

  static void requestApi(ApiRequest request,
      {bool isGet = false, Function(ApiResponse)? onResult}) async {
    var key = request.cashKey;

    try {
      _httpClient.request(
        request.URL,
        isGet,
        headers: request.Header,
        body: request.body,
        query: request.query,
        isCaching: request.isCaching,
        cashKey: key,
        onResult: onResult,
      );

      // log(response.body);
      // return response;
    } catch (e) {
      log("Error in $key  $e");
    }

    // return ApiResponse(null, null, 500);
  }

  // static Future<ApiResponse> requestApi(ApiRequest request) async {
  //   var key = request.cashKey;

  //   // try {
  //   ApiResponse response = await _httpClient.request(request.URL, request.isGet,
  //       headers: request.Header,
  //       body: request.body,
  //       query: request.query,
  //       isCaching: true,
  //       cashKey: key,onResult: (p0) {

  //       },);

  //   // log(response.body);
  //   return response;
  //   // } catch (e) {
  //   //   log("Error in $key  $e");
  //   // }

  //   return ApiResponse(null, null, 500);
  // }

  // static Future<String> getCashedData(String key) async {
  //   return await _httpClient.getLocalData("", key);
  // }

  ///////////////////////////////// End ////////////////////////////////////////////////////////////////////
}
