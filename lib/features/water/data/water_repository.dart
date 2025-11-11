class WaterRepository {
  double currentWater = 0;

  void addWater(double amount) {
    currentWater += amount;
  }

  double getCurrentWater() {
    return currentWater;
  }
}
