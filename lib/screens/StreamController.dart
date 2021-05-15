import 'dart:async';

class NumberCreator {
  NumberCreator() {
    Timer.periodic(Duration(seconds: 1), (t) {
      // adding to Stream controller
      controller.sink.add(_count);
      _count++;
    });
  }

  @override
  void dispose() {
    controller.close();
    // super.dispose();
  }

  var _count = 1;

  final controller = StreamController<int>();

  Stream get stream => controller.stream;
}
