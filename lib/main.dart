
//import 'package:app/loginscreen.dart';
import 'package:app/splashscreen.dart';
//import 'package:app/splashscreen.dart';
//import 'package:app/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: SplashScreen(),
    );
  }
}
