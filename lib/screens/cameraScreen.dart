import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/screens/display_picture_screen.dart';
import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';

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
  dynamic image;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future pickImage(BuildContext context) async {
    try {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      try {
        if (!context.mounted) return;
        List<String> data = await getImageTotext(image.path!);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(
              imagePath: image.path,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
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
                  pickImage(context);
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(300, 60),
                minimumSize: const Size(250, 60),
                backgroundColor: MyColor.primaryColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  image = await _controller.takePicture();
                  if (!context.mounted) return;
                  List<String> data = await getImageTotext(image.path!);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        imagePath: image.path,
                        data: data,
                      ),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
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
          ],
        ),
      ),
    );
  }

  Future getImageTotext(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    List<String> labels = [];
    List<TextElement> textElement = [];
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      print("Block Text: ${block.text}");
      if (!block.text.contains(':')) {
        labels.add(block.text);
      }
      final List<String> languages = block.recognizedLanguages;
    }
    return labels;
  }

  int compare(TextElement t1, TextElement t2) {
    int diffOfTops = (t1.boundingBox.top - t2.boundingBox.top).ceil();
    int diffOfLefts = (t1.boundingBox.left - t2.boundingBox.left).ceil();

    int height = ((t1.boundingBox.height + t2.boundingBox.height) / 2).ceil();
    int verticalDiff = (height * 0.35).ceil();

    int result = diffOfLefts.ceil();
    if (diffOfTops.abs() > verticalDiff) {
      result = diffOfTops;
    }
    return result;
  }

  bool isSameLine(TextElement t1, TextElement t2) {
    int diffOfTops = (t1.boundingBox.top - t2.boundingBox.top).ceil();

    int height =
        ((t1.boundingBox.height + t2.boundingBox.height) * 0.35).ceil();

    if (diffOfTops.abs() > height) {
      return false;
    }
    return true;
  }
}
