import 'package:flutter/material.dart';
import 'package:lltrainer/Models/SelectionModel.dart';

class SelectionListUpdateProvider extends ChangeNotifier {
  List<SelectionModel> selectionUpdateList = [];

  void addSelection(SelectionModel newSelectionModel) {
    int temp = selectionUpdateList
        .indexWhere((element) => element.llcase == newSelectionModel.llcase);
    if (temp == -1) {
      selectionUpdateList.add(newSelectionModel);
    } else {
      selectionUpdateList.removeAt(temp);
      selectionUpdateList.insert(temp, newSelectionModel);
    }
    notifyListeners();
  }

  void addAllSelection(List<SelectionModel> newSelectionModel) {
    for (var element in newSelectionModel) {
      int temp = selectionUpdateList
          .indexWhere((elementin) => elementin.llcase == element.llcase);
      if (temp == -1) {
        selectionUpdateList.add(element);
      } else {
        selectionUpdateList.removeAt(temp);
        selectionUpdateList.insert(temp, element);
      }
    }
    notifyListeners();
  }

  void replaceSelection(SelectionModel selection, int idx) {}

  void emptySelection() {
    selectionUpdateList = [];
    notifyListeners();
  }
}
