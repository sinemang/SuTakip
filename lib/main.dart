import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes.dart';
import 'app/theme.dart';

void main() {
  runApp(const WaterReminderApp());
}

class WaterReminderApp extends StatelessWidget {
  const WaterReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Water Reminder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.pages,
    );
  }
}