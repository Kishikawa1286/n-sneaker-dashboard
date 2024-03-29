import 'package:flutter/material.dart';

abstract class CommonStyle {
  static const themeColor = Color.fromARGB(255, 107, 154, 255);

  static const black = Colors.black;
  static const white = Colors.white;
  static const transparent = Colors.transparent;
  static const transparentBlack = Color.fromARGB(64, 0, 0, 0);
  static const grey = Color.fromARGB(255, 214, 214, 214);

  static const errorColor = Colors.red;
  static const linkColor = Colors.lightBlue;

  static const enabledColor = themeColor;
  static const disabledColor = Color.fromARGB(255, 155, 155, 155);

  static const scaffoldBackgroundColor = white;
}
