import 'package:flutter/material.dart';
import 'package:tumbler/Screens/Sign_Up_Screens/intro_screens/on_start_screen.dart';

void main() =>  runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /** return ChangeNotifierProvider(
        create: (_) => FollowedTags(),
        child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnStart(),
        ),
        );
     **/
    return const MaterialApp(
      home: OnStart(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Text("The Start");
  }
}
