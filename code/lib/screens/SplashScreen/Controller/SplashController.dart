import 'package:tsbeh/AppRoutes.dart';

class SplashController {
  final Function() refresh;

  SplashController(this.refresh);

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    // update();
Future.delayed(const Duration(milliseconds: 500), () {

  AppRoutes.openHomeScreen() ;

});

  }
}
