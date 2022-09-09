// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

import 'package:lltrainer/AlgLists/OLLAlgs.dart';
import 'package:lltrainer/llnames/OLL.dart';
import 'package:lltrainer/llnames/ZBLL.dart';

class GenerateScramble {
  String scramble(String ll) {
    // final Algmap = llgetmap(ll);
    const Algmap = OLLAlgs;
    List<String> a = getCasesFromDb();
    String llcase = a[Random().nextInt(a.length)];
    String alg = Algmap[int.parse(llcase)]![Random().nextInt(Algmap[int.parse(llcase)]!.length)];
    return alg;
  }

  static List<String> getCasesFromDb() {
    return OLLNAMES;
  }

  static llgetmap(String ll) {}

  static String modify(String ll) {
    return "";
  }
}
