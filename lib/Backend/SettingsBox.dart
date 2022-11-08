import 'package:hive/hive.dart';

class SettingsBox {
  Future<int> getLLSelectPref(String ll) async {
    var box = await Hive.openBox("settings");
    final val = box.get(
      "selectpref$ll",
      defaultValue: 1,
    );
    return val;
  }
  Future<void> setLLSelectPref(String ll, int selection) async {
    var box = await Hive.openBox("settings");
    box.put(
      "selectpref$ll",
      selection,
    );
  }

  // Future<int> getStatOrder(String ll) async {
  //   var box = await Hive.openBox("settings");
  //   //ASC DESC
  //   final val = box.get(
  //     "statorder$ll",
  //     defaultValue: "DESC",
  //   );
  //   return val;
  // }
  // Future<void> setStatOrder(String ll, String order) async {
  //   var box = await Hive.openBox("settings");
  //   //ASC DESC
  //   box.put(
  //     "statorder$ll",
  //     order,
  //   );
  // }
}
