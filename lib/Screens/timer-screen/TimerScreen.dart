// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lltrainer/MyProvider/CurrentScrambleProvider.dart';
import 'package:lltrainer/MyProvider/ScrambleProvider.dart';
import 'package:lltrainer/MyProvider/TimerScreenStateProvider.dart';
import 'package:lltrainer/Screens/timer-screen/TimerWidget.dart';
import 'package:lltrainer/Utils/CustomHorizontalLoader.dart';
import 'package:lltrainer/my_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../MyProvider/LastLayerProvier.dart';
import '../../MyProvider/LockScrollProvier.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key, required this.controller}) : super(key: key);
  final PageController controller;
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];
  final _ModeName = ["PLL", "OLL", "COLL", "ZBLL"];

  @override
  void initState() {
    super.initState();
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
    int curMode = Provider.of<LastLayerProvider>(context).curMode;
    String ll = Provider.of<LastLayerProvider>(context).ll;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: _Mode[curMode],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: !Provider.of<TimerScreenStateProvider>(context).timeron,
              child: algView(curMode, context, ll),
            ),
            Expanded(
              child: Stack(
                children: [
                  TimerWidget(),
                  Positioned(
                    top: 3,
                    right: 0,
                    child: Visibility(
                      visible:
                          !Provider.of<TimerScreenStateProvider>(context).timeron,
                      child: lockIcon(context),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: !Provider.of<TimerScreenStateProvider>(context).timeron,
              child: algChangeButton(curMode, context, ll),
            ),
          ],
        ),
      ),
    );
  }

  Icon lockIcon(BuildContext context) {
    return Icon(
      Icons.lock,
      color: Provider.of<LockScrollProvider>(context).isLockedByUser
          ? Theme.of(context).primaryColorDark.withOpacity(1)
          : Colors.transparent,
      size: 25.sp,
    );
  }

  Widget algChangeButton(int curMode, BuildContext context, String ll) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              if (widget.controller.hasClients &&
                  !Provider.of<LockScrollProvider>(context, listen: false)
                      .dontScroll) {
                widget.controller.animateToPage(0,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              } else {
                Fluttertoast.showToast(
                    msg: "Unlock the UI by holding the alg button");
              }
            },
            icon: Icon(LucideIcons.penLine),
            iconSize: 30.sp,
          ),
          SizedBox(
            width: 27.w,
          ),
          Expanded(
            child: GestureDetector(
              onLongPress: () {
                Provider.of<LockScrollProvider>(context, listen: false)
                    .changeIsLockedByUser();
              },
              onTap: () {
                !Provider.of<LockScrollProvider>(context, listen: false)
                        .isLockedByUser
                    ? setState(() {
                        curMode = (curMode + 1) % _Mode.length;
                        Provider.of<LastLayerProvider>(context, listen: false)
                            .changeLL(_ModeName[curMode], curMode);
                        Provider.of<ScrambleProvider>(context, listen: false)
                            .resetList();
                        Provider.of<CurrentScrambleProvider>(context,
                                listen: false)
                            .updateScramble(context);
                      })
                    : null;
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black.withOpacity(0.5), width: 0.5),
                  color: _Mode[curMode].withOpacity(1),
                  borderRadius: BorderRadius.all(Radius.circular(25.r)),
                ),
                child: Center(
                    child: Text(
                  ll,
                  style: TextStyle(
                    fontSize: 30.sp,
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
          SizedBox(
            width: 27.w,
          ),
          IconButton(
            onPressed: () {
              if (widget.controller.hasClients &&
                  !Provider.of<LockScrollProvider>(context, listen: false)
                      .dontScroll) {
                widget.controller.animateToPage(2,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              } else {
                Fluttertoast.showToast(
                    msg: "Unlock the UI by holding the alg button");
              }
            },
            icon: Icon(LucideIcons.chartLine),
            iconSize: 30.sp,
          ),
        ],
      ),
    );
  }

  Container algView(int curMode, BuildContext context, String ll) {
    final scramble = context.watch<CurrentScrambleProvider>().scramble;
    return Container(
      decoration: BoxDecoration(
        color: _Mode[curMode],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 85.h,
          minWidth: double.infinity,
          // maxHeight: 30.0,
          // maxWidth: 30.0,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 50.w),
            child: scramble != null
                ? Text(
                    textAlign: TextAlign.center,
                    scramble.scramble,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 17.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : CustomHorizontalLoader(),
          ),
        ),
      ),
    );
  }
}
