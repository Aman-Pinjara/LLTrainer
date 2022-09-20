// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  final Widget child;
  final Widget leading;
  final String titleText;
  final Color appBarColor;
  const CustomAppBar(
      {required this.leading,
      required this.child,
      required this.titleText,
      required this.appBarColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawScrollbar(
        radius: Radius.circular(5),
        thumbColor: appBarColor,
        thumbVisibility: true,
        interactive: true,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: appBarColor,
              leading: leading,
              pinned: true,
              expandedHeight: 130.h,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                title: Text(
                  titleText,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/cubeabstract.jpg'),
                      fit: BoxFit.fitWidth,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    ),
                  ),
                ),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}
