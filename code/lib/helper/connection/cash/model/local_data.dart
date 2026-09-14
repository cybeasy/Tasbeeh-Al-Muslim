class BaseLocal {
  DateTime? time;
  String? model;

  BaseLocal({this.time, this.model});

  BaseLocal.fromJson(Map<String, dynamic> json) {
    try {
      time = DateTime.parse(json['time'] ?? "");
      model = json['model'];
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time.toString();
    data['model'] = this.model;
    return data;
  }
}
