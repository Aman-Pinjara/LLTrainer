// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/MyProvider/LastLayerProvier.dart';
import 'package:lltrainer/Utils/AlgSelectTile.dart';
import 'package:lltrainer/Utils/CustomAppBar.dart';
import 'package:lltrainer/llnames/PLL.dart';
import 'package:provider/provider.dart';

import '../../llnames/COLL.dart';
import '../../llnames/OLL.dart';
import '../../my_colors.dart';

class llSelectList extends StatelessWidget {
  final String ll;
  final PageController controller;
  llSelectList({required this.ll, required this.controller, Key? key})
      : super(key: key);
  final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];

  @override
  Widget build(BuildContext context) {
    late final List<String> templist;
    switch (ll) {
      case "PLL":
        templist = PLLNAMES;
        break;
      case "OLL":
        templist = OLLNAMES;
        break;
      case "COLL":
        templist = COLLNAMES;
        break;
      default:
        print("ll");
    }
    List<LLSelectViewModel> times = [];
    for (var llname in templist) {
      final element = LLSelectViewModel(
        img: "assets/$ll/$llname.png",
        name: llname,
        alg: "R U R' U' R' F R2 U R' U' R U R' F'",
      );
      times.add(element);
    }
    return Scaffold(
      body: SafeArea(
        child: CustomAppBar(
          appBarColor: _Mode[Provider.of<LastLayerProvider>(context).curMode],
          titleText: "Select $ll",
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
            }
          ),
          child: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return AlgSelectTile(curll: times[index]);
              },
              childCount: times.length,
            ),
          ),
        )
      ),
    );
  }
}
