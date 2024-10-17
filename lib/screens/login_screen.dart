import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

// bool validateTextFieldPhone(String phone) {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColor.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset("assets/images/logo.png"),
            ),
            const SizedBox(
              child: Text(
                'Login to Your Station',
                style: TextStyle(
                  color: MyColor.primaryColor,
                  decoration: TextDecoration.none,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: const TextStyle(
                    height: 2.5, fontSize: 16, color: MyColor.blackColor),
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  labelStyle: TextStyle(color: MyColor.blackColor),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: MyColor.primaryColor,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColor.blackColor),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: phoneController,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: const TextStyle(
                    height: 2.5, fontSize: 16, color: MyColor.blackColor),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: MyColor.primaryColor,
                    ),
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: MyColor.blackColor),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColor.blackColor),
                  ),
                ),
                obscureText: passwordVisible,
                controller: passwordController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(332, 46),
                  backgroundColor: MyColor.primaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onPressed: () {
                  // if (phoneController.text == '12345' &&
                  //     passwordController.text == '12345')
                  //     {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  // }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: MyColor.whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyColor.primaryColor),
              child: const Icon(
                Icons.fingerprint_outlined,
                color: MyColor.whiteColor,
                size: 70,
              ),
            )
          ],
        ),
      ),
    );
  }
}
