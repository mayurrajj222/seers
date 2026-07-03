import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/design_system.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accentGold,
          background: AppColors.background,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
