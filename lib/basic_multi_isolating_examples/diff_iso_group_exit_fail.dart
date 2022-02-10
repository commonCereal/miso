import 'dart:isolate';

import 'package:miso/basic_multi_isolating_examples/iso_group_example.dart';

void main(List<String> args, SendPort sendPort) {
  print(args);
  /*
   * The following will fail as it will be in a different Group, (if spawned via uri),
   * thus showing that spawning with spawnUri creates a different Isolate Group!
   */
  Isolate.exit(sendPort, 'Work Completed!');
}