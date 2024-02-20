import 'dart:isolate';

Future<void> main(List<String> arguments) async {
  final startTime = DateTime.now();

  await testIsolateRun(); // 14ms - about 1ms in release mode
  // await testSpawnUri(); // 177ms
  // await testSpawn(); // Same as testIsolateRun

  final endTime = DateTime.now();
  print('Duration: ${endTime.difference(startTime).inMilliseconds}ms');
}

Future<void> testIsolateRun() async {
  final result = await Isolate.run(
    () {
      return 42;
    },
  );

  print(result);
}

Future<void> testSpawnUri() async {
  // Spawn an isolate from the given URI
  final receivePort = ReceivePort();

  // Not working after build because dart does not support spawnUri in AOT mode
  final isolate = await Isolate.spawnUri(
    Uri.parse(
        'https://raw.githubusercontent.com/pvc97/demo_isolate/master/bin/isolate_entry.dart'),
    [],
    receivePort.sendPort,
  );

  // Listen for messages from the spawned isolate
  receivePort.listen((message) {
    print('Received message from isolate: $message');

    if (message == null) {
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
    }
  });
}

void isolateFunction(SendPort sendPort) {
  sendPort.send(42);
}

Future<void> testSpawn() async {
  ReceivePort receivePort = ReceivePort();

  Isolate isolate = await Isolate.spawn(isolateFunction, receivePort.sendPort);

  receivePort.listen((message) {
    print("Received message: $message");
    receivePort.close();
    isolate.kill();
  });
}
