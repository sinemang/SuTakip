import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import '../controllers/water_controller.dart';
import 'water_calculation_screen.dart';

class WaterInputScreen extends StatelessWidget {
  WaterInputScreen({super.key});

  final HomeController controller = Get.find();

  void _goToCalculationScreen(BuildContext context) {

    // CalculationScreen'e git (navigator yerine Get kullan)
    Get.to(() => WaterCalculationScreen(
      weight: controller.weight.value,
      age: controller.age.value,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Su İhtiyacı Hesaplama ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:Center(child:
          Column(mainAxisAlignment:MainAxisAlignment.center,
          children: [
            const Text('Kilonuz (kg):', style: TextStyle(fontSize: 18)),
            Obx(() => NumberPicker(
              value: controller.weight.value.toInt(),
              minValue: 30,
              maxValue: 150,
              onChanged: (value) => controller.weight.value = value.toDouble(),
            )),
            const SizedBox(height: 32),
            const Text('Yaşınız:', style: TextStyle(fontSize: 18)),
            Obx(() => NumberPicker(
              value: controller.age.value.toInt(),
              minValue: 10,
              maxValue: 100,
              onChanged: (value) => controller.age.value = value.toDouble(),
            )),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _goToCalculationScreen(context),
              child: const Text('Hesapla'),
            ),
          ],
        ),
        ) ,
      ),
    );
  }
}