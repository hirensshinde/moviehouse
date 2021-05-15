import 'StreamController.dart';

final streamData = NumberCreator().stream;

final subscription = streamData.listen(
    (data) {
      print('Data: $data');
    },
    onError: (err) {
      print('Error!');
    },
    cancelOnError: false,
    onDone: () {
      print('Done!');
    });
