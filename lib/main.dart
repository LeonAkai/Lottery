import 'package:flutter/material.dart';
import 'random_name_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: RandomNamePicker(),
    );
  }
}
