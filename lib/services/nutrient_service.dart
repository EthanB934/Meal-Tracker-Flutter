import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/nutrient.dart';

/*
  Nutrient service is a layer between UI and Database. It handles requests to
  the nutrient resource (i.e. validating data shape, fetching data, etc.) and
  responding to the UI layer with messages of either success or failure depending
  on the result of those requests.
 */

class NutrientService {
  // Retrieves nutrient data from database and maps that data to the nutrient model
  Future<List<Nutrient>> fetchNutrientsData() async {
    List<Map<String, Object?>> results = await DatabaseHelper().getNutrients();
    return results.map((map) => Nutrient.fromMap(map)).toList();
  }
}