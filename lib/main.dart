import 'package:flutter/material.dart';
import './Screens/Home Page/home_page.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.amberAccent,
      ),
      home: HomePage()
      ));
}
