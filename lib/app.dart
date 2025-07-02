import 'package:flutter/material.dart';
import 'features/home/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pose Estimation',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
