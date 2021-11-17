import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Screens/Home Page/home_page.dart';
import './Providers/posts.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => Posts(),
    child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          accentColor: Colors.amberAccent,
        ),
        home: HomePage()
        ),
  ));
}
