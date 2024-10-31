import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class CustomProgressbar {
  static late ProgressDialog pr;

  ///Show Progressbar
  static void showProgressDialog(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Waitting...',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(strokeWidth: 3),
        elevation: 0.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        textAlign: TextAlign.center,
        maxProgress: 100.0,
        padding:
            const EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 15),
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.bold),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600));
    pr.show();
  }

  ///Hide Progressbar
  static void hideProgressDialog(BuildContext context) {
    pr = ProgressDialog(context);
    pr.hide();
    print("ProgressDialog  Hide");
  }
}
