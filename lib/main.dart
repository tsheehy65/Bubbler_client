import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/chat_screen.dart';
import 'package:permission/permission.dart';

/// Forces portrait-only mode application-wide
/// Use this Mixin on the main app widget i.e. app.dart
/// Flutter's 'App' has to extend Stateless widget.
///
/// Call `super.build(context)` in the main build() method
/// to enable portrait only mode
mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }
}

/// Forces portrait-only mode on a specific screen
/// Use this Mixin in the specific screen you want to
/// block to portrait only mode.
///
/// Call `super.build(context)` in the State's build() method
/// and `super.dispose();` in the State's dispose() method
mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }

  @override
  void dispose() {
    _enableRotation();
  }
}

/// blocks rotation; sets orientation to: portrait
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget with PortraitModeMixin  {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _userName;
  static const TITLE = 'Bubbler Chat Demo';

  final String webSocketAddress = '';
  final int websocketPort = 5000;
  final String stompLogin = 'admin';
  final String stompPwd = 'pass';

  Future<String> _getName() async {
    final SharedPreferences prefs = await _prefs;
    final String name = (prefs.getString('name'));

    return name;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    requestPermissions().then((msg) => print('$msg'));

    _getName().then((value) => _userName = value);

    assert(() {
      _prefs.then((val) => val.setString('name', ''));
      _userName = '';
      return true;
    }());

    Widget _defaultHome = LoginPage(title: TITLE);
    if(_userName != null && _userName.length > 0) {
      _defaultHome = ChatScreen();
    }
    return MaterialApp(
      title: TITLE,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: <String, WidgetBuilder> {
        // All available pages
        '/Home' : (BuildContext context) => new LoginPage(title: TITLE,),
        '/ChatScreen' : (BuildContext context) => new ChatScreen(),
      },

      home: _defaultHome,
    );
  }

  // Permissions.
  Future<String>requestPermissions() async {
    List<PermissionName> permissionNames = [];
    permissionNames.add(PermissionName.Camera);
    permissionNames.add(PermissionName.Microphone);
    permissionNames.add(PermissionName.Location);
    permissionNames.add(PermissionName.Storage);
    permissionNames.add(PermissionName.Internet);
    String message = '';
    var permissions = await Permission.requestPermissions(permissionNames);
    permissions.forEach((permission) {
      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
      print('Permissions: \n$message');
    });
    return message;
  }
}
