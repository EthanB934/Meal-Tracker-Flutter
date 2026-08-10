class FloorToDecimal {
  double floorToDecimal(double x, int places) {

   int mod = 1;

   for(int i = 0; i < places; i++) {
     mod = mod * 10;
   }

    double modifiedDouble = x * mod;

   final flooredModifiedDouble = modifiedDouble.floor();

   final double finalNumber = flooredModifiedDouble / mod;

    return finalNumber;
  }
}