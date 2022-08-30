import 'package:flutter/material.dart';

class LockScrollProvider extends ChangeNotifier {
  LockScrollProvider();
  bool dontScroll = false;
  void changeScroll() {
    dontScroll = !dontScroll;
    notifyListeners();
  }
}

class LastLayerProvider extends ChangeNotifier {
  LastLayerProvider();
  String ll = "PLL";
  void changeLL(String ll) {
    this.ll = ll;
    notifyListeners();
  }
}
