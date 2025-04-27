import 'package:flutter/cupertino.dart';
import 'package:lltrainer/Backend/GenerateScramble.dart';
import 'package:lltrainer/Models/ScrambleData.dart';
import 'package:lltrainer/MyProvider/LastLayerProvier.dart';
import 'package:provider/provider.dart';

class CurrentScrambleProvider extends ChangeNotifier {
  ScrambleData? _scramble;

  Future<void> updateScramble(BuildContext context) async {
    String ll = Provider.of<LastLayerProvider>(context, listen: false).ll;
    _scramble = await GenerateScramble().scramble(ll, context);
    notifyListeners();
  }

  ScrambleData? get scramble {
    if (_scramble == null) {
      return null;
    }
    return _scramble;
  }
}
