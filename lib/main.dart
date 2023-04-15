import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Name Picker',
      home: RandomNamePicker(),
    );
  }
}

class RandomNamePicker extends StatefulWidget {
  @override
  _RandomNamePickerState createState() => _RandomNamePickerState();
}

class _RandomNamePickerState extends State<RandomNamePicker> {
  int _clientCount = 0;
  List<String> _names = [];

  @override
  void initState() {
    super.initState();
    _generateNames();
  }

  void _generateNames() {
    setState(() {
      _names = List.generate(_clientCount, (index) => '');
    });
  }

  void _pickRandomNames() {
    setState(() {
      _names.shuffle();
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(names: _names)),
    ).then((value) {
      // Return from ResultScreen
      _generateNames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Name Picker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter the number of clients',
                ),
                onChanged: (value) {
                  setState(() {
                    _clientCount = int.tryParse(value) ?? 0;
                    _generateNames();
                  });
                },
              ),
            ),
            if (_clientCount > 0)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: List.generate(_clientCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Enter the name of client ${index + 1}',
                        ),
                        onChanged: (value) {
                          _names[index] = value;
                        },
                      ),
                    );
                  }),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _clientCount > 0 ? _pickRandomNames : null,
                child: Text('Pick Random Names'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<String> names;

  ResultScreen({required this.names});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Name Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(names.length, (index) {
            return Text(
              '${index + 1}. ${names[index]}',
              style: TextStyle(fontSize: 24.0),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
