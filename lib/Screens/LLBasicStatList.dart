// ignore_for_file: prefer_const_constructors, must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:lltrainer/Utils/ZBLLStatTile.dart';
import 'package:lltrainer/Models/LLViewModel.dart';
import 'package:lltrainer/Utils/AlgStatTile.dart';
import 'package:lltrainer/Utils/CustomAppBar.dart';
import 'package:lltrainer/llnames/COLL.dart';
import 'package:lltrainer/llnames/OLL.dart';
import 'package:lltrainer/llnames/PLL.dart';
import 'package:lltrainer/llnames/ZBLL.dart';

class LLBasicStatList extends StatelessWidget {
  final String ll;
  late List<LLViewModel> times;
  final Color appbarcolor;
  LLBasicStatList({required this.appbarcolor, required this.ll, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //initialize the times List
    late final templist;
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
      case "ZBLL":
        templist = ZBLLNAMESTYPE;
        break;
      default:
        print("ll");
    }
    times = convertToLLviewmodel(templist);
    final isZB = ll == "ZBLL";

    return Scaffold(
      body: SafeArea(
          child: CustomAppBar(
        appBarColor: appbarcolor,
        titleText: "All $ll",
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        child: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return isZB
                  ? ZBLLStatTile(zbType: times[index])
                  : AlgStatTile(curll: times[index]);
            },
            childCount: times.length,
          ),
        ),
      )),
    );
  }

  List<LLViewModel> convertToLLviewmodel(List<String> templist) {
    List<LLViewModel> times = [];
    for (var llname in templist) {
      final element = LLViewModel(
          img: "assets/$ll/$llname.", name: llname, avg: "0.00", best: "0.00");
      times.add(element);
    }
    return times;
  }
}
