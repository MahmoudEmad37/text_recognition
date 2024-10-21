import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/core/success_dialog.dart';
import 'package:text_recognition/screens/invoice_screen.dart';
import 'package:text_recognition/widgets/custom_appbar.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Container(
          padding: const EdgeInsets.only(top: 30.0, right: 15, left: 15),
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text(
                  'New Order',
                  style: TextStyle(color: MyColor.blackColor, fontSize: 30),
                ),
                const SizedBox(height: 25),
                Container(
                  width: 300,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: MyColor.primaryColor[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  child: const Text(
                    'Minimum Quantity : 10M3',
                    style: TextStyle(color: MyColor.blackColor, fontSize: 13),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Table(
                  border: TableBorder.all(color: Colors.transparent),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Text('Code'),
                      Text('Product'),
                      Text(''),
                      Text('Quantity'),
                      Text(''),
                    ]),
                    tableRow('1223', 'Gasoline 95'),
                    tableRow('1253', 'Gasoline 92'),
                    tableRow('1323', 'Gasoil'),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
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
                              builder: (context) => const InvoiceScreen()));
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 20,
                        color: MyColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ]))),
    );
  }

  TableRow tableRow(String code, String product) {
    return TableRow(children: [
      Text(code),
      Text(
        product,
        maxLines: 1,
        style: const TextStyle(fontSize: 12),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: 40,
        height: 25,
        child: Image.asset(
          "assets/images/desel car.png",
          fit: BoxFit.cover,
        ),
      ),
      Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: MyColor.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          style: const TextStyle(
              height: 1.5, fontSize: 16, color: MyColor.blackColor),
          decoration: InputDecoration(border: InputBorder.none),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
      ),
      Text(
        '  L',
        style: TextStyle(color: MyColor.grey, fontSize: 30),
      ),
    ]);
  }
}
