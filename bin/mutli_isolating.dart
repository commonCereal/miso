import 'package:miso/miso.dart';
import 'package:miso/job.dart';
import 'package:uuid/uuid.dart';

void main() {
  // Multi-ISOlate Pool... more like MISO Soup!
  final misoSoup = IsolatePool(5);
  final uuidGen = Uuid();
  final jobTimes = [5,10,1,6,20,5,12,4,5,8];
  misoSoup.outputStream.listen(print);

  int isoIndex = 0;
  misoSoup.addJobs(
    jobTimes.map<Job<int, String>>((i) {
      final index = isoIndex++;
      return Job<int, String>(i, (input) async {
        await Future.delayed(Duration(seconds: input));
        return 'Isolate-$index: ${uuidGen.v4()}';
      });
    }),
  );
}