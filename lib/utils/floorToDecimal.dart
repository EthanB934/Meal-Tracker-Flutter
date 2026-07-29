class FloorToDecimal {
  double floorToDecimal(double x, int places) {
    int mod = 10 * places;

    double modifiedDouble = x * mod;

    final double finalNumber = modifiedDouble / mod;

    return finalNumber;
  }
}