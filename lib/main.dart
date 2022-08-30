// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Screens/SelectAlgs/pllselect.dart';
import 'package:lltrainer/Screens/SelectAlgs/select.dart';
import 'package:lltrainer/Screens/statschoose.dart';
import 'package:lltrainer/custom_theme.dart';
import 'package:lltrainer/Screens/timer_screen.dart';
import 'package:lltrainer/myProvider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LockScrollProvider()),
      ChangeNotifierProvider(create: (_) => LastLayerProvider())
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool dontScroll = Provider.of<LockScrollProvider>(context).dontScroll;
    final PageController _controller = PageController(initialPage: 1);
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
          physics: dontScroll ? NeverScrollableScrollPhysics() : null,
          controller: _controller,
          children: [
            Selection(),
            TimerScreen(),
            StatesChoose(),
          ],
        ),
      ),
    );
  }
}
