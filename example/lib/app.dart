import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class TonetagExampleApp extends StatelessWidget {
  const TonetagExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Plugin Example',
      home: HomeScreen(),
    );
  }
}
