import 'dart:isolate';

import 'package:dio/dio.dart';

import 'isolate_object.dart';

class IsolateTwo {
  //Isolate
  Isolate _isolate1;
  Isolate _isolate2;
  void runIsolateFn() async {
    printStartMethod('Start Method');

    stop();
    ReceivePort _receivePort = ReceivePort(); //port for this main isolate to receive messages.

    var message = IsolateObject<String>(
      value: "Hello from Isolate 1",
      sender: _receivePort.sendPort,
    );

    _isolate1 = await Isolate.spawn(runMethod1, message);
    _isolate2 = await Isolate.spawn(runMethod2, _receivePort.sendPort);

    _receivePort.listen(
      (data) {
        if (data == null) {
          print('Ah nooo! Data not received!');
          stop();
        } else if (data.runtimeType == String) {
          print(data);
        } else if (data.runtimeType.toString() == 'IsolateObject<String>') {
          print((data as IsolateObject).value);
        }
      },
    );

    runWhile(
      message: 'Running on the main app Isolate',
      url: 'https://jsonplaceholder.typicode.com/photos',
      turns: 2,
    );
  }

  static void runMethod1(IsolateObject isolate) async {
    var message = IsolateObject<String>(
      value: '${isolate.value} - ${DateTime.now()}',
      sender: isolate.sender,
    );

    printStartMethod('Method 1');

    runWhile(
      message: 'Isolate 1 *** *** *** *** ***',
      url: 'https://jsonplaceholder.typicode.com/todos',
      turns: 2,
    );

    isolate.sender.send(message);
  }

  static void runMethod2(SendPort isolate) async {
    var message = 'Ok! I finished here from Isolate 2';

    printStartMethod('Method 2');

    runWhile(
      message: 'Isolate 2 *** *** *** *** ***',
      url: 'https://jsonplaceholder.typicode.com/comments',
      turns: 2,
    );

    isolate.send(message);
  }

  static void printStartMethod(String message) {
    print('Started running - $message');
  }

  static void runWhile({String message, String url, int turns}) async {
    int count = 1;
    Response response;
    while (count <= turns) {
      // if (message.compareTo('Running on the main app Isolate') == 0) {
      //   await Future.delayed(Duration(milliseconds: 300));
      // } else if (message.startsWith('Isolate 1')) {
      //   await Future.delayed(Duration(milliseconds: 300));
      // } else if (message.startsWith('Isolate 2')) {
      //   await Future.delayed(Duration(milliseconds: 300));
      // }
      response = await Dio().get('$url/$count');

      count++;

      print('\n$message\n${response.data.toString()}\n*** *** *** ***\n');
    }
  }

  void stop() {
    if (_isolate1 != null) {
      print('killing isolate');
      _isolate1.kill(priority: Isolate.immediate);
      _isolate1 = null;
    }

    if (_isolate2 != null) {
      print('killing isolate');
      _isolate2.kill(priority: Isolate.immediate);
      _isolate2 = null;
    }
  }
}
