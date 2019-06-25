import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepOrange,
  accentColor: Colors.deepPurple,
  buttonColor: Colors.deepPurple,
);

final ThemeData _iOSTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  accentColor: Colors.blue,
  buttonColor: Colors.blue,
);

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.android ? _androidTheme : _iOSTheme;
}

BoxDecoration getTealGradient(){
  return BoxDecoration(
      gradient: new LinearGradient(
        colors: [
          Colors.teal,
          Colors.tealAccent,
        ],
        begin: FractionalOffset.bottomLeft,
        end: FractionalOffset.topRight,
      )
  );
}

BoxDecoration getBlueGradient() {
  return new BoxDecoration(
    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
    gradient: new LinearGradient(
      colors: [
        Color(0xAF039BE5),
        Color(0xBD81D4FA),
      ],
      begin: FractionalOffset.bottomLeft,
      end: FractionalOffset.topRight,
    ),);
}
