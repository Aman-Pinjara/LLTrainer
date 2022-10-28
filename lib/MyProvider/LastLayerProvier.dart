import 'package:flutter/material.dart';

class LastLayerProvider extends ChangeNotifier {
  LastLayerProvider();
  String ll = "PLL";
  int curMode = 0;
  void changeLL(String ll,int curMode) {
    this.ll = ll;
    this.curMode = curMode;
    notifyListeners();
  }
}
