// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Screens/allalgstats.dart';
import 'package:lltrainer/my_colors.dart';

class StatesDetail extends StatelessWidget {
  final String ll;
  final Color llMode;
  final List<String> times;
  const StatesDetail(
      {required this.llMode, required this.times, required this.ll, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            height: 25.h,
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                  ll,
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  crossAxisCount: 5,
                ),
                itemCount: times.length,
                itemBuilder: (BuildContext context, int index) {
                  return TimesTile(times[index], context);
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.8),
                    spreadRadius: 10,
                    blurRadius: 6,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                border: Border.all(
                    color: Colors.black.withOpacity(0.5), width: 0.5),
                color: llMode.withOpacity(1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                )),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => llDetail(ll: ll)));
              },
              child: SizedBox(
                height: 75.w,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "All $ll",
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
            )),
    );
  }

  Widget TimesTile(String time, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        child: SizedBox(
          // height: 29.h,
          width: 47.w,
          child: Container(
            decoration: BoxDecoration(
              color: llMode.withOpacity(1),
            ),
            child: Center(
                child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: Theme.of(context).scaffoldBackgroundColor),
            )),
          ),
        ),
      ),
    );
  }
}
