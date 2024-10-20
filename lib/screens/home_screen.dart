import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/screens/cameraScreen.dart';
import 'package:text_recognition/screens/new_order_screen.dart';
import 'package:text_recognition/screens/notification_screen.dart';
import 'package:text_recognition/widgets/custom_appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CarouselSliderController outerCarouselController =
      CarouselSliderController();
  int outerCurrentPage = 0;

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 20.0, right: 15, left: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(children: [
                      Text(
                        'Hi, Khaled',
                        style:
                            TextStyle(color: MyColor.blackColor, fontSize: 30),
                      ),
                      Text(
                        'Petromin - October',
                        style: TextStyle(
                            color: MyColor.secoundColor, fontSize: 16),
                      ),
                    ]),
                    Container(
                      decoration: BoxDecoration(
                        color: MyColor.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                          color: MyColor.grey,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationScreen()));
                          },
                          icon: const Stack(
                            children: [
                              Icon(
                                Icons.notifications_none_outlined,
                                size: 30,
                              ),
                              Positioned(
                                // draw a red marble
                                top: 3.0,
                                right: 3.0,
                                child: Icon(Icons.brightness_1,
                                    size: 12.0, color: Colors.redAccent),
                              )
                            ],
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Total Balance',
                        style:
                            TextStyle(color: MyColor.blackColor, fontSize: 13),
                      ),
                      Text(
                        'EGP550000.00',
                        style: TextStyle(color: MyColor.grey, fontSize: 17),
                      ),
                    ]),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Last Order',
                    style: TextStyle(color: MyColor.blackColor, fontSize: 18),
                  ),
                ),
                _outerBannerSlider(),
                // CarouselSlider(
                //     carouselController: controller,
                //     options: CarouselOptions(
                //       height: 300,
                //       aspectRatio: 16 / 9,
                //       viewportFraction: 0.8,
                //       initialPage: 0,

                //       //enableInfiniteScroll: true,
                //       reverse: false,
                //       autoPlay: false,
                //       // autoPlayInterval: Duration(seconds: 3),
                //       // autoPlayAnimationDuration: Duration(milliseconds: 800),
                //       // autoPlayCurve: Curves.fastOutSlowIn,
                //       //enlargeCenterPage: true,
                //       scrollDirection: Axis.horizontal,
                //     ),
                //     items: [
                //       lastOrderContainer(),
                //       lastOrderContainer(),
                //       lastOrderContainer(),
                //       lastOrderContainer(),
                //     ].map<Widget>((item) {
                //       return item;
                //     }).toList()),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(332, 60),
                      backgroundColor: MyColor.secoundColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewOrderScreen()));
                    },
                    child: const Text(
                      'Submit new Order',
                      style: TextStyle(
                        fontSize: 20,
                        color: MyColor.whiteColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(332, 60),
                      backgroundColor: MyColor.primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onPressed: () async {
                      WidgetsFlutterBinding.ensureInitialized();
                      final cameras = await availableCameras();
                      final firstCamera = cameras.first;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CameraScreen(camera: firstCamera)));
                    },
                    child: const Text(
                      'Submit new Payment',
                      style: TextStyle(
                        fontSize: 20,
                        color: MyColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trip_origin),
            label: 'Trips',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_off),
            label: 'Profile',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: MyColor.whiteColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _outerBannerSlider() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: outerCarouselController,

          /// It's options
          options: CarouselOptions(
            height: 300,
            onPageChanged: (index, reason) {
              setState(() {
                outerCurrentPage = index;
              });
            },
          ),

          /// Items
          items: [
            lastOrderContainer(),
            lastOrderContainer(),
            lastOrderContainer(),
            lastOrderContainer(),
          ].map((item) {
            return Builder(
              builder: (BuildContext context) {
                /// Custom Image Viewer widget
                return item;
              },
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        ),

        /// Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) {
              bool isSelected = outerCurrentPage == index;
              return GestureDetector(
                onTap: () {
                  outerCarouselController.animateToPage(index);
                },
                child: AnimatedContainer(
                  width: isSelected ? 30 : 10,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurpleAccent
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget lastOrderContainer() {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),

      color: MyColor.grey[300],
      // padding: EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //   color: MyColor.grey[300],
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Number',
                    style: TextStyle(
                        color: MyColor.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '2287560387',
                    style: TextStyle(color: MyColor.blackColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Divider(
              color: MyColor.grey,
            ),
            SizedBox(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Details',
                    style: TextStyle(
                        color: MyColor.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 50,
                        height: 25,
                        child: Image.asset(
                          "assets/images/desel car.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Text(
                        'Diesel 40,000 L',
                        style:
                            TextStyle(color: MyColor.blackColor, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: MyColor.grey,
            ),
            const SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                        color: MyColor.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Delivered',
                    style: TextStyle(color: MyColor.greenColor, fontSize: 15),
                  ),
                ],
              ),
            ),
            Divider(
              color: MyColor.grey,
            ),
            SizedBox(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(
                        color: MyColor.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'PAID',
                    style: TextStyle(color: MyColor.greenColor, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
