import 'package:flutter/material.dart';

class MyTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0x002d2d2d),
    primaryColor: const Color(0xffffffff),
    primaryColorDark: const Color(0x006b6b6b),
    primaryColorLight: const Color(0x006b6b6b),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffffffff),
    primaryColor: const Color(0x00000000),
    primaryColorDark: const Color(0xd9D9D9D9),
    primaryColorLight: const Color(0x00676767),
  );
}
