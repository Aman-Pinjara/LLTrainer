import 'package:flutter/material.dart';
import 'package:lltrainer/Screens/SelectAlgs/llSelectList.dart';
import 'package:lltrainer/Screens/SelectAlgs/ZBLLSelectList.dart';
import 'package:provider/provider.dart';

import '../../MyProvider/LastLayerProvier.dart';

class Selection extends StatelessWidget {
  final PageController controller;
  const Selection({required this.controller,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ll = Provider.of<LastLayerProvider>(context).ll;
    switch (ll) {
      case "ZBLL":
        return ZBLLSelectList(controller: controller,);
      default:
        return llSelectList(ll: ll,controller: controller,);
    }
  }
}
