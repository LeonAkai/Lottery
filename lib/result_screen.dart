import 'package:flutter/material.dart';

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
        title: Text(
          'Lottery',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
                style: TextStyle(fontSize: 24.0),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: _shuffleNames,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
