import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Container(
              //margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     try {
      //       await _initializeControllerFuture;
      //       image = await _controller.takePicture();
      //       if (!context.mounted) return;
      //       List<String> data = await getImageTotext(image.path!);
      //       await Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => DisplayPictureScreen(
      //             imagePath: image.path,
      //             data: data,
      //           ),
      //         ),
      //       );
      //     } catch (e) {
      //       print(e);
      //     }
      //   },
      //   child: const Icon(Icons.camera_alt),
      // ),
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

      // print('rect ' + rect.toString());
      // print('cornerPoints ' + cornerPoints.toString());
      //print('text ' + text.toString());
      //print('languages ' + languages.toString());

      // for (TextLine line in block.lines) {
      //   print('line ' + line.toString());

      //   for (TextElement element in line.elements) {
      //     print('element ' + element.toString());
      //     //text = text + "\n" + element.text;
      //     textElement.add(element);
      //   }
      // }
      // for (TextBlock block in recognizedText.blocks) {
      //   final Rect boundingBox = block.boundingBox;
      //   final List<Point<int>> cornerPoints = block.cornerPoints;
      //   final String text = block.text;

      //   print("Block Text: $text");
      //   print("Block BoundingBox: $boundingBox");

      //   // Iterate through recognized lines within the block
      //   for (TextLine line in block.lines) {
      //     final String lineText = line.text;

      //     print("Line Text: $lineText");

      //     List<Offset> cornerOffsets = line.cornerPoints
      //         .map((point) => Offset(point.x.toDouble(), point.y.toDouble()))
      //         .toList();
      //     // If you specifically want horizontal lines, you can check for orientation
      //     // Assuming 'line.cornerPoints' gives you coordinates to check the orientation
      //     if (_isLineHorizontal(cornerOffsets)) {
      //       print("Horizontal Line Text: $lineText");
      //     }
      //   }
      // }
    }
    return labels;
  }

  // bool _isLineHorizontal(List<Offset> points) {
  //   // Check the coordinates of the corner points to determine if the line is horizontal
  //   // Simple check based on y-values of the points
  //   return (points[0].dy - points[1].dy).abs() < 10 &&
  //       (points[2].dy - points[3].dy).abs() < 10;
  // }

  // Future getImageTotext(File imagePath) async {
  //   String receiptOcrEndpoint =
  //       "https://ocr.asprise.com/api/v1/receipt"; // Receipt OCR API endpoint

  //   print(
  //       "=== Java Receipt OCR Demo - Need help? Email support@asprise.com ===");
  //   try {
  //     var stream =
  //         new http.ByteStream(DelegatingStream.typed(image.openRead()));
  //     var length = await image.length();
  //     Map<String, String> headers = {
  //       "Accept": "application/json",
  //     };
  //     var uri = Uri.parse(receiptOcrEndpoint);
  //     final request = await http.MultipartRequest("POST", uri);
  //     var multipartFileSign = new http.MultipartFile('file', stream, length,
  //         filename: basename(image.path));

  //     // add file to multipart
  //     request.files.add(multipartFileSign);

  //     //add headers
  //     request.headers.addAll(headers);

  //     //adding params
  //     request.fields['api_key'] = "TEST";
  //     request.fields['recognizer'] = "auto";
  //     request.fields['ref_no'] = "ocr_java_123";

  //     // send
  //     var streamedResponse = await request.send();
  //     print("setSubscrip:" + streamedResponse.statusCode.toString());
  //     var response = await http.Response.fromStream(streamedResponse);
  //     print("response:" + response.body.toString());
  //     return response;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
