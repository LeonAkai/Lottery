// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final List<String> names;

  const ResultScreen({super.key, required this.names});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late List<String> _shuffledNames;

  @override
  void initState() {
    super.initState();
    _shuffledNames = List.from(widget.names)..shuffle();
  }

  void _shuffleNames() {
    setState(() {
      _shuffledNames.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lottery',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/haikei.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.names.length, (index) {
              return Text(
                '席${index + 1} ← ${_shuffledNames[index]} 様',
                style: const TextStyle(fontSize: 24.0),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: _shuffleNames,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
