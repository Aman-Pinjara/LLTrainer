// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/MyProvider/ScrambleProvider.dart';
import 'package:lltrainer/MyProvider/SelectionListUpdateProvider.dart';
import 'package:lltrainer/MyProvider/SelectionStateProvider.dart';
import 'package:lltrainer/Screens/SelectAlgs/Selection.dart';
import 'package:lltrainer/Screens/TimesViewPage.dart';
import 'package:lltrainer/custom_theme.dart';
import 'package:lltrainer/Screens/TimerScreen.dart';
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
    final PageController _controller = PageController(initialPage: 1);
    final PageController timeviewcontroller = PageController();
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        home: child,
      ),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: PageView(
          scrollDirection: Axis.vertical,
          physics: dontScroll ? NeverScrollableScrollPhysics() : null,
          controller: timeviewcontroller,
          children: [
            PageView(
              physics: dontScroll ? NeverScrollableScrollPhysics() : null,
              controller: _controller,
              children: [
                Selection(
                  controller: _controller,
                ),
                TimerScreen(),
              ],
            ),
            TimesViewPage(
              controller: timeviewcontroller,
            )
          ],
        ),
      ),
    );
  }
}
