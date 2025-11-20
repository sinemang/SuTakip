import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:water_reminder/features/water/presentation/water_home_screen.dart';
import 'package:water_reminder/features/water/presentation/water_tracker_screen.dart';
import 'package:liquid_wave_animate_button/liquid_wave_animate_button.dart';
import 'package:lottie/lottie.dart';

import '../controllers/water_controller.dart';

class WaterCalculationScreen extends StatelessWidget {
  final double weight;
  final double age;

  const WaterCalculationScreen({
    super.key,
    required this.weight,
    required this.age,
  });
  @override
  Widget build(BuildContext context) {
    // Hesaplanan günlük su miktarı
    final controller = Get.find<HomeController>();
    double waterAmount = controller.useCase
        .calculateDailyGoal(weight, age);//use casei çağırır sadece sonucu gösterir.


    return Scaffold(
      appBar: AppBar(title: const Text('Su Hesaplama Sonucu')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/Wumpus Hi.json',repeat: true),
            SizedBox(height: 50,width: 10,),
            Text(
              'İçmeniz gereken su miktarı:\n${waterAmount.toStringAsFixed(2)} L',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 92),
            LiquidWaveAnimateButton(buttonName: 'Takip Etmeye Başla',width: 300,height: 60,fillLevel: 0.8,liquidColor: Colors.blue,ariseAnimation: true,ariseDuration: const Duration(seconds: 2),borderColor: Colors.white,borderWidth: 2.0,backgroundColor: Colors.black,textStyle: const TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
              onPressed: () {
                // GÜNLÜK HEDEFİ CONTROLLER'A KAYDET
                controller.dailyGoal.value = waterAmount;
                Get.offAll(() => WaterHomeScreen());
              },),

          ],
        ),
      ),
    );
  }
}
