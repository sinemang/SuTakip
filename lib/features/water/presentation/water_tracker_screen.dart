import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/water_controller.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<HomeController>();
  late final AnimationController _controllerConfeti;
  double cupAmount = 0.25;

  Artboard? _artboard;
  StateMachineController? _controller;
  SMINumber? _progressInput;

  @override
  void initState() {
    super.initState();
    _loadRive();
    _controllerConfeti = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controllerConfeti.dispose();
    super.dispose();
  }

  Future<void> _loadRive() async {
    await RiveFile.initialize();

    final data = await rootBundle.load('assets/new.riv');
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine',
    );
    if (controller != null) {
      artboard.addController(controller);

      final input = controller.findInput<double>('Level') as SMINumber;
      input.value = 0;
      _progressInput = input;

      setState(() {
        _artboard = artboard;
        _controller = controller;
      });
    }
  }

  void _addWater() {
    setState(() {
      controller.currentWater.value += cupAmount;

      if (controller.currentWater.value >= controller.dailyGoal.value) {
        _controllerConfeti.forward();
      }
    });

    if (_progressInput != null && controller.dailyGoal.value > 0) {
      _progressInput!.value =
          (controller.currentWater.value / controller.dailyGoal.value) * 100;
    }
  }

  void _switchCup() {
    setState(() {
      cupAmount = cupAmount == 0.25 ? 0.50 : 0.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (controller.dailyGoal.value == 0)
        ? 0
        : controller.currentWater.value / controller.dailyGoal.value;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => Text(
                      '${controller.currentWater.value.toStringAsFixed(2)} L / ${controller.dailyGoal.value.toStringAsFixed(2)} L',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 500,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _addWater();
                        },
                        child: Container(
                          width: 300,
                          height: 500,
                          color: Colors.grey[900],
                          child: _artboard == null
                              ? const SizedBox()
                              : Rive(artboard: _artboard!, fit: BoxFit.fill),
                        ),
                      ),
                      Lottie.asset(
                        'assets/animations/Confetti.json',
                        repeat: false,
                        fit: BoxFit.cover,
                        controller: _controllerConfeti,
                      ),
                      Positioned(
                        bottom: 150,
                        child: GestureDetector(
                          onTap: _addWater,
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            children: [
                              Opacity(
                                opacity: 0.8,
                                child: Shimmer.fromColors(
                                  child: Icon(
                                    Icons.touch_app,
                                    color: Colors.grey,
                                    size: 34,
                                  ),
                                  baseColor: Colors.black12,
                                  highlightColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tıkla!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black12,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Günlük Hedef'),
                  Obx(
                    () => Text(
                      '${controller.dailyGoal.value.toStringAsFixed(2)} L',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Obx(
                () =>
                    LinearProgressIndicator(
                      value: controller.dailyGoal.value == 0
                          ? 0
                          : controller.currentWater.value / controller.dailyGoal.value,
                    minHeight: 8,
                    color: Colors.blueAccent,
                    backgroundColor: Colors.blue[200],
                  ),
                ),


              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _switchCup,
                child: Text(
                  'Bardak değiştir: ${(cupAmount * 1000).toStringAsFixed(0)} ml',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
