import 'package:flutter/material.dart';

class LastLayerProvider extends ChangeNotifier {
  LastLayerProvider();
  String ll = "PLL";
  void changeLL(String ll) {
    this.ll = ll;
    notifyListeners();
  }
}