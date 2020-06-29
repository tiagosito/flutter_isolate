import 'dart:isolate';

import 'package:dio/dio.dart';

import 'isolate_object.dart';

class IsolateThree {
  //Isolate
  Isolate _isolate1;
  Isolate _isolate2;
  void runIsolateFn() async {
    printStartMethod('Start Method');

    stop();
    ReceivePort _receivePort = ReceivePort(); //port for this main isolate to receive messages.

    var message = IsolateObject<String>(
      value: "Hello from Isolate 1 - Class IsolateThree",
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

    int count = 0;
    while (count <= 500) {
      print('AAAA - $count');
      count++;
    }
  }

  static void runMethod1(IsolateObject isolate) async {
    var message = IsolateObject<String>(
      value: '${isolate.value} - ${DateTime.now()}',
      sender: isolate.sender,
    );

    printStartMethod('Method 1');

    int count = 0;
    while (count <= 5000) {
      print('BBBBBBBBBB - $count');
      count++;
    }

    isolate.sender.send(message);
  }

  static void runMethod2(SendPort isolate) async {
    var message = 'Ok! I finished here from Isolate 2';

    printStartMethod('Method 2');
    int count = 0;
    while (count <= 500) {
      print('CCCCCCCCCCCCCCCC - $count');
      count++;
    }

    isolate.send(message);
  }

  static void printStartMethod(String message) {
    print('Started running - $message - Class IsolateThree');
  }

  void stop() {
    if (_isolate1 != null) {
      print('killing isolate - Class IsolateThree');
      _isolate1.kill(priority: Isolate.immediate);
      _isolate1 = null;
    }

    if (_isolate2 != null) {
      print('killing isolate - Class IsolateThree');
      _isolate2.kill(priority: Isolate.immediate);
      _isolate2 = null;
    }
  }
}
