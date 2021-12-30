import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

/// Show Toast message to the user
Future<void> showToast(final String msg) async {
  print(msg);
  await Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16,
  );
}
