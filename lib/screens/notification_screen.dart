import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/screens/pickup_data_screen.dart';
import 'package:text_recognition/screens/map_screen.dart';
import 'package:text_recognition/widgets/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context: context, title: 'Notifications'),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Today',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Divider(color: MyColor.grey[300]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListTile(
                  title: RichText(
                    text: const TextSpan(
                        text: '  Your order ',
                        style:
                            TextStyle(fontSize: 14, color: MyColor.blackColor),
                        children: [
                          TextSpan(
                            text: '23334443201',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' is approved',
                          )
                        ]),
                  ),
                  leading: SizedBox(
                    width: 40,
                    height: 25,
                    child: Image.asset(
                      "assets/images/desel car.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Divider(color: MyColor.grey[300]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListTile(
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'payment is required 50,000 EGP ',
                        style:
                            TextStyle(fontSize: 14, color: MyColor.blackColor),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: TextButton(
                      onPressed: () async {
                        WidgetsFlutterBinding.ensureInitialized();
                        final cameras = await availableCameras();
                        final firstCamera = cameras.first;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PickupDataScreen(camera: firstCamera)));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MyColor.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                        margin: const EdgeInsets.fromLTRB(110, 0, 0, 0),
                        child: const Text(
                          'pay',
                          style: TextStyle(
                              fontSize: 18,
                              color: MyColor.whiteColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: MyColor.primaryColor[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 25,
                        color: MyColor.primaryColor,
                      )),
                ),
              ),
              Divider(color: MyColor.grey[300]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapScreen()));
                  },
                  title: const Text(
                    '  Driver is on his way to your satation',
                    style: TextStyle(fontSize: 14, color: MyColor.blackColor),
                  ),
                  leading: SizedBox(
                    width: 40,
                    height: 25,
                    child: Image.asset(
                      "assets/images/desel car.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
