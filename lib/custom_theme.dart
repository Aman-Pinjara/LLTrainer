import 'package:flutter/material.dart';

class MyTheme {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light, 
      primary: Color(0xfff5f5f5), 
      onPrimary:  Color(0xfff5f5f5), 
      secondary:  Color(0xffd9d9d9), 
      onSecondary:  Color(0xff2d2d2d), 
      error:  Color(0xfffb7272), 
      onError: Color(0xff2d2d2d), 
      background: Color(0xffd9d9d9), 
      onBackground: Color(0xff2d2d2d), 
      surface:  Color(0xff3b3b3b), 
      onSurface: Color(0xff676767),
      primaryContainer: Color(0xff8bf04d),
      secondaryContainer: Color(0xfffb7272),
      tertiaryContainer: Color(0xfff0e04d)
    ),
    scaffoldBackgroundColor: const Color(0xffffffff),
    primaryColor: const Color(0xff000000),
    primaryColorDark: const Color(0xffD9D9D9),
    primaryColorLight: const Color(0xff676767),
  );


  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark, 
      primary: Color(0xff2d2d2d), 
      onPrimary:  Color(0xfff5f5f5), 
      secondary:  Color(0xff6b6b6b), 
      onSecondary:  Color(0xfff5f5f5), 
      error:  Color(0xffD76262), 
      onError: Color(0xfff5f5f5), 
      background: Color(0xff6b6b6b), 
      onBackground: Color(0xffc3c3c3), 
      surface:  Color(0xff3b3b3b), 
      onSurface: Color(0xff676767),
      primaryContainer: Color(0xff6fc13c),
      secondaryContainer: Color(0xffd76262),
      tertiaryContainer: Color(0xffdacb4a)
    ),
    scaffoldBackgroundColor: const Color(0xff2d2d2d),
    primaryColor: const Color(0xffffffff),
    primaryColorDark: const Color(0xff6b6b6b),
    primaryColorLight: const Color(0xff6b6b6b),
  );
}
