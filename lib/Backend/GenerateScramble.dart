// ignore_for_file: constant_identifier_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lltrainer/LLScrambleData/OLLAlgs.dart';
import 'package:lltrainer/LLScrambleData/PLLAlgs.dart';
import 'package:lltrainer/LLScrambleData/COLLAlgs.dart';
import 'package:lltrainer/LLScrambleData/ZBLLAlgs.dart';
import 'package:lltrainer/Backend/Selectiondb.dart';
import 'package:lltrainer/Backend/SettingsBox.dart';
import 'package:lltrainer/Models/ScrambleData.dart';
import 'package:lltrainer/MyProvider/ScrambleProvider.dart';
import 'package:lltrainer/llnames/OLL.dart';
import 'package:lltrainer/llnames/PLL.dart';
import 'package:lltrainer/llnames/ZBLL.dart';
import 'package:lltrainer/llnames/COLL.dart';
import 'package:provider/provider.dart';

class GenerateScramble {
  Future<ScrambleData> scramble(String ll, BuildContext context) async {
    final Algmap = llgetmap(ll);
    if (Provider.of<ScrambleProvider>(context, listen: false)
        .caselist
        .isEmpty) {
      await getCasesFromDb(ll, context);
    }
    List<String> a =
        Provider.of<ScrambleProvider>(context, listen: false).caselist;
    String llcase = a[Random().nextInt(a.length)];
    String alg = getRandomAlg(llcase, Algmap, ll);
    // print("case $llcase");
    // print("alg $alg");
    final scramble =
        ScrambleData(scramble: modify(alg), ll: ll, llcase: llcase);
    return scramble;
  }

  static Future<void> getCasesFromDb(String ll, BuildContext context) async {
    int selection = await SettingsBox().getLLSelectPref(ll);
    late List<String> llnames;
    switch (ll) {
      case "PLL":
        llnames = PLLNAMES;
        break;
      case "OLL":
        llnames = OLLNAMES;
        break;
      case "COLL":
        llnames = COLLNAMES;
        break;
      case "ZBLL":
        llnames = ZBLLNAMES;
        break;
      default:
        llnames = PLLNAMES;
        break;
    }
    if (selection == 0) {
      Provider.of<ScrambleProvider>(context, listen: false).updateList(llnames);
      return;
    }
    final llnamesfromDB =
        (await Selectiondb.instance.filterSelections(ll, selection))
            .map((e) => e.llcase)
            .toList();
    // print(llnamesfromDB);
    if (llnamesfromDB.isEmpty) {
      Fluttertoast.showToast(msg: "Current selected Set is Empty");
      Provider.of<ScrambleProvider>(context, listen: false).updateList(llnames);
      return;
    }
    Provider.of<ScrambleProvider>(context, listen: false)
        .updateList(llnamesfromDB);
  }

  static dynamic llgetmap(String ll) {
    switch (ll) {
      case "PLL":
        return PLLAlgs;
      case "OLL":
        return OLLAlgs;
      case "COLL":
        return COLLAlgs;
      case "ZBLL":
        return ZBLLAlgs;
      default:
        print(ll);
        return PLLAlgs;
    }
  }

  static String getRandomAlg(String llcase, dynamic Algmap, String ll) {
    late String Alg;
    if (ll == "ZBLL") {
      final temp = llcase.split('-');
      // print(temp);
      int totalAlgs = Algmap[temp[0]][temp[1]][temp[2]].length;
      Alg = Algmap[temp[0]][temp[1]][temp[2]][Random().nextInt(totalAlgs)];
    } else if (ll == "OLL") {
      int totalAlgs = Algmap[int.parse(llcase)].length;
      Alg = Algmap[int.parse(llcase)][Random().nextInt(totalAlgs)];
    } else {
      int totalAlgs = Algmap[llcase].length;
      Alg = Algmap[llcase][Random().nextInt(totalAlgs)];
    }
    return Alg;
  }

  static String modify(String alg) {
    String alg1 = rotate(alg, "y2");
    String alg2 = rotate(alg, "y");
    String alg3 = rotate(alg, "y'");
    int b1 = 0;
    int b2 = 0;
    int b3 = 0;
    for (var element in alg1.runes) {
      if (element == 'B'.codeUnitAt(0)) {
        b1++;
      }
    }
    for (var element in alg2.runes) {
      if (element == 'B'.codeUnitAt(0)) {
        b2++;
      }
    }
    for (var element in alg3.runes) {
      if (element == 'B'.codeUnitAt(0)) {
        b3++;
      }
    }
    if (min(min(b1, b1), b3) > min(alg.split(" ").length / 3, 8)) {
      return inverse(alg);
    }
    List<String> valid = [alg];
    if (b1 < min(alg.split(" ").length / 3, 8)) valid.add(alg1);
    if (b2 < min(alg.split(" ").length / 3, 8)) valid.add(alg2);
    if (b3 < min(alg.split(" ").length / 3, 8)) valid.add(alg3);
    String randalg = valid[Random().nextInt(valid.length)];
    return inverse(randalg);
  }

  static String rotate(String alg, String side) {
    switch (side) {
      case 'y':
        StringBuffer rAlg = StringBuffer();
        for (var element in alg.runes) {
          if (element == 'F'.codeUnitAt(0)) {
            rAlg.write('L');
          } else if (element == 'R'.codeUnitAt(0)) {
            rAlg.write('F');
          } else if (element == 'B'.codeUnitAt(0)) {
            rAlg.write('R');
          } else if (element == 'L'.codeUnitAt(0)) {
            rAlg.write('B');
          } else {
            rAlg.write(String.fromCharCode(element));
          }
        }
        return rAlg.toString();
      case "y'":
        StringBuffer rAlg = StringBuffer();
        for (var element in alg.runes) {
          if (element == 'F'.codeUnitAt(0)) {
            rAlg.write('R');
          } else if (element == 'R'.codeUnitAt(0)) {
            rAlg.write('B');
          } else if (element == 'B'.codeUnitAt(0)) {
            rAlg.write('L');
          } else if (element == 'L'.codeUnitAt(0)) {
            rAlg.write('F');
          } else {
            rAlg.write(String.fromCharCode(element));
          }
        }
        return rAlg.toString();
      case "y2":
        StringBuffer rAlg = StringBuffer();
        for (var element in alg.runes) {
          if (element == 'F'.codeUnitAt(0)) {
            rAlg.write('B');
          } else if (element == 'R'.codeUnitAt(0)) {
            rAlg.write('L');
          } else if (element == 'B'.codeUnitAt(0)) {
            rAlg.write('F');
          } else if (element == 'L'.codeUnitAt(0)) {
            rAlg.write('R');
          } else {
            rAlg.write(String.fromCharCode(element));
          }
        }
        return rAlg.toString();
      default:
        return alg;
    }
  }

  static String inverse(String alg) {
    List<String> temp = alg.split(" ");
    List<String> tempR = temp.reversed.toList();
    StringBuffer iAlg = StringBuffer();
    for (var element in tempR) {
      if (element.contains("'")) {
        iAlg.write("${element.substring(0, 1)} ");
      } else if (element.contains("2")) {
        iAlg.write("$element ");
      } else {
        iAlg.write("$element' ");
      }
    }
    return iAlg.toString().trim();
  }
}
