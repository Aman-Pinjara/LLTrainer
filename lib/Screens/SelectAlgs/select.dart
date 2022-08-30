import 'package:flutter/material.dart';
import 'package:lltrainer/Screens/SelectAlgs/pllselect.dart';
import 'package:lltrainer/Screens/SelectAlgs/zbllselect.dart';
import 'package:provider/provider.dart';

import '../../myProvider.dart';

class Selection extends StatelessWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ll = Provider.of<LastLayerProvider>(context).ll;
    switch (ll) {
      case "ZBLL":
        return const ZBLLSelect();
      default:
        return PllSelect(ll: ll);
    }
  }
}
