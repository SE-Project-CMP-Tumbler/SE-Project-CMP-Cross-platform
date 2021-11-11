import 'package:flutter/material.dart';
import './Widgets/Post/post_out_view.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.amberAccent,
      ),
      home: HomePage())
      
      
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tumblr"),
      ),
      body: ListView(
        children: const [
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
          PostOutView(),
        ]
      )
      
    );
  }
}
