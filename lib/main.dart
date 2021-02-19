import 'package:flutter/material.dart';
import 'package:sampleproject/pages/sinavlar_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Coktan Secmeli",
      home: SinavlarPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}