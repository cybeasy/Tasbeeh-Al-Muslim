class YoutubeVideoController {
  final Function() refresh;

  YoutubeVideoController(this.refresh);

  void update() {
    refresh();
  }

  Future<void> onInit() async {
    update();
  }
}
