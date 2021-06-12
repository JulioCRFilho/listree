import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listree/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listree',
      home: Home(),
    );
  }
}
