
import 'dart:isolate';

import 'package:miso/basic_multi_isolating_examples/iso_group_example.dart';

class Data<D> {
  Data(this.sp, this.data);
  final SendPort sp;
  final D data;
}

void main() {
  final port = ReceivePort();
  port.listen((message) {
    print(message);
    print('msg hashCode receiving: ${message.hashCode}');
  });
  Isolate.spawn(isoWorker, Data<MyData>(port.sendPort, MyData('Hello!')));
}

// Top Level Function but can also be a static function on an object, this can be seen in my ThreadPool obj.
isoWorker(Data<MyData> port) {
  print(port.data);
  final message = MyData('Hi!');
  print('msg hashCode sending: ${message.hashCode}');
  Isolate.exit(port.sp, message);
}