import 'package:express/common_widgtets/copy_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiServices {
  Future<void> customPopUp(
      {required String key,
      required bool success,
      required double padding,
      double horizontalPadding = 20}) async {
    //---->>> Copy the deposit address to the clipboard

    if (key.isNotEmpty) {
      showDialog(
        context: Get.context!,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        builder: (_) =>
            CustomPopUp(text: key, success: success, padding: padding,horizontalPadding: horizontalPadding),
      );

      // Close the dialog after 1 seconds
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(Get.context!).pop(); // Close the dialog
      });
    }
  }
}
