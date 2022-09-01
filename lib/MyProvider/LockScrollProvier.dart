import 'package:flutter/material.dart';

class LockScrollProvider extends ChangeNotifier {
  LockScrollProvider();
  bool dontScroll = false;
  void changeScroll() {
    dontScroll = !dontScroll;
    notifyListeners();
  }
}