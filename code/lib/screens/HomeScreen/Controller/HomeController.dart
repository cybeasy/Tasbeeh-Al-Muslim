import 'package:flutter/material.dart';
import 'package:tsbeh/AppRoutes.dart';

import 'package:tsbeh/Bloc/AppCubit.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../models/Base/Apis.dart';

class HomeController {
  final Function() refresh;

  HomeController(this.refresh);
  late AppCubit cubit;

  bool isLoading = true;
  Apis api = Apis();

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    update();
  }

  void openScreenBy(ApiModel model, {BuildContext? context}) {
    AppRoutes.openAction(model, [], context: context);
  }
}
