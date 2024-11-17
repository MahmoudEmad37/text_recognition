import 'package:flutter/material.dart';
import 'package:text_recognition/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'PETROMIN',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      useMaterial3: true,
    ),
    home: const SplashScreen(),
  ));
}
