import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/food.dart';

class FoodService {

  Future<List<Food>> fetchFood() async {
    List<Map<String, Object?>> results = await DatabaseHelper().fetchFood();
    return results.map((result) => Food.fromMap(result)).toList();
  }

  Future<int> createFood(Map<String, dynamic> food) async {
    int result = await DatabaseHelper().createFood(food);

    if(result == 0) {
      throw Exception("There was an error creating food item ${food['name']}");
    }

    return result;
  }

  Future<int> updateFood(Food food) async {
    int result = await DatabaseHelper().updateFood(food);

    if(result == 0) {
      throw Exception("There was an error updating ${food.name}");
    }

    return result;
  }

  Future<int> deleteFood(foodId) async {
    int result = await DatabaseHelper().deleteFood(foodId);

    if(result == 0) {
      throw Exception("There was an error deleting food with id $foodId");
    }

    return result;
  }
}