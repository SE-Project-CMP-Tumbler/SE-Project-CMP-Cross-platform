import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:tumbler/Methods/api.dart";
import "package:tumbler/Methods/local_db.dart";

/// Intermediate function that call [Api.logOut]
Future<bool> logOut() async {
  // TODO(Ziyad): Show dialog
  final Map<String, dynamic> response = await Api().logOut();

  if (response["meta"]["status"] == "200") {
    await LocalDataBase.instance.deleteAllTable();
    await Fluttertoast.showToast(
      msg: "Log Out",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16,
    );
    return true;
  } else {
    await Fluttertoast.showToast(
      msg: response["meta"]["msg"],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16,
    );
    return false;
  }
}
