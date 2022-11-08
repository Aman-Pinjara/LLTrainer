import 'package:flutter/cupertino.dart';
import 'package:lltrainer/Models/ScrambleData.dart';

class ScrambleProvider extends ChangeNotifier {
  List<String> caselist = [];
  ScrambleData? scramble;

  void updateList(List<String> list) {
    caselist = list;
  }

  void resetList() {
    caselist = [];
  }
}
