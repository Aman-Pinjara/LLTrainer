// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lltrainer/Backend/Selectiondb.dart';
import 'package:lltrainer/Backend/Timedb.dart';
import 'package:lltrainer/LLScrambleData/DefautlAlgs.dart';
import 'package:lltrainer/Models/TimeModel.dart';
import 'package:lltrainer/MyProvider/CurrentScrambleProvider.dart';
import 'package:lltrainer/MyProvider/LastLayerProvier.dart';
import 'package:lltrainer/MyProvider/LockScrollProvier.dart';
import 'package:lltrainer/MyProvider/ScrambleProvider.dart';
import 'package:lltrainer/MyProvider/TimerScreenStateProvider.dart';
import 'package:lltrainer/Utils/CustomHorizontalLoader.dart';
import 'package:lltrainer/my_colors.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];
  final _ModeName = ["PLL", "OLL", "COLL", "ZBLL"];
  late Stopwatch time;
  int timerColor = 0;
  int? toDeleteId;
  bool viewTaped = false;

  @override
  void initState() {
    super.initState();
    time = Stopwatch();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ScrambleProvider>(context, listen: false).resetList();
      final scrambleProvider =
          Provider.of<CurrentScrambleProvider>(context, listen: false);
      if (scrambleProvider.scramble == null) {
        scrambleProvider.updateScramble(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> textcolors = [
      Theme.of(context).colorScheme.onSecondary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.primaryContainer,
    ];
    int curMode = Provider.of<LastLayerProvider>(context).curMode;
    return GestureDetector(
      onLongPressDown: (details) async {
        final timerOn =
            Provider.of<TimerScreenStateProvider>(context, listen: false)
                .timeron;
        if (!timerOn && !viewTaped) {
          setState(() {
            timerColor = 1;
          });
        }
        if (viewTaped) viewTaped = false;
        if (timerOn) {
          await _stopTimer(context);
        }
      },
      onLongPressCancel: () {
        if (!Provider.of<TimerScreenStateProvider>(context, listen: false)
            .timeron) {
          setState(() {
            timerColor = 0;
          });
        }
      },
      onTapCancel: () {
        if (!Provider.of<TimerScreenStateProvider>(context, listen: false)
            .timeron) {
          setState(() {
            timerColor = 0;
          });
        }
      },
      onPanCancel: () {
        if (!Provider.of<TimerScreenStateProvider>(context, listen: false)
            .timeron) {
          setState(() {
            timerColor = 0;
          });
        }
      },
      onLongPress: () {
        //change timer color to green
        if (!Provider.of<TimerScreenStateProvider>(context, listen: false)
            .timeron) {
          setState(() {
            Provider.of<LockScrollProvider>(context, listen: false)
                .changeScroll(lock: true);
            timerColor = 2;
            Provider.of<TimerScreenStateProvider>(context, listen: false)
                .updateTimeron(true);
          });

          time.reset();
        }
      },
      onLongPressUp: () {
        //start timer
        if (!Provider.of<TimerScreenStateProvider>(context, listen: false)
            .timerStarted) {
          setState(() {
            timerColor = 0;
            time.start();
          });
          Provider.of<TimerScreenStateProvider>(context, listen: false)
              .updateTimerStarted(true);
          Timer.periodic(const Duration(milliseconds: 100), (t) {
            if (time.elapsedMilliseconds < 60000 && time.isRunning) {
              setState(() {});
            } else {
              time.stop();
              Provider.of<TimerScreenStateProvider>(context, listen: false)
                  .updateTimerStarted(false);
              t.cancel();
              Provider.of<LockScrollProvider>(context, listen: false)
                  .changeScroll(
                      lock: Provider.of<LockScrollProvider>(context,
                              listen: false)
                          .isLockedByUser);
              Provider.of<TimerScreenStateProvider>(context, listen: false)
                  .updateTimeron(false);
            }
          });
        }
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Center(
                child: Text(
                  Provider.of<TimerScreenStateProvider>(context).timeron
                      ? (time.elapsedMilliseconds / 1000).toStringAsFixed(1)
                      : (time.elapsedMilliseconds / 1000).toStringAsFixed(3),
                  style: TextStyle(
                    fontSize: 60.sp,
                    fontWeight: FontWeight.bold,
                    color: textcolors[timerColor],
                  ),
                ),
              ),
            ),
            Visibility(
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: !Provider.of<TimerScreenStateProvider>(context).timeron,
              child: FutureBuilder<String>(
                  future: getxavg(_ModeName[curMode], 10),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return timesView(curMode, "Avg 10: ", snapshot.data!);
                    }
                    if (snapshot.hasError) {
                      return Text("error");
                    }
                    return timesView(curMode, "Avg 10: ", "Loading");
                  }),
            ),
            Visibility(
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: !Provider.of<TimerScreenStateProvider>(context).timeron,
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
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: !Provider.of<TimerScreenStateProvider>(context).timeron,
              child: GestureDetector(
                onLongPressDown: (_) {
                  viewTaped = true;
                },
                child: prevActionButtons(curMode, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _stopTimer(BuildContext context) async {
    setState(() {
      time.stop();
    });
    String ll = Provider.of<LastLayerProvider>(context, listen: false).ll;
    toDeleteId = await Timedb.instance.insertInDB(
      TimeModel(
        lltype: ll,
        llcase: (Provider.of<CurrentScrambleProvider>(context, listen: false)
                .scramble!)
            .llcase,
        time: double.parse((time.elapsedMilliseconds / 1000).toStringFixed(2)),
      ),
    );
    await Provider.of<CurrentScrambleProvider>(context, listen: false)
        .updateScramble(context);
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
                      child: Provider.of<CurrentScrambleProvider>(context)
                                  .scramble !=
                              null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${Provider.of<CurrentScrambleProvider>(context).scramble!.ll} ${Provider.of<CurrentScrambleProvider>(context).scramble!.llcase}",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 70.h,
                                      width: 70.h,
                                      child: _ModeName[curMode] == "ZBLL"
                                          ? SvgPicture.asset(
                                              "assets/ZBLL/${Provider.of<CurrentScrambleProvider>(context).scramble!.llcase}.svg")
                                          : Image.asset(
                                              "assets/${Provider.of<CurrentScrambleProvider>(context).scramble!.ll}/${Provider.of<CurrentScrambleProvider>(context).scramble!.llcase}.png"),
                                    ),
                                    Expanded(
                                      child: FutureBuilder<String?>(
                                          future: Selectiondb.instance
                                              .getSelectionAlg(
                                                  _ModeName[curMode],
                                                  Provider.of<CurrentScrambleProvider>(
                                                          context)
                                                      .scramble!
                                                      .llcase),
                                          builder: (context, snapshot) {
                                            late final String defalg;
                                            switch (_ModeName[curMode]) {
                                              case "PLL":
                                                defalg = DefaultAlgs
                                                    .pll[Provider.of<
                                                            CurrentScrambleProvider>(
                                                        context)
                                                    .scramble!
                                                    .llcase]!;
                                                break;
                                              case "OLL":
                                                defalg = DefaultAlgs
                                                    .oll[Provider.of<
                                                            CurrentScrambleProvider>(
                                                        context)
                                                    .scramble!
                                                    .llcase]!;
                                                break;
                                              case "COLL":
                                                defalg = DefaultAlgs
                                                    .coll[Provider.of<
                                                            CurrentScrambleProvider>(
                                                        context)
                                                    .scramble!
                                                    .llcase]!;
                                                break;
                                              case "ZBLL":
                                                defalg = DefaultAlgs
                                                    .zbll[Provider.of<
                                                            CurrentScrambleProvider>(
                                                        context)
                                                    .scramble!
                                                    .llcase]!;
                                                break;
                                            }
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data!,
                                                textAlign: TextAlign.center,
                                              );
                                            }
                                            if (!snapshot.hasData) {
                                              return Text(
                                                defalg,
                                                textAlign: TextAlign.center,
                                              );
                                            }
                                            if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return Text("Some error occured");
                                            }
                                            return CircularProgressIndicator();
                                          }),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.done,
                                          color: _Mode[curMode]),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : CustomHorizontalLoader(),
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
}

extension on double {
  String toStringFixed(int limit) {
    final val = toStringAsFixed(limit + 1);
    return val.substring(0, val.length - 1);
  }
}
