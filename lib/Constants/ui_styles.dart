import 'package:flutter/material.dart';

ButtonStyle onStartButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all(Colors.black),
  backgroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  overlayColor: MaterialStateProperty.all(Colors.grey),
);

TextStyle titleTextStyle =
    const TextStyle(fontSize: 27, color: Color.fromRGBO(200, 209, 216, 1));

TextStyle subTitleTextStyle = const TextStyle(
  fontSize: 18,
  color: Color.fromRGBO(97, 111, 127, 1),
);

InputBorder formEnabledFieldBorderStyle = const UnderlineInputBorder(
  borderSide:
      BorderSide(color: Colors.white30, width: 1, style: BorderStyle.solid),
);
InputBorder formFocusedFieldBorderStyle = const UnderlineInputBorder(
  borderSide: BorderSide(
      color: Colors.black,
      width: 1,
      style: BorderStyle.solid), // color should be as theme
);
