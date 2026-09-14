// import 'dart:convert';

// import 'package:http/http.dart';

// class ApiResponse {
//   late Response response;
//   late int statusCode;
//   late String body;
//   late Map<String, String> headers = const {};
//   late Map<String, dynamic>? responseMap = {};
//   late bool isCashed;

//   ApiResponse(Response? _response, Map<String, dynamic>? _responseMap,
//       int _statusCode, bool _isCashed) {
//     if (_response != null) {
//       response = _response;

//       body = _response.body;
//       headers = _response.headers;
//       isCashed = _isCashed;

//       responseMap = _responseMap;
//       if (_responseMap == null) {
//         responseMap = json.decode(_response.body);
//       }
//     }
//     statusCode = _statusCode;
//   }
// }
