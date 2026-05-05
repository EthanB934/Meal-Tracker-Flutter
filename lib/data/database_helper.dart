import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase () async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'meal_tracker.db');

    Database database = await openDatabase(
       path,
       version: 1,
       onOpen: (Database db) async {
         await db.execute(
             'PRAGMA foreign_keys = ON'
         );
       },
       onCreate: (Database db, int version) async {
         await db.execute(
           'CREATE TABLE IF NOT EXISTS user_profile ('
               'id INTEGER PRIMARY KEY AUTOINCREMENT, '
               'name TEXT NOT NULL, '
               'date_of_birth TEXT NOT NULL)'
         );
         await db.execute(
           'CREATE TABLE IF NOT EXISTS meal ('
               'id INTEGER PRIMARY KEY AUTOINCREMENT, '
               'userId INTEGER NOT NULL,'
               'type TEXT NOT NULL,'
               'createdAT TEXT NOT NULL, '
               'FOREIGN KEY (userId) REFERENCES user_profile (id)) '
         );
         await db.execute(
           'CREATE TABLE IF NOT EXISTS food ('
               'id INTEGER PRIMARY KEY AUTOINCREMENT, '
               'userId INTEGER NOT NULL,'
               'name TEXT NOT NULL, '
               'cost INTEGER, '
               'calories INTEGER, '
               'total_fat INTEGER, '
               'sodium INTEGER,'
               'total_carbohydrates INTEGER,'
               'total_sugars INTEGER,'
               'protein INTEGER,'
               'saturated_fat INTEGER,'
               'cholesterol INTEGER,'
               'fiber INTEGER,'
               'vitamin_d INTEGER,'
               'calcium INTEGER,'
               'potassium INTEGER,'
               'iron INTEGER,'
               'FOREIGN KEY (userId) REFERENCES user_profile (id)) '
         );
         await db.execute(
           'CREATE TABLE IF NOT EXISTS meal_food ('
               'mealId INTEGER NOT NULL,'
               'foodId INTEGER NOT NULL,'
               'quantity INTEGER NOT NULL,'
               'FOREIGN KEY (mealId) REFERENCES meal (id),'
               'FOREIGN KEY (foodId) REFERENCES food (id))'
         );
       }
    );

    return _database = database;
  }

  Future<int> createUser(String name, String dateOfBirth) async {
    final db = await database;

    int result = await db.transaction<int>((transaction) async {
      return await transaction.rawInsert(
        'INSERT INTO user_profile(name, date_of_birth) VALUES (?, ?)',
        [name, dateOfBirth]
      );
    });

    return result;
  }

  Future<bool> userExists() async {
    final db = await database;

    List<Map<String, Object?>> user = await db.rawQuery(
      'SELECT * FROM user_profile LIMIT 1'
    );

    return user.isNotEmpty;
  }
}