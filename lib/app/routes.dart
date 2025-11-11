import 'package:get/get.dart';
import '../features/water/presentation/water_input_screen.dart';
import '../features/water/presentation/water_calculation_screen.dart';
import '../features/water/presentation/water_tracker_screen.dart';

class AppRoutes {
  static const initial = '/input';

  static final pages = [

  GetPage

  (

  name: '/input', page: () => WaterInputScreen()),
  GetPage(name: '/calculation', page: () => const WaterCalculationScreen(weight: 0, age: 0)),
  GetPage(
  name: '/tracker',page: () {
  // Günlük hedefi Get.arguments ile alıyoruz
  final double dailyGoal = Get.arguments as double;
  return WaterTrackerScreen(dailyGoal: dailyGoal);
  },
  )
  ];
}