// ignore_for_file: prefer_const_constructors, must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:lltrainer/Models/TimeModel.dart';
import 'package:lltrainer/Screens/GraphPage.dart';
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
  final Color appbarcolor;
  final List<TimeModel> timeData;
  const LLBasicStatList(
      {required this.appbarcolor,
      required this.ll,
      Key? key,
      required this.timeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late List<String> templist;
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
    }
    final isZB = ll == "ZBLL";
    final List<LLViewModel> dataList = convertToLLviewmodel(templist, isZB);

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GraphPage(
                      modeColor: appbarcolor, graphData: timeData, title: ll)));
            },
            icon: Icon(Icons.bar_chart_rounded),
          ),
        ],
        child: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return isZB
                  ? ZBLLStatTile(
                      zbType: dataList[index],
                      zbTypeTimes: timeData
                          .where((element) => element.llcase
                              .startsWith("${dataList[index].name}-"))
                          .toList(),
                    )
                  : AlgStatTile(
                      ll: ll,
                      modeColor: appbarcolor,
                      curll: dataList[index],
                      timeData: timeData
                          .where((element) =>
                              element.llcase == dataList[index].name)
                          .toList(),
                    );
            },
            childCount: dataList.length,
          ),
        ),
      )),
    );
  }

  List<LLViewModel> convertToLLviewmodel(List<String> templist, bool isZB) {
    List<LLViewModel> times = [];
    if (!isZB) {
      for (var llcase in templist) {
        final statlist =
            timeData.where((element) => element.llcase == llcase).toList();
        final element = LLViewModel(
          img: "assets/$ll/$llcase.",
          name: llcase,
          avg: statlist.isNotEmpty
              ? (statlist.fold<double>(
                          0.00,
                          (previousValue, element) =>
                              (previousValue + element.time)) /
                      statlist.length)
                  .toStringAsFixed(2)
              : "--:--",
          best: statlist.isNotEmpty
              ? statlist[statlist.length - 1].time.toStringAsFixed(2)
              : "--:--",
        );
        times.add(element);
      }
    } else {
      for (var lltype in templist) {
        double avg = 0;
        double best = double.infinity;
        int lengthNonZero = 0;
        for (var llcase in ZBLLNAMES) {
          if (llcase.startsWith("$lltype-")) {
            final statlist =
                timeData.where((element) => element.llcase == llcase).toList();
            if (statlist.isNotEmpty) lengthNonZero++;
            avg += statlist.isNotEmpty
                ? statlist.fold<double>(
                        0,
                        (previousValue, element) =>
                            previousValue + element.time) /
                    statlist.length
                : 0;
            double temp = statlist.isNotEmpty
                ? statlist[statlist.length - 1].time
                : double.infinity;
            best = (temp < best) ? temp : best;
          }
        }
        final element = LLViewModel(
          img: "assets/$ll/$lltype.",
          name: lltype,
          avg: avg != 0 ? (avg / lengthNonZero).toStringAsFixed(2) : "--:--",
          best: (best != 0) && (best != double.infinity)
              ? best.toStringAsFixed(2)
              : "--:--",
        );
        times.add(element);
      }
    }

    times.sort((a, b) => -(a.avg != "--:--" ? double.parse(a.avg) : 0)
        .compareTo((b.avg != "--:--" ? double.parse(b.avg) : 0)));
    return times;
  }
}
