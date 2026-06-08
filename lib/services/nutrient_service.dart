import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:sqflite/sqflite.dart';

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

  // Retrieves user nutrient preferences from database and maps results to user nutrient preference model
  Future<List<UserNutrientPreference>> fetchUserPreferences() async {
    List<Map<String, Object?>> results = await DatabaseHelper().getUserPreferences();
    return results.map((map) => UserNutrientPreference.fromMap(map)).toList();
  }

  Future<int> createNewUserNutrientPreference(UserNutrientPreference userNutrientPreference) async {
    bool validTrackingState = validateTrackingState(userNutrientPreference.trackingState);
    if(validTrackingState) {
      return await DatabaseHelper().createUserNutrientPreference(userNutrientPreference);
    }
    throw Exception("Invalid tracking state on create $validTrackingState");
  }

  Future<int> updateUserNutrientPreference(UserNutrientPreference userNutrientPreference) async {
    bool validTrackingState = validateTrackingState(userNutrientPreference.trackingState);
    if(validTrackingState) {
      return await DatabaseHelper().updateUserNutrientPreference(userNutrientPreference);
    }
    throw Exception("Invalid tracking state on update $validTrackingState");
  }

  Future<int> deleteUserNutrientPreference(int userNutrientPreferenceId) async {
    int result = await DatabaseHelper().deleteUserNutrientPreference(userNutrientPreferenceId);

    if(result == 0) {
      throw Exception("Failed to delete user nutrient preference $userNutrientPreferenceId");
    }

    return result;
  }

  bool validateTrackingState(String userNutrientTrackingState) {
    return userNutrientTrackingState == "maximizing" || userNutrientTrackingState == "limiting";
  }
}