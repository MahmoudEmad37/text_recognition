import 'package:flutter/material.dart';
import 'package:text_recognition/core/color.dart';

AppBar customAppBar({BuildContext? context, String title = ''}) {
  return AppBar(
    title: Center(
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: MyColor.blackColor),
      ),
    ),
    backgroundColor: MyColor.whiteColor,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_outlined,
        size: 30,
        color: MyColor.blackColor,
      ),
      onPressed: () {
        Navigator.pop(context!);
      },
    ),
  );
}
