import 'package:get/get.dart';
import '../domain/water_usecase.dart';

class HomeController extends GetxController {
  var weight = 60.0.obs;
  var age = 25.0.obs;
  var waterGoal = 0.0.obs;

  final useCase = WaterUseCase();

  void calculateGoal() {
    waterGoal.value = useCase.calculateDailyGoal(weight.value, age.value);
  }
}