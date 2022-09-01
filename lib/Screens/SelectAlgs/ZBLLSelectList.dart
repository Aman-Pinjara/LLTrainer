import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Models/ZBLLTileTypeModel.dart';
import 'package:lltrainer/Utils/CustomAppBar.dart';
import 'package:lltrainer/Utils/ZBLLSelectTile.dart';
import 'package:lltrainer/llnames/ZBLL.dart';
import 'package:lltrainer/my_colors.dart';
import 'package:provider/provider.dart';

import '../../MyProvider/LastLayerProvier.dart';

class ZBLLSelectList extends StatelessWidget {
  final PageController controller;
  const ZBLLSelectList({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ZBLLTileTypeModel> timesType = [];
    for (var llname in ZBLLNAMESTYPE) {
      final element = ZBLLTileTypeModel(
        img: "assets/ZBLL/$llname.svg",
        name: llname,
      );
      timesType.add(element);
    }
    return Scaffold(
      body: SafeArea(
          child: CustomAppBar(
        appBarColor: ZBLLTHEME,
        titleText: "Select ZBLL",
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onBackground),
            onPressed: () {
              if (controller.hasClients) {
                controller.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            }),
        child: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ZBLLSelectTile(curlltype: timesType[index],);
            },
            childCount: timesType.length,
          ),
        ),
      )),
    );
  }
}
