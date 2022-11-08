import 'package:flutter/material.dart';
import 'package:lltrainer/Models/SelectionModel.dart';

class SelectionStateProvider extends ChangeNotifier {
  Map<String, SelectionModel> currStateChanges = {};

  void addState(SelectionModel newState) {
    currStateChanges[newState.llcase] = newState;
  }

  void clearState() {
    currStateChanges.clear();
  }
}
