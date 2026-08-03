class FormatNutrientName {
  String formatNutrientName(String uiName) {
    String databaseName = "";

    String lowerCaseUiName = uiName.toLowerCase();

    for(int i = 0; i < lowerCaseUiName.length; i++) {
      if(lowerCaseUiName[i] == " ") {
        databaseName += "_";
        i++;
      }
      databaseName += lowerCaseUiName[i];
    }

    return databaseName;
  }
}