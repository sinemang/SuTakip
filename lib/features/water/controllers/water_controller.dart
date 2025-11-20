import 'package:get/get.dart';
import '../domain/water_usecase.dart';

class HomeController extends GetxController {
  var weight = 60.0.obs;
  var age = 25.0.obs;
  RxDouble currentWater = 0.0.obs;
  RxDouble dailyGoal = 0.0.obs;
  var currentIndex = 0.obs; // reaktif index


  void onInit() {
    super.onInit();
    calculateGoal(); // günlük hedef otomatik hesaplansın!
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  final useCase = WaterUseCase();

  void calculateGoal() {
    dailyGoal.value = useCase.calculateDailyGoal(weight.value, age.value);
  }
  void addWater(double amount) {
    if (dailyGoal.value == 0) return;
    currentWater.value += amount;}

  double get progressPercent {
    if (dailyGoal.value == 0) return 0;
    return (currentWater.value / dailyGoal.value) * 100;
  }

}