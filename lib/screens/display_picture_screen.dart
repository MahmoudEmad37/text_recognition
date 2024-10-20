import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:text_recognition/core/success_dialog.dart';
import 'package:text_recognition/widgets/custom_appbar.dart';
import 'package:text_recognition/core/color.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final List<String> data;
  final List<String> labels = [
    'Transaction Reference:',
    'Value Date:',
    'Deposited Amount:',
    'Amount in words:',
    'Net Deposited Amount:',
    'Account Name:',
    'Account No:',
    'Account Currency:'
  ];

  DisplayPictureScreen(
      {super.key, required this.imagePath, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context: context),
        body: Column(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Image.file(File(imagePath))),
          Expanded(
            child: ListView.builder(
                itemCount: labels.length,
                itemBuilder: (_, index) {
                  return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              labels[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: TextField(
                                textAlign: TextAlign.center,
                                //readOnly: true,
                                style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
                                  //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, -20),
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                controller: TextEditingController(
                                    text: index >= data.length
                                        ? ''
                                        : data[index]),
                              ),
                            ),
                          ]));
                }),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              maximumSize: const Size(300, 60),
              minimumSize: const Size(250, 60),
              backgroundColor: MyColor.primaryColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: () {
              successDialog(context);
            },
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontSize: 20,
                color: MyColor.whiteColor,
              ),
            ),
          ),
        ]));
  }
}
