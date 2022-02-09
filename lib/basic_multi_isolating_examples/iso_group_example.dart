import 'dart:io';
import 'dart:isolate';

class MyData {
  MyData(this.data);
  final String data;

  @override
  String toString() => data;
}

void main(List<String> args) async {
  assert(args.isNotEmpty);

  final port = ReceivePort();
  port.listen((message) {
    if (message is String) {
      final data = MyData(message);
      print(data);
      print('msg hashCode receiving: ${data.hashCode}');
    }
    port.close();
  });

  Isolate.spawnUri(Uri.parse(args.first), ['Hello!'], port.sendPort);
}