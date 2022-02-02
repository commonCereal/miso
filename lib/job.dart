typedef JobProcessor<I,O> = Future<O> Function(I input);

class Job<I extends Object,O extends Object> {
  Job(this._input, this._processor);
  final I _input;
  final JobProcessor<I,O> _processor;
  Future<O> process() => _processor(_input);
}