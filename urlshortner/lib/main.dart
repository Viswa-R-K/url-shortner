import 'package:flutter/material.dart';
import 'package:urlshortner/home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "URL Shortner",
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
