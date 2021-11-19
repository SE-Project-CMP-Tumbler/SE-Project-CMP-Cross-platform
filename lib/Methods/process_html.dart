import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Methods/Api.dart';

Future<String> extractMediaFiles(String htmlBeforeProcessing) async {
  // Getting all images
  String html = htmlBeforeProcessing;
  int index1 = 0;
  int index2 = 0;
  int x = 0;
  Map<String, dynamic> url;

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<img src='data:image/", index1);
    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded image
      index1 = html.indexOf("'", index2); // the end of the encoded image

      url = await Api().uploadImage(File.fromRawPath(
          base64Decode(html.substring(index2 + 1, index1).trim())));

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(x + 10, index1, url["response"]["url"]);
      } else {
        Fluttertoast.showToast(
            msg: "Failed To Upload Images",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  // Getting all Videos
  index1 = 0;
  index2 = 0;
  x = 0;
  url = {};

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<video src='data:video/", index1);

    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded video
      index1 = html.indexOf("'", index2); // the end of the encoded video
      url = await Api().uploadVideo(File.fromRawPath(
          base64Decode(html.substring(index2 + 1, index1).trim())));

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(x + 12, index1, url["response"]["url"]);
      } else {
        Fluttertoast.showToast(
            msg: "Failed To Upload videos",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  // Getting all Audio
  index1 = 0;
  index2 = 0;
  x = 0;
  url = {};

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<audio src='data:audio/", index1);
    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded video
      index1 = html.indexOf("'", index2); // the end of the encoded video
      url = await Api().uploadAudio(File.fromRawPath(
          base64Decode(html.substring(index2 + 1, index1).trim())));

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(x + 12, index1, url["response"]["url"]);
      } else {
        Fluttertoast.showToast(
            msg: "Failed To Upload Audios",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
  return html;
}
