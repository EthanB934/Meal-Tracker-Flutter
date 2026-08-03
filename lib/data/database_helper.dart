import 'package:my_flutter_application/models/food.dart';
import 'package:my_flutter_application/models/meal.dart';
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
                 'cost REAL, '
                 'name TEXT NOT NULL, '
                 'userId INTEGER NOT NULL,'
                 'added_sugars, REAL'
                 'calcium REAL,'
                 'calories REAL, '
                 'cholesterol REAL, '
                 'dietary_fiber REAL, '
                 'iron REAL,'
                 'potassium REAL,'
                 'protein REAL, '
                 'saturated_fat REAL,'
                 'sodium REAL,'
                 'total_carbohydrates REAL,'
                 'total_fat REAL, '
                 'trans_fat REAL, '
                 'total_sugars REAL, '
                 'vitamin_a REAL,'
                 'vitamin_b6 REAL,'
                 'vitamin_b12 REAL, '
                 'vitamin_c REAL,'
                 'vitamin_d REAL, '
                 'vitamin_e REAL, '
                 'vitamin_k REAL, '
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
        ["Calories", "kcal"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Protein"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Total Carbohydrate"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Dietary Fiber"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Total Fat"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Saturated Fat"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Trans Fat"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Cholesterol", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Sodium"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Total Sugars"]
    );

    batch.execute(
        'INSERT INTO nutrient(name) VALUES (?)',
        ["Added Sugars"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Calcium", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Iron", "mg"]
    );

    batch.execute(
        'INSERT INTO nutrient(name, unit) VALUES (?, ?)',
        ["Potassium", "mg"]
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

  Future<bool> userNutrient (int userId) async {
    final db = await database;

    List<Map<String, Object?>> userHasNutrientRelationship = await db.rawQuery(
        'SELECT * FROM user_nutrient_preference '
            'WHERE userId = ? '
            'LIMIT 1 ',
      [userId]
    );

    return userHasNutrientRelationship.isNotEmpty;
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
      [
        newUserNutrientPreference.userId,
        newUserNutrientPreference.nutrientId,
        newUserNutrientPreference.trackingState,
        newUserNutrientPreference.goalAmount
      ]
    );

    return result;
  }

  Future<int> updateUserNutrientPreference(UserNutrientPreference userNutrientPreference) async {
    final db = await database;

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

//   Meal Data

  Future<List<Map<String, Object?>>> fetchMeals() async {
    final db = await database;

    List<Map<String, Object?>> result = await db.rawQuery(
      'SELECT * FROM meal '
    );

    return result;
  }

  Future<int> createMeal (Meal newMeal)  async {
    final db = await database;

    int result = await db.rawInsert(
      'INSERT INTO meal VALUES (?, ?, ?) ',
      [newMeal.userId, newMeal.type, newMeal.createdAt]
    );

    return result;
  }

  Future<int> updateMeal(Meal meal) async {
    final db = await database;

    int result = await db.rawUpdate(
      'UPDATE meal '
          'SET '
          'type = ? '
          'WHERE '
          'id = ? ',
      [meal.type, meal.id]
    );

    return result;
  }

  Future<int> deleteMeal(int mealId) async {
    final db = await database;

    int result = await db.rawDelete(
      'DELETE FROM meal '
          'WHERE'
          'id = ? ',
      [mealId]
    );

    return result;
  }

//   Food data

  Future<List<Map<String, Object?>>> fetchFood() async {
    final db = await database;
    List<Map<String, Object?>> results = await db.rawQuery(
      'SELECT * FROM food '
    );

    return results;
  }

  Future<int> createFood(Map<String, dynamic> food) async {
    final db = await database;

    try {
    int result = await db.insert("food", food, conflictAlgorithm: ConflictAlgorithm.abort);
    return result;

    }
    on DatabaseException catch(e) {
      throw Exception('There was an issue submitting ${food['name']} into the database: ${e.toString()}');
    }
  }

  Future<int> updateFood(Food food) async {
    final db = await database;

    int result = await db.rawUpdate(
        'UPDATE '
            'SET '
            'cost = ?, '
            'name = ?, '
            'added_sugars = ?, '
            'calcium = ?, '
            'calories = ?, '
            'cholesterol = ?, '
            'dietary_fiber = ?, '
            'iron = ?, '
            'potassium = ?, '
            'protein = ?, '
            'saturated_fat = ?, '
            'sodium = ?, '
            'total_carbohydrates = ?, '
            'total_fat = ?, '
            'total_sugars = ?,'
            'trans_fat = ?,'
            'vitamin_a = ?, '
            'vitamin_b6 = ?, '
            'vitamin_b12 =?, '
            'vitamin_c = ?, '
            'vitamin_d = ?, '
            'vitamin_e = ?, '
            'vitamin_k = ? '
            'WHERE id = ? ',
        [
          food.cost, food.name,
          food.addedSugars, food.calcium, food.calories,
          food.cholesterol, food.dietaryFiber, food.iron,
          food.potassium, food.protein, food.saturatedFat,
          food.sodium, food.totalCarbohydrates, food.totalFat,
          food.totalSugars, food.transFat, food.vitaminA,
          food.vitaminB6, food.vitaminB12, food.vitaminC,
          food.vitaminD, food.vitaminE, food.vitaminK,
          food.id
        ]
    );

    return result;
  }

  Future<int> deleteFood (int foodId) async {
    final db = await database;

    int result = await db.rawDelete(
        'DELETE FROM food '
            'WHERE id = ? ',
        [foodId]
    );

    return result;
  }


}