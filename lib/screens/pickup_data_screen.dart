import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/core/progressbar.dart';
import 'package:text_recognition/screens/display_pdf_screen.dart';
import 'package:text_recognition/screens/display_picture_screen.dart';
import 'package:image/image.dart' as img;
import 'package:edge_detection/edge_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_recognition/widgets/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as pdf;

class PickupDataScreen extends StatefulWidget {
  const PickupDataScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  PickupDataScreenState createState() => PickupDataScreenState();
}

class PickupDataScreenState extends State<PickupDataScreen> {
  late CameraController _controller;
  // late Future<void> _initializeControllerFuture;
  XFile? image;
  String pdfText = '';

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
    );

    // _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              customButton(
                context,
                'Camera',
                MyColor.primaryColor,
                Icons.camera_alt,
                () async {
                  await getImageFromCamera(context);
                  CustomProgressbar.showProgressDialog(context);

                  List<String> data =
                      await getImageToText(context, image!, true);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        imagePath: File(image!.path).path,
                        data: data,
                      ),
                    ),
                  );
                  CustomProgressbar.hideProgressDialog(context);
                },
              ),
              customButton(context, 'Pick Image from Gallery',
                  MyColor.secoundColor, Icons.photo, () async {
                getImageFromGallery();
                CustomProgressbar.showProgressDialog(context);
                List<String> data =
                    await getImageToText(context, image!, false);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      imagePath: File(image!.path).path,
                      data: data,
                    ),
                  ),
                );
                CustomProgressbar.hideProgressDialog(context);
              }),
              customButton(context, 'Pick PDF from Device', Colors.blueAccent,
                  Icons.picture_as_pdf, () async {
                setState(() async {
                  pdfText = await extractTextFromPDF();
                  //print(pdfText);
                  List<String> data = extractSpecificTextFromPDF(pdfText);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPdfScreen(
                        data: data,
                      ),
                    ),
                  );
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Padding customButton(BuildContext context, String title,
      Color backgroundColor, IconData icon, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(280, 55),
          minimumSize: const Size(250, 55),
          backgroundColor: backgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: MyColor.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImageToText(
      BuildContext context, XFile imagePath, bool isCamera) async {
    final picked = img.decodeImage(File(imagePath.path).readAsBytesSync());
    print('هاللللللو');
    if (picked != null) {
      print('start 2');

      File croppedFile = await cropImage(picked, imagePath, isCamera);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer
          .processImage(InputImage.fromFilePath(croppedFile.path));
      print('start 3');

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
      // const int x = 1150; // X position 900
      // const int y = 230; // Y position 160
      // final int width = picked.width - 700; // Width (adjust as needed) 400
      // final int height = picked.height - 1500; // Height (adjust as needed) 1300
      // print('Crop the image');
      // final croppedImage = img.copyCrop(pickedImage, x, y, width, height);
      // print('Save the cropped image');
      final croppedFile =
          File(imagePath.path.replaceFirst('.jpg', '_cropped.jpg'));
      await croppedFile.writeAsBytes(img.encodeJpg(pickedImage));

      setState(() {
        image = XFile(croppedFile.path);
      });
      return croppedFile;
    } else {
      final pickedImage = img.copyRotate(picked, -90);

      // const int x = 1800; // X position1800
      // const int y = 500; // Y position500
      // final int width =
      //     pickedImage.width - 2300; // Width (adjust as needed)2300
      // final int height =
      //     pickedImage.height - 1500; // Height (adjust as needed)1500
      // // Crop the image
      // final croppedImage = img.copyCrop(pickedImage, x, y, width, height);
      // Save the cropped image
      final croppedFile =
          File(imagePath.path.replaceFirst('.jpg', '_cropped.jpg'));
      await croppedFile.writeAsBytes(img.encodeJpg(pickedImage));
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
    bool isBank = false;
    for (int i = 0; i < lines.length; i++) {
      double minimum = 1000.0;
      String closest = '';
      print("test:${(lines[i].text)}.");
      if (isBank == false && lines[i].text.contains('Bank')) {
        data.insert(0, lines[i].text);
        isBank = true;
      }
      if (labels.contains(lines[i].text) && i != (lines.length - 1)) {
        for (int j = i + 1; j < lines.length; j++) {
          print(
              "max: ${lines[i].text} ${(lines[i].boundingBox.top - lines[j].boundingBox.top).abs()}");
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

  Future<void> getImageFromCamera(BuildContext context) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    bool success = false;

    try {
      //Make sure to await the call to detectEdge.
      success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (success) {
        image = XFile(imagePath);
      }
    });
  }

  Future<void> getImageFromGallery() async {
    // Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    bool success = false;
    try {
      //Make sure to await the call to detectEdgeFromGallery.
      success = await EdgeDetection.detectEdgeFromGallery(
        imagePath,
        androidCropTitle: 'Crop', // use custom localizations for android
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (success) {
        image = XFile(imagePath);
      }
    });
  }

  Future<String> extractTextFromPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File pdfFile = File(result.files.single.path!);
      try {
        pdf.PdfDocument document =
            pdf.PdfDocument(inputBytes: pdfFile.readAsBytesSync());
        String extractedText = pdf.PdfTextExtractor(document).extractText();
        document.dispose();
        return extractedText;
      } catch (e) {
        return 'Error extracting text: $e';
      }
    } else {
      return '';
    }
  }

  List<String> extractSpecificTextFromPDF(String pdfText) {
    final List<String> labels = [
      'TransferFrom:',
      'Description:',
      'Bank:',
      'Name:',
      'Account:',
      'BankName:',
      'Amount:',
    ];
    pdfText = pdfText.substring(3);
    List<String> pdfList = pdfText.split('\n');
    List<String> data = [];

    for (int i = 0; i < pdfList.length - 1; i++) {
      if (labels.contains(pdfList[i].trim()) &&
          i != (pdfList.length - 2) &&
          pdfList[i + 1].isNotEmpty) {
        data.add(pdfList[i + 1]);
      }
    }
    return data;
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
        List<String> data = await getImageToText(context, image!, false);
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
}
