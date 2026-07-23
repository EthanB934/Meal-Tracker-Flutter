class FloorToDecimal {
  double floorToDecimal(double x, int places) {
    double mod = (10 * places).toDouble();
    double flooredDecimal = (x * mod).floor() / mod;

    return flooredDecimal.toDouble();
  }
}