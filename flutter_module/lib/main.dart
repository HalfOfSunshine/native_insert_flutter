import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
// const MyApp({super.key});
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final MethodChannel _oneMethodChannel = const MethodChannel('one_page');
  final MethodChannel _twoMethodChannel = const MethodChannel('two_page');
  final BasicMessageChannel _messageChannel =
      BasicMessageChannel('messageChannel', StandardMessageCodec());

  String pageIndex = 'one';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageChannel.setMessageHandler((message) {
      print('收到来自iOS的$message');
      return Future(() => null);
    });
    _oneMethodChannel.setMethodCallHandler((call) {
      print(
          '接收到了iOS的信息，method = ${call.method},arguments = ${call.arguments.toString()}');
      if (call.method == 'setTitle') {
        pageIndex = call.arguments.toString();
        setState(() {});
      }
      return Future(() => null);  
    });
    _twoMethodChannel.setMethodCallHandler((call) {
      print(
          '接收到了iOS的信息，method = ${call.method},arguments = ${call.arguments.toString()}');
      if (call.method == 'setTitle') {
        pageIndex = call.arguments.toString();
        setState(() {});
      }
      return Future(() => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: pageIndex,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _rootPage(pageIndex),

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  Widget _rootPage(String pageIndex) {
    switch (pageIndex) {
      case 'one':
        return Scaffold(
            appBar: AppBar(
              title: Text(pageIndex),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _oneMethodChannel.invokeMapMethod('exit');
                  },
                  child: Text(pageIndex),
                ),
                TextField(
                  onChanged: (String str) {
                    _messageChannel.send(str);
                  },
                )
              ],
            ));
      case 'two':
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  _twoMethodChannel.invokeMapMethod('exit');
                },
                child: Text(pageIndex)),
          ),
        );
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  MethodChannel('default_page').invokeMapMethod('exit');
                },
                child: Text(pageIndex)),
          ),
        );
    }
  }
}
