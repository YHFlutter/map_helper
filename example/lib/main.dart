import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_helper/map_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _result = 'Unknown';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _openMap() async{
    try {
      String key = textController.text;
      Address address = Address(address: key, lat: "23.4334", lng: "100.0312");
      String? result = await MapHelper.openMap(address);
      setState(() {
        _result = result.toString();
      });
    } on PlatformException {
      setState(() {
        _result = 'Failed to run platform api.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('open map result : $_result\n'),
              TextField(
                autofocus: true,
                controller: textController,
              ),
            ],
          ),
        ),
        floatingActionButton:FloatingActionButton(
          onPressed: _openMap,
          tooltip: 'Increment',
          child: new Icon(Icons.add_location),
        ),
      ),
    );
  }
}
