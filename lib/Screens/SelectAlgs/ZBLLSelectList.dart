import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lltrainer/Backend/Selectiondb.dart';
import 'package:lltrainer/Models/SelectionModel.dart';
import 'package:lltrainer/Models/ZBLLTileTypeModel.dart';
import 'package:lltrainer/Utils/CustomAppBar.dart';
import 'package:lltrainer/Utils/ZBLLSelectTile.dart';
import 'package:lltrainer/llnames/ZBLL.dart';
import 'package:lltrainer/my_colors.dart';
import 'package:provider/provider.dart';

import '../../MyProvider/LastLayerProvier.dart';

class ZBLLSelectList extends StatelessWidget {
  final PageController controller;
  final ll = "ZBLL";
  const ZBLLSelectList({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.hasClients) {
          controller.animateToPage(
            1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
            child: CustomAppBar(
          appBarColor: ZBLLTHEME,
          titleText: "Select ZBLL",
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                if (controller.hasClients) {
                  controller.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              }),
          child: FutureBuilder<List<SelectionModel>>(
            future: getllTypeTile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ZBLLSelectTile(
                        curlltype: snapshot.data![index],
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                );
              }
              if (snapshot.hasError) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Center(
                        child: Text("There was some error"),
                      ),
                    ],
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Center(
                      child: Text("Loading"),
                    ),
                  ],
                ),
              );
            },
          ),
        )),
      ),
    );
  }

  Future<List<SelectionModel>> getllTypeTile() async {
    List<SelectionModel> timesType = [];
    final List<SelectionModel> llFromDB =
        await Selectiondb.instance.getSelections(ll);
    for (var llname in ZBLLNAMESTYPE) {
      final List<SelectionModel> newListTemp = llFromDB
          .where((element) => element.llcase.startsWith(llname))
          .toList();
      int tempval = newListTemp[0].selectionType;
      for (var element in newListTemp) {
        if (element.selectionType == tempval) {
          continue;
        }
        tempval = 0;
        break;
      }
      final element = SelectionModel(
        llcase: llname,
        lltype: ll,
        selectionType: tempval,
      );
      // img: "assets/ZBLL/$llname.svg",
      timesType.add(element);
    }
    return timesType;
  }
}
