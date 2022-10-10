import 'package:lltrainer/Models/TimeModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Timedb {
  static final Timedb instance = Timedb.privateConstructor();
  Timedb.privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await getDatabase("timestable.db");
    return _database!;
  }

  Future getDatabase(String filename) async {
    final systemPath = await getDatabasesPath();
    final path = join(systemPath, filename);
    _database = await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database database, int version) async {
    await database.execute('''
      CREATE TABLE $TIMESTABLENAME(
        ${TimeModelDBFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TimeModelDBFields.lltype} TEXT NOT NULL,
        ${TimeModelDBFields.llcase} TEXT NOT NULL,
        ${TimeModelDBFields.time} DECIMAL(4,2) NOT NULL
      )''');
  }

  Future<TimeModel> insertInDB(TimeModel timeObj) async {
    final db = await instance.database;
    final id = await db.insert(TIMESTABLENAME, timeObj.toJson());
    return timeObj.copy(id: id);
  }

  Future<List<TimeModel>> getllTime(String lltype) async {
    final db = await instance.database;
    final times = await db.query(TIMESTABLENAME,
        where: "${TimeModelDBFields.lltype} = ?",
        whereArgs: [lltype],
        orderBy: "${TimeModelDBFields.id} DESC");
    return times.map((e) => TimeModel.fromJson(e)).toList();
  }

  Future<List<TimeModel>> getllcaseTime(String llcase) async {
    final db = await instance.database;
    final times = await db.query(TIMESTABLENAME,
        where: "${TimeModelDBFields.llcase} = ?",
        whereArgs: [llcase],
        orderBy: "${TimeModelDBFields.time} DESC");
    return times.map((e) => TimeModel.fromJson(e)).toList();
  }

  Future<void> deleteFromDb(int id) async {
    final db = await instance.database;
    await db.delete(TIMESTABLENAME,
        where: "${TimeModelDBFields.id} = ?", whereArgs: [id]);
  }
}
