// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lltrainer/AlgLists/DefautlAlgs.dart';
import 'package:lltrainer/Backend/Selectiondb.dart';
import 'package:lltrainer/Backend/Timedb.dart';
import 'package:lltrainer/Models/ScrambleData.dart';
import 'package:lltrainer/Models/TimeModel.dart';
import 'package:lltrainer/Screens/SelectAlgs/llSelectList.dart';
import 'package:lltrainer/my_colors.dart';
import 'package:provider/provider.dart';

import '../Backend/GenerateScramble.dart';
import '../MyProvider/LastLayerProvier.dart';
import '../MyProvider/LockScrollProvier.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late ScrambleData scramble;

  final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];
  final _ModeName = ["PLL", "OLL", "COLL", "ZBLL"];
  bool isLock = false;
  bool timeron = false;
  late Stopwatch time;
  int timerColor = 0;
  int? toDeleteId;

  @override
  void initState() {
    super.initState();
    time = Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> textcolors = [
      Theme.of(context).colorScheme.onSecondary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.primaryContainer,
    ];
    int curMode = Provider.of<LastLayerProvider>(context).curMode;
    String ll = Provider.of<LastLayerProvider>(context).ll;
    scramble = timeron ? scramble : GenerateScramble().scramble(ll);
    return GestureDetector(
      onTap: () async {
        //stop timer if started
        if (timeron) {
          setState(() {
            time.stop();
          });
          // print("test ${scramble.llcase}");
          toDeleteId = await Timedb.instance.insertInDB(TimeModel(
            lltype: ll,
            llcase: scramble.llcase,
            time: double.parse(
                (time.elapsedMilliseconds / 1000).toStringFixed(2)),
          ));
        }
      },
      onLongPress: () {
        //change timer color to green
        setState(() {
          Provider.of<LockScrollProvider>(context, listen: false)
              .changeScroll(lock: true);
          timerColor = 2;
          timeron = true;
        });

        time.reset();
      },
      onLongPressEnd: (details) {
        //start timer
        setState(() {
          timerColor = 0;
          time.start();
        });
        Timer.periodic(Duration(milliseconds: 100), (t) {
          if (time.elapsedMilliseconds < 60000 && time.isRunning) {
            setState(() {});
          } else {
            time.stop();
            t.cancel();
            setState(() {
              Provider.of<LockScrollProvider>(context, listen: false)
                  .changeScroll(lock: isLock);
              timeron = false;
            });
          }
        });
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            Column(
              children: [
                Visibility(
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  visible: !timeron,
                  child: algView(curMode, context, ll),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Center(
                          child: Text(
                            timeron
                                ? (time.elapsedMilliseconds / 1000)
                                    .toStringAsFixed(1)
                                : (time.elapsedMilliseconds / 1000)
                                    .toStringAsFixed(3),
                            style: TextStyle(
                              fontSize: 60.sp,
                              fontWeight: FontWeight.bold,
                              color: textcolors[timerColor],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        visible: !timeron,
                        child: FutureBuilder<String>(
                            future: getxavg(_ModeName[curMode], 10),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return timesView(
                                    curMode, "Avg 10: ", snapshot.data!);
                              }
                              if (snapshot.hasError) {
                                return Text("error");
                              }
                              return timesView(curMode, "Avg 10: ", "Loading");
                            }),
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainState: true,
                        maintainAnimation: true,
                        visible: !timeron,
                        child: FutureBuilder<String>(
                            future: getxavg(_ModeName[curMode], 20),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return timesView(
                                  curMode,
                                  "Avg 20: ",
                                  snapshot.data!,
                                );
                              }
                              if (snapshot.hasError) {
                                return Text("error");
                              }
                              return timesView(curMode, "Avg 20: ", "Loading");
                            }),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Visibility(
                          maintainSize: true,
                          maintainState: true,
                          maintainAnimation: true,
                          visible: !timeron,
                          child: prevActionButtons(curMode, context)),
                    ],
                  ),
                ),
                Visibility(
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true,
                    visible: !timeron,
                    child: algChangeButton(curMode, context, ll)),
              ],
            ),
            Positioned(
                top: 72.h,
                right: 5.w,
                child: Visibility(visible: !timeron, child: lockIcon(context)))
          ]),
        ),
      ),
    );
  }

  Icon lockIcon(BuildContext context) {
    return Icon(
      Icons.lock,
      color: isLock
          ? Theme.of(context).primaryColorDark.withOpacity(1)
          : Colors.transparent,
      size: 25.sp,
    );
  }

  Container algChangeButton(int curMode, BuildContext context, String ll) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 0.5),
        color: _Mode[curMode].withOpacity(1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      child: InkWell(
        onLongPress: () {
          setState(() {
            isLock = !isLock;
            Provider.of<LockScrollProvider>(context, listen: false)
                .changeScroll(lock: isLock);
          });
        },
        onTap: () {
          !isLock
              ? setState(() {
                  curMode = (curMode + 1) % _Mode.length;
                  Provider.of<LastLayerProvider>(context, listen: false)
                      .changeLL(_ModeName[curMode], curMode);
                })
              : null;
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
                  : Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
            ),
          )),
        ),
      ),
    );
  }

  Row prevActionButtons(int curMode, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async {
            if (toDeleteId != null) {
              await Timedb.instance.deleteFromDb(toDeleteId!);
              toDeleteId = null;
              setState(() {
                time.reset();
              });
              Fluttertoast.showToast(
                msg: "Deleted successfully",
                backgroundColor: Colors.black.withOpacity(0.5),
              );
            } else {
              Fluttertoast.showToast(
                msg: "Nothing to Delete",
                backgroundColor: Colors.black.withOpacity(0.5),
              );
            }
          },
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
          onPressed: () async {
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
                            "${scramble.ll} ${scramble.llcase}",
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w700),
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 70.h,
                                width: 70.h,
                                child: _ModeName[curMode] == "ZBLL"
                                    ? SvgPicture.asset(
                                        "assets/ZBLL/${scramble.llcase}.svg")
                                    : Image.asset(
                                        "assets/${scramble.ll}/${scramble.llcase}.png"),
                              ),
                              Expanded(
                                child: FutureBuilder<String?>(
                                    future: Selectiondb.instance
                                        .getSelectionAlg(_ModeName[curMode],
                                            scramble.llcase),
                                    builder: (context, snapshot) {
                                      late final String defalg;
                                      switch (_ModeName[curMode]) {
                                        case "PLL":
                                          defalg =
                                              DefaultAlgs.pll[scramble.llcase]!;
                                          break;
                                        case "OLL":
                                          defalg =
                                              DefaultAlgs.oll[scramble.llcase]!;
                                          break;
                                        case "COLL":
                                          defalg = DefaultAlgs
                                              .coll[scramble.llcase]!;
                                          break;
                                        case "ZBLL":
                                          defalg = DefaultAlgs
                                              .zbll[scramble.llcase]!;
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
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.done, color: _Mode[curMode]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }));
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.2.r),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all(_Mode[curMode].withOpacity(1))),
          child: Text(
            "View",
            style: TextStyle(
              fontSize: 17.sp,
              color: PHONETHEME == ThemeMode.light
                  ? Colors.white.withOpacity(1)
                  : Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
            ),
          ),
        ),
      ],
    );
  }

  Future<String> getxavg(String lltype, int x) async {
    final times = await Timedb.instance.getXlenghtdata(lltype, x);
    if (times.length < x) {
      return "--:--";
    }
    return (times.fold<double>(
                0, (previousValue, element) => previousValue + element.time) /
            x)
        .toStringFixed(3);
  }

  Padding timesView(int curMode, String name, String val) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  color: _Mode[curMode],
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              val,
              style: TextStyle(
                  color: _Mode[curMode],
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ));
  }

  Container algView(int curMode, BuildContext context, String ll) {
    return Container(
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
              scramble.scramble,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17.5.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

extension on double {
  String toStringFixed(int limit) {
    final val = toStringAsFixed(limit + 1);
    return val.substring(0, val.length - 1);
  }
}
