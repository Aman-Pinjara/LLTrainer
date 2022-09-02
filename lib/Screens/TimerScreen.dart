// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/my_colors.dart';
import 'package:provider/provider.dart';

import '../MyProvider/LastLayerProvier.dart';
import '../MyProvider/LockScrollProvier.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String pllScramble = "R U R' U' R' F R2 U' R' U' R U R' F'";

  final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];
  final _ModeName = ["PLL", "OLL", "COLL", "ZBLL"];
  bool isLock = false;
  @override
  Widget build(BuildContext context) {
    int curMode = Provider.of<LastLayerProvider>(context).curMode;
    String ll = Provider.of<LastLayerProvider>(context).ll;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _Mode[curMode],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 68.h,
                  child: Center(
                    child: SizedBox(
                      width: 200.w,
                      child: Text(
                        textAlign: TextAlign.center,
                        pllScramble,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 17.5.sp,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Text(
                        "3.45",
                        style: TextStyle(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor.withOpacity(1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Avg 5 :", style: TextStyle(color: _Mode[curMode], fontSize: 17.sp, fontWeight: FontWeight.w500),),
                          Text("12.56", style: TextStyle(color: _Mode[curMode], fontSize: 17.sp, fontWeight: FontWeight.w500),),
                        ],
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Avg :", style: TextStyle(color: _Mode[curMode], fontSize: 17.sp, fontWeight: FontWeight.w500),),
                          Text("12.56", style: TextStyle(color: _Mode[curMode], fontSize: 17.sp, fontWeight: FontWeight.w500),),
                        ],
                      )
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: _Mode[curMode],
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11.2.r),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  _Mode[curMode].withOpacity(1))),
                          child: Text(
                            "View",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: PHONETHEME == ThemeMode.light
                                  ? Colors.white.withOpacity(1)
                                  : Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black.withOpacity(0.5), width: 0.5),
                    color: _Mode[curMode].withOpacity(1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    )),
                child: InkWell(
                  onLongPress: () {
                    setState(() {
                      isLock = !isLock;
                      Provider.of<LockScrollProvider>(context, listen: false)
                          .changeScroll();
                    });
                  },
                  onTap: () {
                    setState(() {
                      if (!isLock) {
                        curMode = (curMode + 1) % _Mode.length;
                      }
                      Provider.of<LastLayerProvider>(context, listen: false)
                          .changeLL(_ModeName[curMode], curMode);
                    });
                  },
                  child: SizedBox(
                    height: 75.w,
                    width: double.infinity,
                    child: Center(
                        child: Text(
                      ll,
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.bold,
                        color: PHONETHEME == ThemeMode.light
                            ? Colors.white.withOpacity(1)
                            : Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(1),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: 72.h,
              right: 5.w,
              child: Icon(
                Icons.lock,
                color: isLock
                    ? Theme.of(context).primaryColorDark.withOpacity(1)
                    : Colors.transparent,
                size: 25.sp,
              ))
        ]),
      ),
    );
  }
}
