// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'result_screen.dart';

class RandomNamePicker extends StatefulWidget {
  const RandomNamePicker({super.key});

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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ResultScreen(names: _names),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ).then((value) {
      // Return from ResultScreen
      _generateNames();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '参加者の人数を入力してください',
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
                          labelText: '参加者 ${index + 1} の名前を入力してください',
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
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _clientCount > 0 ? _pickRandomNames : null,
                    child: const Text('抽選する'),
                  ),
                  Image.network(
                      'https://loosedrawing.com/assets/illustrations/png/903.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
