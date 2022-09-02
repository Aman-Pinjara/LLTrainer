// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/AlgLists/temptimelist.dart';
import 'package:lltrainer/Screens/StatsDetail.dart';
import 'package:lltrainer/my_colors.dart';

class StatsChoose extends StatelessWidget {
  final PageController controller;
  const StatsChoose({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 37.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "STATISTICS",
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).primaryColor.withOpacity(1),
                          ),
                        ),
                        SizedBox(
                          height: 124.h,
                          width: 112.w,
                          child: Image.asset('assets/image.png'),
                        )
                      ],
                    ),
                  ),
                  llTile("PLL", PLLTHEME.withOpacity(1), context),
                  llTile("OLL", OLLTHEME.withOpacity(1), context),
                  llTile("COLL", COLLTHEME.withOpacity(1), context),
                  llTile("ZBLL", ZBLLTHEME.withOpacity(1), context),
                ],
              ),
            ),
            Positioned(
              top: 27.h,
              left: 19.w,
              child: GestureDetector(
                onTap: () {
                  if (controller.hasClients) {
                    controller.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
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
          ],
        ),
      ),
    );
  }

  Widget llTile(String ll, Color color, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: SizedBox(
        width: double.infinity,
        height: 80.h,
        child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StatsDetail(
                          ll: ll,
                          llMode: color,
                          times: ll == "PLL" ? plltimes : olltimes,
                        ),),
              );
            },
            style: ButtonStyle(
              alignment: Alignment.center,
              elevation: MaterialStateProperty.all(3),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              side: MaterialStateProperty.all(BorderSide(
                  color: Colors.black.withOpacity(0.35), width: 0.3)),
              backgroundColor: MaterialStateProperty.all(color),
            ),
            child: Text(
              ll,
              style: TextStyle(
                  fontSize: 40.sp, color: Colors.white.withOpacity(1)),
            )),
      ),
    );
  }
}
