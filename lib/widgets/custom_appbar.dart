import 'package:flutter/material.dart';
import 'package:text_recognition/core/color.dart';

AppBar customAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: MyColor.whiteColor,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_outlined,
        size: 30,
        color: MyColor.blackColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
