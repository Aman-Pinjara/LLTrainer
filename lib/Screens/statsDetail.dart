// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Backend/Timedb.dart';
import 'package:lltrainer/Models/TimeModel.dart';
import 'package:lltrainer/Screens/LLBasicStatList.dart';
import 'package:lltrainer/my_colors.dart';

class StatsDetail extends StatefulWidget {
  final String ll;
  final Color llMode;
  final PageController controller;

  const StatsDetail(
      {required this.controller,
      required this.llMode,
      required this.ll,
      Key? key})
      : super(key: key);

  @override
  State<StatsDetail> createState() => _StatsDetailState();
}

class _StatsDetailState extends State<StatsDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (widget.controller.hasClients) {
            widget.controller.animateToPage(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
          return false;
        },
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Material(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: IconButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        if (widget.controller.hasClients) {
                          widget.controller.animateToPage(0,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: widget.llMode,
                      )),
                ),
              ),
            ),
            Expanded(
              child: RawScrollbar(
                interactive: true,
                thumbColor: widget.llMode,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: FutureBuilder<List<TimeModel>>(
                    future: Timedb.instance.getllTime(widget.ll),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Text("Do some solves to see your time here"),
                          );
                        }
                        return GridView.builder(
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10.h,
                            crossAxisSpacing: 10.w,
                            crossAxisCount: 5,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TimesTile(snapshot.data![index], context);
                          },
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error Occured"),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
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
                  color: widget.llMode.withOpacity(1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                  )),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LLBasicStatList(
                            ll: widget.ll,
                            appbarcolor: widget.llMode,
                          )));
                },
                child: SizedBox(
                  height: 75.w,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    "All ${widget.ll}",
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
      ),
    );
  }

  Widget TimesTile(TimeModel time, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: InkWell(
        onTap: (() {
          showDialog(
              context: context,
              builder: ((context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time.time.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30.sp),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              SizedBox(
                                height: 70.h,
                                width: 70.h,
                                child: widget.ll == "ZBLL"
                                    ? SvgPicture.asset(
                                        "assets/ZBLL/${time.llcase}.svg")
                                    : Image.asset(
                                        "assets/${time.lltype}/${time.llcase}.png"),
                              ),
                              Text(
                                time.llcase,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                            ]),
                            Expanded(
                              child: Text(
                                "R U R' U' R' F R2 U R' U' R U R' F'",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.done, color: widget.llMode),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await Timedb.instance
                                        .deleteFromDb(time.id!);
                                    setState(() {});
                                    print("Deleted");
                                  },
                                  icon:
                                      Icon(Icons.delete, color: widget.llMode),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }));
        }),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          child: SizedBox(
            // height: 29.h,
            width: 47.w,
            child: Container(
              decoration: BoxDecoration(
                color: widget.llMode.withOpacity(1),
              ),
              child: Center(
                  child: Text(
                time.time.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: Theme.of(context).scaffoldBackgroundColor),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
