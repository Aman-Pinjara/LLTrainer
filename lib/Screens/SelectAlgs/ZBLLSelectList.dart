import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/Models/ZBLLTileTypeModel.dart';
import 'package:lltrainer/Utils/AlgSelectTile.dart';
import 'package:lltrainer/Utils/ZBLLSelectTile.dart';
import 'package:lltrainer/llnames/ZBLL.dart';

class ZBLLSelectList extends StatelessWidget {
  const ZBLLSelectList({Key? key}) : super(key: key);

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
                    "Select ZBLL",
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
                itemCount: timesType.length,
                itemBuilder: (BuildContext context, int index) {
                  return ZBLLSelectTile(curlltype: timesType[index]);
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
