import "package:flutter/material.dart";

/// Style of buttons in [OnStart] page.
ButtonStyle onStartButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all(Colors.black),
  backgroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  overlayColor: MaterialStateProperty.all(Colors.grey),
);

/// Text Style Used in [Register], [GetAge],
/// [LogIN], [ForgetPassWord] for Titles.
TextStyle titleTextStyle =
    const TextStyle(fontSize: 27, color: Color.fromRGBO(200, 209, 216, 1));

/// Text Style Used in [Register], [GetAge],
/// [LogIN], [ForgetPassWord] for Subtitles
TextStyle subTitleTextStyle = const TextStyle(
  fontSize: 18,
  color: Color.fromRGBO(97, 111, 127, 1),
);

/// Text Form Style Used in [Register], [GetAge],
/// [LogIN], [ForgetPassWord] for TextFormFields
InputBorder formEnabledFieldBorderStyle = const UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white30),
);

/// Text Form Style Used in [Register], [GetAge],
/// [LogIN], [ForgetPassWord] for TextFormFields
InputBorder formFocusedFieldBorderStyle = const UnderlineInputBorder();

