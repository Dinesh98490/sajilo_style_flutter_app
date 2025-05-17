// toast_utils.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showToast({
    required String message,
    Color backgroundColor = Colors.black87,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int durationSeconds = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: durationSeconds == 2 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
