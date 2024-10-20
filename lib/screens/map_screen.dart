import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        "assets/images/Map_Light.png",
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
