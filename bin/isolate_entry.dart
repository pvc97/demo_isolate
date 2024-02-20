import 'dart:isolate';

void main(List<String> args, SendPort sendPort) {
  // Perform some computation or task in the isolate
  final result = computeSomething();

  // Send the result back to the main isolate
  sendPort.send(result);

  // Close the isolate
  sendPort.send(null);
}

int computeSomething() {
  // This could be a heavy computation or any task you want to run in a separate isolate
  return 42;
}
