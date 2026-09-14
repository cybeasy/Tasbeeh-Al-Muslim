class ApiRequest {
  late String URL;
  late Map<String, String> Header = {};
  late Map<String, dynamic> body = {};
  late Map<String, dynamic> query = {};
  late bool isCaching;
  late bool returnCaching;
  late String cashKey;
  bool isGet = false;
}
