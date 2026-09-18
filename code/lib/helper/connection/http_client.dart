import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../config/AppConfig.dart';
import 'package:tsbeh/main.dart';
import 'ApiResponse.dart';
import 'api_exception.dart';
import 'cash/CashLocal.dart';

class HttpClient {
  HttpClient._privateConstructor();

  static final HttpClient _instance = HttpClient._privateConstructor();

  factory HttpClient() {
    return _instance;
  }

  // late Function(dynamic) onResultData;

  Map<String, String> _buildDefaultHeaders(Map<String, String> customHeaders) {
    String platformName = "Tasbeeh-Mobile";
    if (kIsWeb) {
      platformName = "Tasbeeh-Flutter-Web";
    } else {
      try {
        if (Platform.isAndroid) platformName = "Tasbeeh-Flutter-Android";
        else if (Platform.isIOS) platformName = "Tasbeeh-Flutter-iOS";
      } catch (_) {}
    }

    final headers = {
      "X-App-Platform": platformName,
      "X-App-Version": AppConfig.appVersion,
      "X-App-Client": AppConfig.clientName,
      ...customHeaders,
    };
    return headers;
  }

  String _normalizeUrl(String path) {
    if (kIsWeb) {
      final origin = Uri.base.origin;
      if (path.contains("/api/v3/")) {
        final apiPath = path.substring(path.indexOf("/api/v3/"));
        String prefix = "";
        final currentPath = Uri.base.path;
        if (currentPath.contains("/Tasbeeh-Al-Muslim/")) {
          prefix = "/Tasbeeh-Al-Muslim";
        }
        return "$origin$prefix$apiPath";
      }
      if (path.contains("api.4topapps.com/APPS/")) {
        final currentHost = Uri.base.host;
        if (currentHost == 'localhost' ||
            currentHost == '127.0.0.1' ||
            currentHost.isEmpty ||
            currentHost.startsWith('192.168.') ||
            currentHost.startsWith('10.')) {
          final appPath = path.substring(path.indexOf("/APPS/"));
          return "$origin$appPath";
        }
      }
    }
    return path;
  }

  String getkey(String cashKey, String url) {
    String key = "$cashKey-$url";

    return key;
  }

  void request(
    String path,
    bool isGet, {
    Map<String, dynamic> body = const {},
    bool isCaching = false,
    String cashKey = "",
    Map<String, String> headers = const {},
    Function(ApiResponse)? onResult,
    required Map<String, dynamic> query,
  }) {
    if (isGet) {
      get(
        path,
        body: body,
        isCaching: isCaching,
        cashKey: cashKey,
        headers: headers,
        onResult: onResult,
      );
    } else {
      post(
        path,
        body: body,
        isCaching: isCaching,
        cashKey: cashKey,
        headers: headers,
        onResult: onResult,
      );
    }
  }

  Future<void> get(
    String path, {
    Map<String, dynamic>? body,
    bool isCaching = false,
    String cashKey = "",
    Map<String, String> headers = const {},
    Function(ApiResponse)? onResult,
  }) async {
    try {
      var url = _normalizeUrl(path);

      if (body != null) {
        if (!url.contains("?")) {
          url = url + "?";
        }
        body.forEach((k, v) {
          url = '$url&$k=$v';
        });
      }

      log("$cashKey con Url GET: $url");

      // ======================================================================
      // check Cash
      if (isCaching == true) {
        final localData = await CashLocal.getStringCash(getkey(cashKey, url));
        if (localData.isNotEmpty) {
          log("$cashKey return Cashed data");
          var res = json.decode(localData);

          Response cashRespone = Response(res, 200);
          onResult!(
            ApiResponse(cashRespone, null, cashRespone.statusCode, true),
          );
          // return res;
        }
        // else {
        //   Response cashRespone = Response("", 200);
        //   return ApiResponse(cashRespone, null, cashRespone.statusCode);
        // }
      }
      // ======================================================================

      // response = await get(path)
      //  ..headers.addAll(req_headers) ;
      var uri = Uri.parse(url);
      final effectiveHeaders = _buildDefaultHeaders(headers);
      var request = Request('GET', uri)
        ..headers.addAll(effectiveHeaders);

      var bodyJson = jsonEncode(body);
      request.body = bodyJson;
      var response = await request.send();
      // response = await post(path, headers: req_headers,body: bodyJson);
      final respStr = await response.stream.bytesToString();

      log("===================== $cashKey ==============================");
      log("$cashKey con Url: $url");
      log("$cashKey con GET: $bodyJson");
      log("=====================");
      log("$cashKey con response:\n $respStr");
      log("==========================================================");

      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        if (isCaching) {
          CashLocal.removeCacheContains(getkey(cashKey, url));
          CashLocal.saveCash(
            getkey(cashKey, url),
            respStr,
            duration: const Duration(hours: DurationHours),
          );
        }

        if (respStr.isEmpty) {
          Response cashRespone = Response("", 200);
          // return ApiResponse(cashRespone, null, cashRespone.statusCode);

          onResult!(
            ApiResponse(cashRespone, null, cashRespone.statusCode, false),
          );
        } else {
          Response cashRespone = Response(respStr, 200);
          // return ApiResponse(cashRespone, null, cashRespone.statusCode);
          onResult!(
            ApiResponse(cashRespone, null, cashRespone.statusCode, false),
          );
        }
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      } else if (statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      } else {
        throw UnknownException();
      }
    } catch (e) {
      log("$cashKey get error: $e");
      onResult?.call(ApiResponse(Response("", 500), null, 500, false));
    }
  }

  Future<void> post(
    String path, {
    Map<String, dynamic> body = const {},
    bool isCaching = false,
    String cashKey = "",
    Map<String, String> headers = const {},
    Function(ApiResponse)? onResult,
  }) async {
    try {
      var url = _normalizeUrl(path);

      log("$cashKey con Url POST: $url");

      // ======================================================================
      // check Cash
      try {
        if (isCaching == true) {
          final localData = await CashLocal.getStringCash(getkey(cashKey, url));
          if (localData.isNotEmpty) {
            log("$cashKey return Cashed data");

            Response cashRespone = Response(localData, 200);
            // return ApiResponse(cashRespone, null, cashRespone.statusCode);
            onResult!(
              ApiResponse(cashRespone, null, cashRespone.statusCode, true),
            );
          }
        }
      } catch (e) {}

      // ======================================================================
      Response response;
      var uri = Uri.parse(url);

      String bodyJson = json.encode(body);

      var requestJson = jsonEncode(body);

      var client = http.Client();

      final effectiveHeaders = _buildDefaultHeaders(headers);
      response = await client.post(uri, headers: effectiveHeaders, body: requestJson);

      final respStr = response.body;
      var res = json.decode(respStr);
      log("===================== $cashKey ==============================");
      log("$cashKey con Url: $url");
      log("$cashKey con POST: $bodyJson");
      log("=====================");
      log("$cashKey con response:\n $res");
      log("==========================================================");

      // response = await post(path, headers: req_headers,body: bodyJson);
      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 299) {
        String message = "";

        try {
          message = res?.select("error.message") ?? "";
        } catch (e) {
          message = "";
        }

        if (message.isNotEmpty) {
          onResult!(ApiResponse(response, res, 500, false));
        }

        if (isCaching) {
          CashLocal.removeCacheContains(getkey(cashKey, url));
          CashLocal.saveCash(
            getkey(cashKey, url),
            respStr,
            duration: const Duration(hours: DurationHours),
          );
        }
        onResult!(ApiResponse(response, res, response.statusCode, false));
      } else {
        onResult!(ApiResponse(response, res, response.statusCode, false));
      }
    } catch (e) {
      log("$cashKey post error: $e");
      onResult?.call(ApiResponse(Response("", 500), null, 500, false));
    }
  }

  Future<dynamic> uploadFile(
    String path,
    Map<String, String> body,
    String? image_name,
    File? image, {
    bool isCaching = false,
    Map<String, String> headers = const {},
  }) async {
    // Response response;

    try {
      var url = path;

      // ======================================================================

      String bodyJson = json.encode(body);

      print("con: $url");
      print("con: $bodyJson");

      var uri = Uri.parse(url);

      var request = MultipartRequest('POST', uri)
        ..headers.addAll(
          headers,
        ) //if u have headers, basic auth, token bearer... Else remove line
        ..fields.addAll(body);

      if (image != null) {
        var pic = await http.MultipartFile.fromPath(image_name!, image.path);
        request.files.add(pic);
      }

      var response = await request.send();
      // response = await post(path, headers: req_headers,body: bodyJson);
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 299) {
        final respStr = await response.stream.bytesToString();

        if (isCaching) {
          CashLocal.saveCash(
            "veli-$url-get",
            respStr,
            duration: const Duration(hours: DurationHours),
          );
        }

        if (respStr.isEmpty) {
          return []; //List<dynamic>();
        } else {
          var res = json.decode(respStr);
          // print("con: $res" ) ;

          return res;
        }
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException();
      } else if (statusCode >= 500 && statusCode < 600) {
        throw ServerErrorException();
      } else {
        throw UnknownException();
      }
    } on SocketException {
      throw ConnectionException();
    }
  }
}
