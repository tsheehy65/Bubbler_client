import 'package:flutter/material.dart';
import 'dart:async';

class CountDown extends StatefulWidget {
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  Timer _timer;
  int _start = 59;

  void startTimer() {
    if( _timer != null ) {
      _timer.cancel();
      _timer = null;
    }
    else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) { });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Timer test")),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              startTimer();
            },
            child: Text("start"),
          ),
          Text("$_start")
        ],
      ),
    );
  }

}