import 'package:my_flutter_application/models/user_nutrient_preference.dart';
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
                 'FOREIGN KEY (userId) REFERENCES user_profile (id))'
         );
         await db.execute(
             'CREATE TABLE IF NOT EXISTS meal_food ('
                 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                 'mealId INTEGER NOT NULL,'
                 'foodId INTEGER NOT NULL,'
                 'quantity INTEGER NOT NULL,'
                 'FOREIGN KEY (mealId) REFERENCES meal (id),'
                 'FOREIGN KEY (foodId) REFERENCES food (id))'
         );

         await db.execute(
             'CREATE TABLE IF NOT EXISTS nutrient ('
                 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                 'name TEXT NOT NULL,'
                 'unit TEXT NOT NULL DEFAULT \'g\')'
         );

         await db.execute(
             'CREATE TABLE IF NOT EXISTS user_nutrient_preference ('
                 'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                 'userId INTEGER NOT NULL,'
                 'nutrientId INTEGER NOT NULL,'
                 'tracking_state TEXT NOT NULL DEFAULT \'untracked\','
                 'goal_amount REAL,'
                 'FOREIGN KEY (userId) REFERENCES user_profile (id),'
                 'FOREIGN KEY (nutrientId) REFERENCES nutrient (id))'
         );

         await _seedDatabase(db);
       }
    );

    return _database = database;
  }

  Future<void> _seedDatabase (Database db) async {
    final batch = db.batch();
    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["calories", "kcal"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["protein"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["total_carbohydrate"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["dietary_fiber"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["total_fat"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["saturated_fat"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["trans_fat"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["cholesterol", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["sodium"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["total_sugars"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["added_sugars"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["calcium", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["iron", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["potassium", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Vitamin A", "mcg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Vitamin B6", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Vitamin B12", "mcg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Vitamin C", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Vitamin D", "mcg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Vitamin E", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Vitamin K", "mcg"]
    );
    await batch.commit(noResult: true);
  }

  // User Data
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

  Future<int> deleteUser() async {
    final db = await database;

    int user = await db.rawDelete(
      'DELETE FROM user_profile WHERE id = 1'
    );

    return user;
  }

  Future<List<Map<String, Object?>>> getUser () async {
    final db = await database;

    List<Map<String, Object?>> user = await db.rawQuery(
        'SELECT * FROM user_profile LIMIT 1'
    );

    return user;
  }

  // Nutrient Data
  Future<List<Map<String,Object?>>> getNutrients () async {
    final db = await database;

    List<Map<String, Object?>> nutrients = await db.rawQuery(
        'SELECT * FROM nutrient'
    );

    return nutrients;
  }

  // User Nutrient Preference Data
  Future<List<Map<String, Object?>>> getUserPreferences() async {
    final db = await database;

    List<Map<String, Object?>> userPreferences = await db.rawQuery(
      'SELECT * FROM user_nutrient_preference'
    );

    return userPreferences;
  }

  Future<int> createUserNutrientPreference(UserNutrientPreference newUserNutrientPreference) async {
    final db = await database;

    int result = await db.rawInsert(
      'INSERT INTO user_nutrient_preference(userId, nutrientId, tracking_state, goal_amount) VALUES (?,?,?,?)',
      [newUserNutrientPreference.userId, newUserNutrientPreference.nutrientId, newUserNutrientPreference.trackingState, newUserNutrientPreference.goalAmount]
    );

    return result;
  }

  Future<int> updateUserNutrientPreference(UserNutrientPreference userNutrientPreference) async {
    final db = await database;
    print(
      'Tracking State: ${userNutrientPreference.trackingState}\n'
      'Goal Amount: ${userNutrientPreference.goalAmount}\n'
      'User Id: ${userNutrientPreference.userId}\n'
      'Nutrient Id: ${userNutrientPreference.nutrientId}\n'
      'Preference Id: ${userNutrientPreference.id}\n'
    );

    int result = await db.rawUpdate(
      'UPDATE user_nutrient_preference '
          'SET '
          'tracking_state = ?, '
          'goal_amount = ? '
          'WHERE id = ?',
      [userNutrientPreference.trackingState, userNutrientPreference.goalAmount, userNutrientPreference.id]
    );

    return result;
  }

  Future<int> deleteUserNutrientPreference(int userNutrientPreferenceId) async {
    final db = await database;

    int result = await db.rawDelete(
      'DELETE FROM user_nutrient_preference '
          'WHERE id = ?',
      [userNutrientPreferenceId]
    );

    return result;
  }
}