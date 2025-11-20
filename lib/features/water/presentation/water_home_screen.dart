import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/water_controller.dart';
import 'water_tracker_screen.dart';
import 'water_logs_screen.dart';

class WaterHomeScreen extends StatefulWidget {
  const WaterHomeScreen({super.key});

  @override
  State<WaterHomeScreen> createState() => _WaterHomeScreenState();
}

class _WaterHomeScreenState extends State<WaterHomeScreen> {
  final HomeController _homeController = Get.find();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      WaterTrackerScreen(),
      WaterLogsScreen(),
      const Center(child: Text('Ayarlar')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _homeController.currentIndex.value,
        children: _screens,
      ),
          bottomNavigationBar: BottomNavigationBar(
        currentIndex: _homeController.currentIndex.value,
        onTap: _homeController.changeTab,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_drink), label: 'Anasayfa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'İstatistikler'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}
