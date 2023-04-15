import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '席を抽選！',
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

  void _shuffleNames() {
    setState(() {
      _names.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '席を抽選！',
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
                decoration: InputDecoration(
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
                    child: Text('抽選する'),
                  ),
                    Image.network('https://4.bp.blogspot.com/-H7_kwlbyOu4/V-KLOPJJd7I/AAAAAAAA-Cs/b2TWRY3qD6Y64qldDg0OBrN55j278PDkwCLcB/s400/game_kuji_man.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final List<String> names;

  ResultScreen({required this.names});

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
        title: Text('席を抽選！',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.names.length, (index) {
            return Text(
              '席${index + 1} ← ${_shuffledNames[index]}さん',
              style: TextStyle(fontSize: 24.0),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shuffleNames,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
