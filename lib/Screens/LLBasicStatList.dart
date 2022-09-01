// ignore_for_file: prefer_const_constructors, must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Models/LLViewModel.dart';
import 'package:lltrainer/Utils/AlgStatTile.dart';
import 'package:lltrainer/llnames/COLL.dart';
import 'package:lltrainer/llnames/OLL.dart';
import 'package:lltrainer/llnames/PLL.dart';
import 'package:lltrainer/llnames/ZBLL.dart';

class LLBasicStatList extends StatelessWidget {
  final String ll;
  late List<LLViewModel> times;
  LLBasicStatList({required this.ll, Key? key}) : super(key: key);

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
        templist = ZBLLNAMES;
        break;
      default:
        print("ll");
    }
    times = convertToLLviewmodel(templist);
    final isZB = ll == "ZBLL";

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(top: 27.h, left: 19.w),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              String.fromCharCode(Icons.arrow_back_rounded.codePoint),
              style: TextStyle(
                inherit: false,
                color: Theme.of(context).primaryColorLight.withOpacity(1),
                fontSize: 30.sp,
                fontWeight: FontWeight.w900,
                fontFamily: Icons.arrow_back_rounded.fontFamily,
                package: Icons.arrow_back_rounded.fontPackage,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  thickness: 2,
                  color: Colors.black,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "All $ll",
                    style:
                        TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 2,
                  color: Colors.black,
                )),
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Expanded(
            child: Scrollbar(
              trackVisibility: true,
              thumbVisibility: true,
              thickness: 5,
              interactive: true,
              radius: Radius.circular(12),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: times.length,
                itemBuilder: (BuildContext context, int index) {
                  return AlgStatTile(curll: times[index], isZB: isZB);
                },
              ),
            ),
          ),
        ],
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
