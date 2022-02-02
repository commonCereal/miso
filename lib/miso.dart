import 'dart:async';
import 'dart:isolate';

import 'package:miso/job.dart';

class IsolatePool<I extends Object,O extends Object> {
  IsolatePool(this.poolSize) : _processingPorts = {}, _jobQueue = [];
  final int poolSize;

  final Set<ReceivePort> _processingPorts;
  final List<Job<I,O>> _jobQueue;

  final StreamController<O> _jobOutputController = StreamController.broadcast();

  Stream<O> get outputStream => _jobOutputController.stream;

  dispose() {
    _jobOutputController.close();
  }

  addJobs(Iterable<Job<I,O>> jobs) => jobs.forEach(addJob);

  addJob(Job<I,O> job) async {
    if (_hasAvailableIsolates) {
      _processJob(job);
    } else {
      _enqueueJob(job);
    }
  }


  bool get _hasAvailableIsolates => _processingPorts.length < poolSize;

  void _enqueueJob(Job<I,O> job) {
    _jobQueue.add(job);
  }

  void _processQueue() {
    if (_jobQueue.isNotEmpty && _hasAvailableIsolates) {
      _processJob(_jobQueue.removeAt(0));
    }
  }

  void _processJob(Job<I,O> job) {
    // Create and Setup ReceivePort associated with isolate Worker.
    final rp = ReceivePort();
    rp.listen((message) => _processJobCompletion(rp, message));

    // Add to Process Pool and spawn isolate worker.
    _processingPorts.add(rp);
    Isolate.spawn(_isolatePoolProcessor, _IsolateData(rp.sendPort, job));
  }

  _processJobCompletion(ReceivePort rp, dynamic output) {
    if (output is O) {
      _jobOutputController.add(output);
      rp.close();
      _processingPorts.remove(rp);
      _processQueue();
    }
  }

  static _isolatePoolProcessor(_IsolateData isoData) async {
    final data = await isoData.job.process();
    Isolate.exit(isoData.sp, data);
  }
}

class _IsolateData {
  _IsolateData(this.sp, this.job);
  final SendPort sp;
  final Job job;
}