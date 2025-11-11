class WaterUseCase {
  double calculateDailyGoal(double weight, double age) {
    // Basit formül: kilo * 0.03 litre
    return weight * 0.03;
  }
}