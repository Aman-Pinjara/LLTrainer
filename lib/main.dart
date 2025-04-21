// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/MyProvider/ScrambleProvider.dart';
import 'package:lltrainer/MyProvider/SelectionListUpdateProvider.dart';
import 'package:lltrainer/MyProvider/SelectionStateProvider.dart';
import 'package:lltrainer/Screens/selectalg-screen/Selection.dart';
import 'package:lltrainer/Screens/timeview-screen/TimesViewPage.dart';
import 'package:lltrainer/custom_theme.dart';
import 'package:lltrainer/Screens/timer-screen/TimerScreen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'MyProvider/LastLayerProvier.dart';
import 'MyProvider/LockScrollProvier.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LockScrollProvider()),
    ChangeNotifierProvider(create: (_) => LastLayerProvider()),
    ChangeNotifierProvider(create: (_) => SelectionListUpdateProvider()),
    ChangeNotifierProvider(create: (_) => SelectionStateProvider()),
    ChangeNotifierProvider(create: (_) => ScrambleProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool dontScroll = Provider.of<LockScrollProvider>(context).dontScroll;
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) => MaterialApp(
        themeMode: ThemeMode.system,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        home: child,
      ),
      child: HomeLayout(
        dontScroll: dontScroll,
      ),
    );
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({
    Key? key,
    required this.dontScroll,
  }) : super(key: key);

  final bool dontScroll;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late PageController timeviewcontroller;
  late PageController timerselectcontroller;
  bool lockVertical = false;
  late List<Widget> horizontal;

  @override
  void dispose() {
    timeviewcontroller.dispose();
    timerselectcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    timerselectcontroller = PageController(initialPage: 1);
    timeviewcontroller = PageController();
    horizontal = [
      Selection(
        controller: timerselectcontroller,
      ),
      TimerScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: PageView(
        scrollDirection: Axis.vertical,
        physics: (widget.dontScroll || lockVertical)
            ? NeverScrollableScrollPhysics()
            : null,
        controller: timeviewcontroller,
        children: [
          PageView(
            onPageChanged: (value) {
              if (value == 1) {
                setState(() {
                  lockVertical = false;
                });
              } else {
                setState(() {
                  lockVertical = true;
                });
              }
            },
            physics: widget.dontScroll ? NeverScrollableScrollPhysics() : null,
            controller: timerselectcontroller,
            children: horizontal,
          ),
          TimesViewPage(
            controller: timeviewcontroller,
          )
        ],
      ),
    );
  }
}
