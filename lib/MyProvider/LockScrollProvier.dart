import 'package:flutter/material.dart';

class LockScrollProvider extends ChangeNotifier {
  LockScrollProvider();
  bool dontScroll = false;
  void changeScroll({bool? lock}) {
    if (lock == null) {
      dontScroll = !dontScroll;
    } else {
      dontScroll = lock;
    }
    notifyListeners();
  }
}
