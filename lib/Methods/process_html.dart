import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:tumbler/Methods/Api.dart";

/// Get URL for all the Encoded Images, Videos, Audios
/// in [htmlBeforeProcessing] from [Api]
Future<String> extractMediaFiles(final String htmlBeforeProcessing) async {
  // Getting all images
  String html = htmlBeforeProcessing;
  int index1 = 0;
  int index2 = 0;
  int x = 0;
  Map<String, dynamic> url;

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<img src=", index1);
    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded image
      index1 = html.indexOf('"', index2); // the end of the encoded image
      /*html = html.replaceRange(
          x + 10, index1, "lolphoto");*/ //this line should be removed
      index1 = html.indexOf(
        '"',
        index2,
      ); //repeating this line is important since the html size
          // changes in each iteration
      //var mpf = MultipartFile(field, stream, length)
      url = await Api().uploadImage(
        File.fromRawPath(
          base64Decode(html.substring(index2 + 1, index1).trim()),
        ),
      );

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(x + 10, index1, "lolphoto");
      } else {
        await Fluttertoast.showToast(
          msg: "Failed To Upload Images",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    }
  }

  // Getting all Videos
  index1 = 0;
  index2 = 0;
  x = 0;
  url = <String, dynamic>{};

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<video", index1);

    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded video
      index1 = html.indexOf('"', index2); // the end of the encoded video
      /* html = html.replaceRange(
          x + 24, index1, "lolVideo");*/ //this line should be removed
      index1 = html.indexOf(
        '"',
        index2,
      ); //repeating this line is important since the html size
          // changes in each iteration
      url = await Api().uploadVideo(
        File.fromRawPath(
          base64Decode(html.substring(index2 + 1, index1).trim()),
        ),
      );

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(x + 24, index1, url["response"]["url"]);
      } else {
        await Fluttertoast.showToast(
          msg: "Failed To Upload videos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    }
  }

  // Getting all Audio
  index1 = 0;
  index2 = 0;
  x = 0;
  url = <String, dynamic>{};

  while (x != -1 && index1 <= html.length - 25) {
    x = html.indexOf("<audio", index1);
    if (x != -1) {
      index2 = html.indexOf(",", x); // the start of the encoded audio
      index1 = html.indexOf('"', index2); // the end of the encoded audio
      /*html = html.replaceRange(
          x + 24, index1, "lolAudio");*/ //this line should be removed
      index1 = html.indexOf(
        '"',
        index2,
      ); //repeating this line is important since the html size
      // changes in each iteration
      url = await Api().uploadAudio(
        File.fromRawPath(
          base64Decode(html.substring(index2 + 1, index1).trim()),
        ),
      );

      if (url["meta"]["status"] == "200") {
        html = html.replaceRange(x + 24, index1, url["response"]["url"]);
      } else {
        await Fluttertoast.showToast(
          msg: "Failed To Upload Audios",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16,
        );
      }
    }
  }
  return html;
}
