import 'package:flutter/material.dart';
import 'package:pulse/core/app_colors.dart';
import 'package:pulse/core/sl_service.dart';
import 'package:pulse/features/expense/views/home_screen.dart';

void main() {
  setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: AppColors.primaryColor)),
      home: HomeScreen(),
    );
  }
}
