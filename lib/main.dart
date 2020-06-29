import 'package:flutter/material.dart';
import 'package:flutter_isolate/isolate_one.dart';
import 'package:flutter_isolate/isolate_three.dart';
import 'package:flutter_isolate/isolate_two.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(
        title: 'Flutter Isolate',
      ),
    );
  }
}

class Home extends StatefulWidget {
  final String title;

  const Home({Key key, this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              IsolateOne().runIsolateFn();
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.blur_on,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  Text('Isolate 1'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          GestureDetector(
            onTap: () {
              IsolateTwo().runIsolateFn();
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.apps,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                  Text('Isolate 2'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 50,
          ),
          GestureDetector(
            onTap: () {
              IsolateThree().runIsolateFn();
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.apps,
                      size: 50,
                      color: Colors.purple,
                    ),
                  ),
                  Text('Isolate 3'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
