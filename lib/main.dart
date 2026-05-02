import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_screen.dart'; // Make sure file ka naam same ho jo tumne banaya hai

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Yahan GetMaterialApp use kiya hai
      debugShowCheckedModeBanner: false, // Right corner se debug banner hatane ke liye
      title: 'HR CRM',
      theme: ThemeData(
        // Apne UI ke hisaab se primary purple color set kiya hai
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8C52FF)),
        useMaterial3: true,
      ),
      home: OnboardingScreen(), // Apni onboarding screen ko first screen bana diya
    );
  }
}