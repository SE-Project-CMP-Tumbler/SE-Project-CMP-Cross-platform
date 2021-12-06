import "package:flutter/material.dart";

/// Return Specific Style
Widget customText(
  final String txt,
  final Color chosenColor,
  final double fontSize,
) {
  return Text(
    txt,
    style: TextStyle(
      color: chosenColor,
      fontSize: fontSize,
      fontFamily: "sans-serif",
      fontWeight: FontWeight.normal,
    ),
  );
}
