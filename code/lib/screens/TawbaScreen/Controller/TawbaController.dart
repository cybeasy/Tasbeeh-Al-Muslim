class TawbaController {
  final Function() refresh;

  TawbaController(this.refresh);

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    update();
  }
}
