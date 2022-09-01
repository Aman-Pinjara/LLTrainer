import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/Utils/AlgSelectTile.dart';
import 'package:lltrainer/llnames/PLL.dart';

import '../../llnames/COLL.dart';
import '../../llnames/OLL.dart';

class PllSelectList extends StatelessWidget {
  final String ll;
  const PllSelectList({required this.ll, Key? key}) : super(key: key);

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
      appBar: AppBar(
        toolbarHeight: 50.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(top: 27.h, left: 19.w),
          child: GestureDetector(
            onTap: () {},
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
                const Expanded(
                    child: Divider(
                  thickness: 2,
                  color: Colors.black,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select PLL",
                    style:
                        TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
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
              thumbVisibility: true,
              thickness: 5,
              interactive: true,
              radius: const Radius.circular(12),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: times.length,
                itemBuilder: (BuildContext context, int index) {
                  return AlgSelectTile(curll: times[index]);
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
