import 'package:flutter/material.dart';

class LockScrollProvider extends ChangeNotifier {
  LockScrollProvider();
  bool dontScroll = false;
  bool isLockedByUser = false;
  void changeScroll({bool? lock}) {
    if (lock == null) {
      dontScroll = !dontScroll;
    } else {
      dontScroll = lock;
    }
    notifyListeners();
  }

  void changeIsLockedByUser({bool? lock}) {
    if (lock == null) {
      isLockedByUser = !isLockedByUser;
    } else {
      isLockedByUser = lock;
    }
    dontScroll = isLockedByUser;
    notifyListeners();
  }
}
