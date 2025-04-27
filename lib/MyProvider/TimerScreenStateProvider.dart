import 'package:flutter/material.dart';

class TimerScreenStateProvider extends ChangeNotifier {
  bool timeron = false;
  bool timerStarted = false;

  void updateTimeron(bool val) {
    timeron = val;
    notifyListeners();
  }
  void updateTimerStarted(bool val) {
    timerStarted = val;
    notifyListeners();
  }
}
