import 'package:flutter/material.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/widgets/custom_appbar.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Container(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 50),
              child: Text(
                'Thanks For Your Business!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
              ),
            ),
            const Text(
              'Your Order',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Monday, Dec 28 2024 at 4.13pm',
              style: TextStyle(fontSize: 16, color: MyColor.grey),
            ),
            const SizedBox(height: 15),
            calculationContainer(),
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'your order number 2234443201',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calculationContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: MyColor.grey),
          const Text(
            '   1253  Gasoline 92  40,000 L',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const Center(
            child: Text(
              '750,0000EGP',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Divider(color: MyColor.grey[300]),
          calculateRow('Subtotal', '750,00000', MyColor.grey, 16),
          Divider(color: MyColor.grey[300]),
          calculateRow('Tax 1%', '7560', MyColor.grey, 16),
          const Divider(color: MyColor.blackColor),
          calculateRow('Total', 'EGP757560.00', MyColor.blackColor, 16),
          const Divider(color: MyColor.blackColor),
        ],
      ),
    );
  }

  Row calculateRow(String title, String value, Color color, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: size, color: color),
        ),
        Text(
          value,
          style: TextStyle(fontSize: size, color: color),
        ),
      ],
    );
  }
}
