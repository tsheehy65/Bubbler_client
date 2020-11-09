import 'dart:io';
import 'package:academind/widgets/chat/recording_tray.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission/permission.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/android_encoder.dart';
import 'package:flutter/services.dart' show rootBundle;

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class NewMessage extends StatefulWidget {
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _userName;
  FlutterSound flutterSound;
  Future<Directory> _appDocumentsDirectory;
  File outputFile;

  final _controller = TextEditingController();
  String _message = '';
  bool _isRecording = false;

  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final double topRight = 30.0;
  final double bottomRight = 10.0;

  bool error = false;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    flutterSound = new FlutterSound();

    requestPermission();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  void _requestAppDocumentsDirectory() async {
    setState(() {
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
      print('Dir is: $_appDocumentsDirectory');
    });
  }

  void start() async {
    print('_MyAppState.start... ');

    _requestAppDocumentsDirectory();
    Directory  tempDir = await this._appDocumentsDirectory;
    outputFile = File ('${tempDir.path}/flutter_sound-tmp.aac');
    String path = await flutterSound.startRecorder(uri: outputFile.path, codec: t_CODEC.CODEC_AAC,);
    print('... ${outputFile.path} ... ');

    _speech
        .listen(locale: selectedLang.code)
        .then((result) {
      print('Bubbler.start => result ${result}');
      _isRecording = true;
    });
  }

    void cancel() {
      flutterSound.stopRecorder();
      _speech.cancel().then((result) => setState(() => _isListening = result));
    }

    void stop() {
      flutterSound.stopRecorder();
      print(flutterSound.audioState);
      _speech.stop().then((result) => setState(() => _isListening = result));
    }

    void onSpeechAvailability(bool result) =>
        setState(() => _speechRecognitionAvailable = result);

    void onCurrentLocale(String locale) {
      print('Bubbler.onCurrentLocale... $locale');
      setState(
              () => selectedLang = languages.firstWhere((l) => l.code == locale));
    }

    void onRecognitionStarted() => setState(() => _isListening = true);

    void onRecognitionResult(String text) => setState(() => _controller.text = transcription = text);

    void onRecognitionComplete() => setState(() => _isListening = false);

    // Setting/Requesting permissions at run time
    requestPermission() async {
      final res =
      await Permission.requestSinglePermission(PermissionName.Microphone);
      print(res);
    }

    void _onCancel(Duration duration) {
      print('In cancel');
      cancel();
      _message = '';
      _isRecording = false;
      _controller.text = '';
      flutterSound.stopRecorder();
    }

    @override
    Widget build(BuildContext context) {
      // OK so we need a widget that contains a text area, a hidden cancel timer
      // send, and the start recording.
      //
      // When user clicks tha start recording button the button is hidden and the
      // widget containing the cancel timer and send will be shown.
      //
      // While the audio is being translated the
      return Container(
        color: Colors.teal,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  scrollPadding: EdgeInsets.all(5.0),
                  // style: TextStyle(height: 0.5),
                  controller: _controller,
                  maxLines: null,
                  expands: false,
                  decoration: InputDecoration(

                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: "Type a message",
                    hintStyle: TextStyle(color: Color(0xFF121212), fontSize: 12),
/*
                  errorText: validateUserName(onNameChanged.text),
                  errorStyle: TextStyle(color: Colors.red),*/
                  ),
                ),
              ),
              Visibility(
                visible: !_isRecording,
                child: IconButton(
                  icon: Icon(Icons.mic),
                  color: Colors.white,
                  onPressed: start,
                ),
              ),
              Visibility(
                visible: _isRecording,
                child: RecordingTray(onSend: null, onCancel: _onCancel, duration: new Duration(minutes: 1),),
              ),
            ],
          ),
        ),
      );
      /*

      Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      color: Colors.teal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: TextField(
              style: TextStyle(backgroundColor: Colors.white),
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
        ],
      ),
    );*/
  }
}
