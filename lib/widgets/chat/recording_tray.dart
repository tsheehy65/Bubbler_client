import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordingTray extends StatelessWidget {
  RecordingTray({Key key, Color this.color, Duration this.duration, this.onSend, this.onCancel}) : super(key : key);

  Duration duration =  Duration();
  Color color = Colors.green;
  final ValueChanged<Duration> onSend;
  final ValueChanged<Duration> onCancel;

  void _onClicked() {
    print('RecordingTray _onSend');
    onSend(duration);
  }

  void _onCancel() {
    // FIX me
    print('RecordingTray _onCancel');
    onCancel(duration);
  }

  void _startTimer() {

  }
  String twoDigits(int n) => n >= 10 ? "$n" : "0$n";

  String _printDuration(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: new Icon(Icons.cancel), onPressed: _onCancel, color: Colors.red,),
        Padding(padding: new EdgeInsets.all(5.0),
            child: new Text(_printDuration(duration), style: new TextStyle(fontSize: 24.0, color: color),
            )
        ),
        IconButton(icon: new Icon(Icons.send), onPressed: _onClicked, color: Colors.green,),
      ],
    );
  }

}
