import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Models/LLViewModel.dart';

class AlgStatTile extends StatelessWidget {
  final bool isZB;
  final LLViewModel curll;
  const AlgStatTile({required this.curll, required this.isZB, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Container(
        decoration: BoxDecoration(
          boxShadow:const [
              BoxShadow(blurRadius: 1, color: Colors.black, offset: Offset(0,1), blurStyle: BlurStyle.normal),
            ],
            borderRadius: BorderRadius.circular(6.0),
            color: Theme.of(context).primaryColorDark),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 60.h,
              width: 60.h,
              child: !isZB
                  ? Image.asset(
                      "${curll.img}png",
                      fit: BoxFit.cover,
                    )
                  : SvgPicture.asset(
                      "${curll.img}svg",
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Text(
                curll.name,
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
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
                        curll.avg,
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
                        curll.best,
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
    );
  }
}
