import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/nutrient.dart';

class NutrientService {
  Future<List<Nutrient>> fetchNutrientsData() async {
    List<Map<String, Object?>> results = await DatabaseHelper().getNutrients();
    return results.map((map) => Nutrient.fromMap(map)).toList();
  }
}