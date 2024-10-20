import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition/core/color.dart';

Future<String?> successDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  "assets/images/success_check.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Success',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              const Text(
                'Order Placed Successfully.\nwe will confirm your order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: MyColor.greenColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: 200,
                  padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
                  child: const Text(
                    'Ok',
                    style: TextStyle(fontSize: 20, color: MyColor.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
