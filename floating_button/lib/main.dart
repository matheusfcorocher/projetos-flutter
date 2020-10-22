import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static const platform = const MethodChannel('floating_button');

  int count = 0;

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((methodCall) {
      if(methodCall.method == "touch") {
        setState(() {
          count += 1;
        });
      }
      return null;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Floating Button Demo'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("$count",
                    textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50
                ),
              ),
              RaisedButton(
                child: Text('Create'),
                onPressed: () {
                  platform.invokeListMethod('create');
                },
              ),
              RaisedButton(
                child: Text('Show'),
                onPressed: () {
                  platform.invokeListMethod('show');
                },
              ),
              RaisedButton(
                child: Text('Hide'),
                onPressed: () {
                  platform.invokeListMethod('hide');
                },
              ),
              RaisedButton(
                child: Text('Verify'),
                onPressed: () {
                  platform.invokeMethod("isShowing").then( (isShowing) {
                      print(isShowing);
                  });
                },
              ),
              RaisedButton(
                child: Text('Restart Count'),
                onPressed: () {
                  setState(() {
                    count = 0;
                  });
                },
              ),
            ],
          ),
      ),
    );
  }


}


