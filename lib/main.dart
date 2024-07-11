import 'package:ecom/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
