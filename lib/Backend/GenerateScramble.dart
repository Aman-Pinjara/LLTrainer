// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

import 'package:lltrainer/AlgLists/OLLAlgs.dart';
import 'package:lltrainer/AlgLists/PLLAlgs.dart';
import 'package:lltrainer/AlgLists/COLLAlgs.dart';
import 'package:lltrainer/AlgLists/ZBLLAlgs.dart';
import 'package:lltrainer/Models/ScrambleData.dart';
import 'package:lltrainer/llnames/OLL.dart';
import 'package:lltrainer/llnames/PLL.dart';
import 'package:lltrainer/llnames/ZBLL.dart';
import 'package:lltrainer/llnames/COLL.dart';

class GenerateScramble {
  ScrambleData scramble(String ll) {
    final Algmap = llgetmap(ll);
    List<String> a = getCasesFromDb(ll);
    String llcase = a[Random().nextInt(a.length)];
    String alg = getRandomAlg(llcase, Algmap, ll);
    print("case $llcase");
    print("alg $alg");
    final scramble =
        ScrambleData(scramble: modify(alg), ll: ll, llcase: llcase);
    return scramble;
  }

  static List<String> getCasesFromDb(String ll) {
    switch (ll) {
      case "PLL":
        return PLLNAMES;
      case "OLL":
        return OLLNAMES;
      case "COLL":
        return COLLNAMES;
      case "ZBLL":
        return ZBLLNAMES;
      default:
        print(ll);
        return PLLNAMES;
    }
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
    const r = ["y", "y'", "y2"];
    String r1 = r[Random().nextInt(r.length)];
    String r2 = r[Random().nextInt(r.length)];
    while (r1 == r2) {
      r2 = r[Random().nextInt(r.length)];
    }
    String alg1 = rotate(alg, r1);
    String alg2 = rotate(alg, r2);
    int d1 = 0;
    int d2 = 0;
    for (var element in alg1.runes) {
      if (element == 'D'.codeUnitAt(0)) {
        d1++;
      }
    }
    for (var element in alg2.runes) {
      if (element == 'D'.codeUnitAt(0)) {
        d2++;
      }
    }
    return inverse(d1 > d2 ? alg2 : alg1);
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
      default:
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
