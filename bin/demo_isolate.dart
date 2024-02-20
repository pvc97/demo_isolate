import 'dart:isolate';

Future<void> main(List<String> arguments) async {
  final startTime = DateTime.now();

  // await testIsolateRun(); // 14ms
  await testSpawnUri(); // 177ms

  final endTime = DateTime.now();
  print('Duration: ${endTime.difference(startTime).inMilliseconds}ms');
}

Future<void> testIsolateRun() async {
  final result = await Isolate.run(
    () {
      return 1 + 1;
    },
  );

  print(result);
}

Future<void> testSpawnUri() async {
  // Spawn an isolate from the given URI
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawnUri(
      Uri.parse('isolate_entry.dart'), [], receivePort.sendPort);

  // Listen for messages from the spawned isolate
  receivePort.listen((message) {
    print('Received message from isolate: $message');

    if (message == null) {
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
    }
  });
}
