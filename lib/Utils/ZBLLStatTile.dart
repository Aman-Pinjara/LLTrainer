import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Models/LLViewModel.dart';
import 'package:lltrainer/Utils/ZBLLTypeStatTile.dart';

import '../llnames/ZBLL.dart';
import '../my_colors.dart';

class ZBLLStatTile extends StatelessWidget {
  final LLViewModel zbType;
  const ZBLLStatTile({required this.zbType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("hellot this is zb stat tile");
    List<LLViewModel> times = [];
    bool conout = false;
    for (var element in ZBLLNAMES) {
      if (element.startsWith("${zbType.name}-")) {
        LLViewModel temp = LLViewModel(
            img: "assets/ZBLL/$element.svg",
            name: element,
            avg: "00.00",
            best: "00.00");
        times.add(temp);
        conout = true;
        continue;
      }
      if (conout) break;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: GestureDetector(
        onTap: () {
          //redirect
          dialog(context, times);
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey,
                    offset: Offset(0, 1),
                    blurStyle: BlurStyle.normal),
              ],
              borderRadius: BorderRadius.circular(6.0),
              color: Theme.of(context).primaryColorDark),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 60.h,
                width: 60.h,
                child: SvgPicture.asset(
                  "${zbType.img}svg",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Text(
                  zbType.name,
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Avg",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          zbType.avg,
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Best",
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          zbType.best,
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dialog(BuildContext context, List<LLViewModel> times) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: ZBLLTHEME,
                            )),
                        Text(
                          zbType.name,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: RawScrollbar(
                        thumbColor: ZBLLTHEME,
                        thumbVisibility: true,
                        radius: const Radius.circular(5),
                        thickness: 6,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: times.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ZBLLTypeStatTile(zb: times[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
