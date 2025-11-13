import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_reminder/firebase_options.dart';
import 'app/routes.dart';
import 'app/theme.dart';
import 'core/firebase/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform,);

  final authService =AuthService();//auth servis nesnesi oluşturuldu,firebase auth erişimi hazır
  await authService.signInAnonymouslyIfNeeded();//çağırıldı ve otomatik anonim oturum açıldı

  print("current user UID: ${authService.uid}");


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