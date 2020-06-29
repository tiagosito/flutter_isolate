import 'dart:isolate';

class IsolateOne {
  //Isolate
  Isolate _isolate;
  void runIsolateFn() async {
    //Kill Isolate
    stop();

    //Port for this main isolate to receive messages.
    ReceivePort _receivePort = ReceivePort();

    //Call Isolate processing
    _isolate = await Isolate.spawn(runIsolate, _receivePort.sendPort);

    //Response listener
    _receivePort.listen(
      (data) {
        if (data == null) {
          print('Oh nooo! Data not received!');
          //stop();
        } else {
          print(data);
        }

        stop();
      },
    );
  }

  static void runIsolate(SendPort isolate) async {
    //Do something here
    var message = 'Ok! I finished here from Isolate';

    //Return "Message"
    isolate.send(message);
  }

  void stop() {
    if (_isolate != null) {
      print('killing my isolate');
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
