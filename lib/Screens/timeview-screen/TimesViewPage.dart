import 'package:flutter/material.dart';
import 'package:lltrainer/MyProvider/LastLayerProvier.dart';
import 'package:lltrainer/Screens/timeview-screen/StatsDetail.dart';
import 'package:provider/provider.dart';

import '../../my_colors.dart';

class TimesViewPage extends StatelessWidget {
  final PageController controller;
  const TimesViewPage({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ll = Provider.of<LastLayerProvider>(context).ll;
    final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];
    final curMode = Provider.of<LastLayerProvider>(context).curMode;
    return StatsDetail(controller: controller,llMode: _Mode[curMode], ll: ll);
  }
}
