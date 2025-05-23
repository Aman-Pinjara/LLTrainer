// ignore_for_file: depend_on_referenced_packages
import 'package:lltrainer/llnames/COLL.dart';
import 'package:lltrainer/llnames/PLL.dart';
import 'package:lltrainer/llnames/ZBLL.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/SelectionModel.dart';
import '../llnames/OLL.dart';

class Selectiondb {
  static final Selectiondb instance = Selectiondb.privateConstructor();
  Selectiondb.privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await getDatabase("selectiontable.db");
    return _database!;
  }

  Future getDatabase(String filename) async {
    final systemPath = await getDatabasesPath();
    final path = join(systemPath, filename);
    _database = await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database database, int version) async {
    await database.execute('''
      CREATE TABLE $SELECTIONTABLENAME(
        ${SelectionModelDBFields.llcase} TEXT PRIMARY KEY,
        ${SelectionModelDBFields.lltype} TEXT NOT NULL,
        ${SelectionModelDBFields.selectionType} INTEGER NOT NULL,
        ${SelectionModelDBFields.alg} TEXT
      )''');
    await Future.wait(
      [
        for (var element in PLLNAMES)
          insertDefaults(
            database,
            SelectionModel(
              llcase: element,
              lltype: "PLL",
              selectionType: 0,
            ),
          ),
        for (var element in OLLNAMES)
          insertDefaults(
            database,
            SelectionModel(
              llcase: element,
              lltype: "OLL",
              selectionType: 0,
            ),
          ),
        for (var element in COLLNAMES)
          insertDefaults(
            database,
            SelectionModel(
              llcase: element,
              lltype: "COLL",
              selectionType: 0,
            ),
          ),
        for (var element in ZBLLNAMES)
          insertDefaults(
            database,
            SelectionModel(
              llcase: element,
              lltype: "ZBLL",
              selectionType: 0,
            ),
          ),
      ],
    );
  }

  static Future insertDefaults(Database db, SelectionModel selection) async {
    await db.insert(SELECTIONTABLENAME, selection.toJson());
  }

  Future<List<SelectionModel>> getSelections(String lltype) async {
    final db = await instance.database;
    final selection = await db.query(
      SELECTIONTABLENAME,
      where: "${SelectionModelDBFields.lltype} = ?",
      whereArgs: [lltype],
    );
    return selection.map((e) => SelectionModel.fromJson(e)).toList();
  }

  Future<List<SelectionModel>> filterSelections(String lltype, int sel) async {
    final db = await instance.database;
    final List<Map<String, Object?>> selection;
    if (sel != 3) {
      selection = await db.query(
        SELECTIONTABLENAME,
        where:
            "${SelectionModelDBFields.lltype} = ? and ${SelectionModelDBFields.selectionType} = ?",
        whereArgs: [lltype, sel.toString()],
      );
    } else {
      selection = await db.query(
        SELECTIONTABLENAME,
        where:
            "${SelectionModelDBFields.lltype} = ? and ${SelectionModelDBFields.selectionType} != ?",
        whereArgs: [lltype, sel.toString()],
      );
    }
    return selection.map((e) => SelectionModel.fromJson(e)).toList();
  }

  Future<String?> getSelectionAlg(String lltype, String llcase) async {
    final db = await instance.database;
    final selection = await db.query(
      SELECTIONTABLENAME,
      where: "${SelectionModelDBFields.llcase} = ?",
      whereArgs: [llcase],
    );
    return SelectionModel.fromJson(selection[0]).alg;
  }

  Future<void> updateSelection(SelectionModel selection) async {
    final db = await instance.database;
    db.update(SELECTIONTABLENAME, selection.toJson(),
        where: "${SelectionModelDBFields.llcase} = ?",
        whereArgs: [selection.llcase]);
  }

  Future<void> updateAllSelecition(List<SelectionModel> selectionList) async {
    await Future.wait(selectionList.map((e) => updateSelection(e)));
  }
}
