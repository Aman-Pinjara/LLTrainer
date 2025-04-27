// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lltrainer/Backend/Timedb.dart';
import 'package:lltrainer/Models/TimeModel.dart';
import 'package:lltrainer/MyProvider/LastLayerProvier.dart';
import 'package:lltrainer/Screens/stats-screen/LLBasicStatList.dart';
import 'package:lltrainer/Utils/CustomCircularLoader.dart';
import 'package:lltrainer/my_colors.dart';
import 'package:provider/provider.dart';

import '../../LLScrambleData/DefautlAlgs.dart';
import '../../Backend/Selectiondb.dart';

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

  late List<TimeModel> times;
  final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];

  @override
  Widget build(BuildContext context) {
    int curcolorindex = Provider.of<LastLayerProvider>(context).curMode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _Mode[curcolorindex],
        title: Text(
          " ${widget.ll} Stats",
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        scrolledUnderElevation: 0,
        leading: IconButton(
            alignment: Alignment.centerLeft,
            onPressed: () {
              if (widget.controller.hasClients) {
                widget.controller.animateToPage(1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).scaffoldBackgroundColor,
            )),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (widget.controller.hasClients) {
            widget.controller.animateToPage(
              1,
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
            Expanded(
              child: RawScrollbar(
                interactive: true,
                thumbColor: widget.llMode,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: FutureBuilder<List<TimeModel>>(
                    future: Timedb.instance.getllTime(widget.ll),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        times = snapshot.data!;
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
                      return Center(
                        child: CustomCircularLoader(
                          radius: 20,
                          dotRadius: 10,
                        ),
                      );
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
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => LLBasicStatList(
                  //           ll: widget.ll,
                  //           appbarcolor: widget.llMode,
                  //         )));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LLBasicStatList(
                          appbarcolor: widget.llMode,
                          timeData: times,
                          ll: widget.ll)));
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
                              child: FutureBuilder<String?>(
                                  future: Selectiondb.instance
                                      .getSelectionAlg(widget.ll, time.llcase),
                                  builder: (context, snapshot) {
                                    late final String defalg;
                                    switch (widget.ll) {
                                      case "PLL":
                                        defalg = DefaultAlgs.pll[time.llcase]!;
                                        break;
                                      case "OLL":
                                        defalg = DefaultAlgs.oll[time.llcase]!;
                                        break;
                                      case "COLL":
                                        defalg = DefaultAlgs.coll[time.llcase]!;
                                        break;
                                      case "ZBLL":
                                        defalg = DefaultAlgs.zbll[time.llcase]!;
                                        break;
                                    }
                                    if (!snapshot.hasData) {
                                      return Text(
                                        snapshot.data ?? defalg,
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Text("Some error occured");
                                    }
                                    return CircularProgressIndicator();
                                  }),
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
                    fontSize: 15.sp,
                    color: Theme.of(context).scaffoldBackgroundColor),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
