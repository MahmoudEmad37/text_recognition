import 'dart:async';

import 'package:flutter/material.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: MyColor.splashBackgroundColor,
        child: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Image.asset("assets/images/logo.png"),
          ),
        ));
  }
}
