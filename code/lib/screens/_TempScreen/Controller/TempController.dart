class TempController {
  final Function() refresh;

  TempController(this.refresh);

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    update();
  }
}
