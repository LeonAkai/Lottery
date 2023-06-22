import 'package:flutter/material.dart';
import 'home_screen.dart';
//
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: HomeScreen(),
        ),
      ),
    );
  }
}