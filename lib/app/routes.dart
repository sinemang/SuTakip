import 'package:get/get.dart';
import '../features/water/presentation/water_home_screen.dart';
import '../features/water/presentation/water_input_screen.dart';
import '../features/water/presentation/water_calculation_screen.dart';
import '../features/water/presentation/water_logs_screen.dart';

class AppRoutes {
  // Başlangıç ekranı
  static const initial = '/input';

  // Route tanımları
  static final pages = [
    GetPage(
      name: '/input',
      page: () => WaterInputScreen(),
    ),
    GetPage(
      name: '/calculation',
      page: () => const WaterCalculationScreen(weight: 0, age: 0),
    ),
    GetPage(
      name: '/home',
      page: () => WaterHomeScreen(),
    ),
    GetPage(
      name: '/log',
      page: () => WaterLogsScreen(),
    ),

  ];
}
