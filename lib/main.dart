import 'package:flutter/material.dart';
import 'package:guitar_guide/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guitar Guide',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
