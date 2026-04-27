import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> initDatabase () async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'meal_tracker.db');

    Database database = await openDatabase(
       path,
       version: 1,
       onCreate: (Database db, int version) async {
         await db.execute(
           'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)'
         );
       }
    );

    return database;
  }
}