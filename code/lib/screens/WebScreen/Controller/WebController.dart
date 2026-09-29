import 'package:nb_utils/nb_utils.dart';
import 'package:tsbeh/models/HadesModel.dart';

import '../../../models/Base/ApiModel.dart';

class WebController {
  final Function() refresh;
  final ApiModel model;

  WebController(this.refresh, this.model);

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    if (model.readFrom != null) {
      if (model.readFrom == ApiReadFrom.database) {
        ApiModel modelDB = await HadesModel.getrow(model.itemId.toInt());
        model.html = modelDB.html;
      }
    }

    update();
  }
}
