import 'package:flutter/material.dart';
import 'package:lltrainer/Screens/SelectAlgs/PllSelectList.dart';
import 'package:lltrainer/Screens/SelectAlgs/ZBLLSelectList.dart';
import 'package:provider/provider.dart';

import '../../MyProvider/LastLayerProvier.dart';

class Selection extends StatelessWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ll = Provider.of<LastLayerProvider>(context).ll;
    switch (ll) {
      case "ZBLL":
        return const ZBLLSelectList();
      default:
        return PllSelectList(ll: ll);
    }
  }
}
