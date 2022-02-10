import 'dart:isolate';

import 'package:miso/basic_multi_isolating_examples/iso_group_example.dart';

void main(List<String> args, SendPort sendPort) {
  print(args);

  /*
   * uncommenting the following will cause the program to fail. Since this is spawned
   * into a different Isolate group, the Send port can only accept basic data types:
   * Null, bool, int, double, String, Capability, SendPort, TransferableTypedData
   * OR a List or Map containing only those types.
   */
  // final message = MyData('Hi!');

  final message = MyData('Hi!');
  print('msg hashCode sending: ${message.hashCode}');
  sendPort.send(message.toString());
}