

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alert {

  static void showAlert(String alertString) {
    Fluttertoast.showToast(
        msg: alertString,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}