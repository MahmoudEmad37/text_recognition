import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/core/progressbar.dart';
import 'package:text_recognition/screens/display_picture_screen.dart';
import 'package:image/image.dart' as img;

import 'package:text_recognition/widgets/custom_appbar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? image;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future pickImage(BuildContext context, bool isCamera) async {
    try {
      CustomProgressbar.showProgressDialog(context);
      if (isCamera) {
        image = await ImagePicker().pickImage(source: ImageSource.camera);
      } else {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      if (image == null) return;
      try {
        if (!context.mounted) return;
        List<String> data = await getImageTotext(image!, false);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              imagePath: File(image!.path).path,
              data: data,
            ),
          ),
        );
      } catch (e) {
        print(e);
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 2 / 3,
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(280, 55),
                    minimumSize: const Size(250, 55),
                    backgroundColor: MyColor.primaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () async {
                    // pickImage(context, true);
                    CustomProgressbar.showProgressDialog(context);
                    await _initializeControllerFuture;
                    image = await _controller.takePicture();
                    if (!context.mounted) return;
                    List<String> data = await getImageTotext(image!, true);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          imagePath: File(image!.path).path,
                          data: data,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 20,
                          color: MyColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(300, 50),
                  minimumSize: const Size(250, 50),
                  backgroundColor: MyColor.secoundColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                child: const Text(
                  'Pick Image from Gallery',
                  style: TextStyle(
                    fontSize: 20,
                    color: MyColor.whiteColor,
                  ),
                ),
                onPressed: () {
                  pickImage(context, false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImageTotext(XFile imagePath, bool isCamera) async {
    final picked = img.decodeImage(File(imagePath.path).readAsBytesSync());
    if (picked != null) {
      File croppedFile = await cropImage(picked, imagePath, isCamera);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer
          .processImage(InputImage.fromFilePath(croppedFile.path));
      List<TextLine> labels = [];
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          labels.add(line);
        }
      }
      CustomProgressbar.hideProgressDialog(context);
      List<String> data = await isSameLine(labels);
      return data;
    }
    CustomProgressbar.hideProgressDialog(context);
  }

  Future<File> cropImage(
      img.Image picked, XFile imagePath, bool isCamera) async {
    if (isCamera) {
      print('start');
      final pickedImage = img.copyRotate(picked, -90);
      const int x = 900; // X position 350
      const int y = 160; // Y position 80
      final int width = picked.width - 400; // Width (adjust as needed) 200
      final int height = picked.height - 1300; // Height (adjust as needed) 450
      print('Crop the image');
      final croppedImage = img.copyCrop(pickedImage, x, y, width, height);
      print('Save the cropped image');
      final croppedFile =
          File(imagePath.path.replaceFirst('.jpg', '_cropped.jpg'));
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
      setState(() {
        image = XFile(croppedFile.path);
      });
      return croppedFile;
    } else {
      final pickedImage = img.copyRotate(picked, -90);
      // Define the crop dimensions
      const int x = 1800; // X position1800
      const int y = 500; // Y position500
      final int width =
          pickedImage.width - 2300; // Width (adjust as needed)2300
      final int height =
          pickedImage.height - 1500; // Height (adjust as needed)1500
      // Crop the image
      final croppedImage = img.copyCrop(pickedImage, x, y, width, height);
      // Save the cropped image
      final croppedFile =
          File(imagePath.path.replaceFirst('.jpg', '_cropped.jpg'));
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
      setState(() {
        image = XFile(croppedFile.path);
      });
      return croppedFile;
    }
  }

  Future<List<String>> isSameLine(List<TextLine> lines) async {
    List<String> data = [];
    List<String> labels = [
      'Transaction Reference:',
      'Value Date:',
      'Deposited Amount:',
      'Deposited Arnount:',
      'Amount in words:',
      'Account Name:',
      'Account No.:',
      'Account Currency:',
      'Account Curency:',
      'Acoount Name:',
      'Acoount No.:',
      'Acoount Currency:',
    ];
    for (int i = 0; i < lines.length; i++) {
      double minimum = 1000.0;
      String closest = '';
      print("test:${(lines[i].text)}.");
      if (labels.contains(lines[i].text) && i != (lines.length - 1)) {
        for (int j = i + 1; j < lines.length; j++) {
          // print(
          //     "max: ${(lines[i].boundingBox.top - lines[j].boundingBox.top).abs()}");
          if ((lines[i].boundingBox.top - lines[j].boundingBox.top).abs() <
              minimum) {
            closest = lines[j].text;
            minimum =
                (lines[i].boundingBox.top - lines[j].boundingBox.top).abs();
          }
        }
        print('$i  $closest');
        data.add(closest);
      }
    }
    return data;
  }
}
