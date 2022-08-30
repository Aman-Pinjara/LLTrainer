import 'package:flutter/material.dart';

final ThemeMode PHONETHEME = ThemeMode.system;

const Color PLLTHEME = Color(0x006dd2ba);
const Color OLLTHEME = Color(0x00DDC570);
const Color COLLTHEME = Color(0x007BD26D);
const Color ZBLLTHEME = Color(0x00EF6868);
const Color WHITECOMPLE = Color(0x00D9D9D9);

Color LEARNED =
  PHONETHEME == ThemeMode.light ? const Color(0xff8BF04D) :const Color(0xff6FC13C);

Color LEARNING =
  PHONETHEME == ThemeMode.light ? const Color(0xffF0E04D) :const Color(0xffDACB4A);

Color NOLEARN =
  PHONETHEME == ThemeMode.light ? const Color(0xffFB7272) :const Color(0xffD76262);
