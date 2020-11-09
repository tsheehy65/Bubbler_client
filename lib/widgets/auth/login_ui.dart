import 'package:academind/inputWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

// import '../../inputWidget.dart';

class Login extends StatelessWidget {

  InputWidget myWidget;
  TextEditingController name = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;

  void _onPressed(String val) {
    if(val != null && val.length > 0) {
      print("Name is: $val");
    }
  }

  Future _speak() async{
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    var result = await flutterTts.speak('Welcome to bubbler ${name.text}');
  }

  void _inBtnPressed(BuildContext context) async {
    print('_isBtnPressed');
    if(name != null && name.text.trim().isNotEmpty && isAlphanumeric(name.text.trim())) {
      print("Text is: ${name.text}");
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _prefs.setString('name', name.text);

      await flutterTts.setSharedInstance(true);

      await flutterTts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
      ]);

      await _speak();

      // At this stage we need to push the name into the
      Navigator.of(context).pushNamedAndRemoveUntil('/ChatScreen',(Route<dynamic> route) => false);
    }
    else {
      if( myWidget == null ) {
        print('Widget null');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    myWidget = InputWidget(30.0, 0.0, name);
    return Column(
      children: <Widget>[
        Padding(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
        ),
        Column(
          children: <Widget>[
            ///holds email header and inputField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40, bottom: 10),
                  child: Text(
                    "User Name",
                    style: TextStyle(fontSize: 16, color: Color(0xFF999A9A)),
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    InputWidget(30.0, 0.0, name),
                    Padding(
                        padding: EdgeInsets.only(right: 50),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Text(
                                    'Enter your name to continue...',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Color(0xFFA0A0A0),
                                        fontSize: 12),
                                  ),
                                )),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                gradient: LinearGradient(
                                    colors: signInGradients,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                              ),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                onPressed: () => {_inBtnPressed(context)},
                                 child: ImageIcon(
                                    AssetImage("assets/ic_forward.png"),
                                    size: 40,
                                    color: Colors.white,
                                  ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
            // roundedRectButton("Let's get Started", signInGradients, false),
          ],
        )
      ],
    );
  }
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];