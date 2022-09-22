// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:lltrainer/AlgLists/DefautlAlgs.dart';
import 'package:lltrainer/Backend/Selectiondb.dart';
import 'package:lltrainer/Models/LLSelectViewModel.dart';
import 'package:lltrainer/MyProvider/LastLayerProvier.dart';
import 'package:lltrainer/Utils/AlgSelectSaveBtn.dart';
import 'package:lltrainer/Utils/AlgSelectTile.dart';
import 'package:lltrainer/Utils/CustomAppBar.dart';
import 'package:lltrainer/llnames/PLL.dart';
import 'package:provider/provider.dart';

import '../../Models/SelectionModel.dart';
import '../../llnames/COLL.dart';
import '../../llnames/OLL.dart';
import '../../my_colors.dart';

class llSelectList extends StatelessWidget {
  final String ll;
  final PageController controller;
  llSelectList({required this.ll, required this.controller, Key? key})
      : super(key: key);
  final _Mode = [PLLTHEME, OLLTHEME, COLLTHEME, ZBLLTHEME];
  final List<SelectionModel> algUpdateSelect = [];

  @override
  Widget build(BuildContext context) {
    int curcolorindex = Provider.of<LastLayerProvider>(context).curMode;
    late final List<String> currllNameList;
    late Map<String, String> defaultAlg;
    switch (ll) {
      case "PLL":
        currllNameList = PLLNAMES;
        break;
      case "OLL":
        currllNameList = OLLNAMES;
        break;
      case "COLL":
        currllNameList = COLLNAMES;
        break;
      default:
        print("ll");
    }
    switch (ll) {
      case "PLL":
        defaultAlg = DefaultAlgs.pll;
        break;
      case "OLL":
        defaultAlg = DefaultAlgs.oll;
        break;
      case "COLL":
        defaultAlg = DefaultAlgs.coll;
        break;
      default:
        print("ll");
    }
    List<LLSelectViewModel> times = [];
    for (var llname in currllNameList) {
      final element = LLSelectViewModel(
        img: "assets/$ll/$llname.png",
        name: llname,
        alg: defaultAlg[llname]!,
      );
      times.add(element);
    }
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
        floatingActionButton: AlgSelectSaveBtn(controller: controller),
        body: SafeArea(
            child: CustomAppBar(
          appBarColor: _Mode[curcolorindex],
          titleText: "Select $ll",
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
            },
          ),
          child: FutureBuilder<List<SelectionModel>>(
            future: getllList(currllNameList, ll),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return AlgSelectTile(
                        curll: snapshot.data![index],
                        defaultAlg: defaultAlg[snapshot.data![index].llcase]!,
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                );
              }
              if (snapshot.hasError) {
                return SliverList(
                    delegate: SliverChildListDelegate(
                        [const Center(child: Text("There was some error"))]));
              }
              return SliverList(
                  delegate: SliverChildListDelegate(
                      [const Center(child: Text("Loading"))]));
            },
          ),
        )),
      ),
    );
  }

  Future<List<SelectionModel>> getllList(List<String> curllNameList, String ll) async {
    List<SelectionModel> times = [];
    for (var llname in curllNameList) {
      final element =
          SelectionModel(llcase: llname, lltype: ll, selectionType: 0);
      times.add(element);
    }
    List<SelectionModel> fromDB = await Selectiondb.instance.getSelections(ll);
    for (var dbelement in fromDB) {
      times[times.indexWhere((element) => element.llcase == dbelement.llcase)] =
          dbelement;
    }
    return times;
  }
}
