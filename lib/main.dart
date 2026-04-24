import 'package:flutter/material.dart';
import 'screens/inventory_feed_screen.dart';
import 'utils/style_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WhatToEatToday());
}

class WhatToEatToday extends StatelessWidget {
  const WhatToEatToday({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What to Eat Today - Food Radar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.surface,
        ),
      ),
      home: const InventoryFeedScreen(),
    );
  }
}
