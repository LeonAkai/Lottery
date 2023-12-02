// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class ResultScreen extends StatefulWidget {
  final List<String> names;

  const ResultScreen({super.key, required this.names});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late List<String> _shuffledNames;
  final GlobalKey _tableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _shuffledNames = List.from(widget.names);
  }

  void _shuffleNames() {
    setState(() {
      _shuffledNames.shuffle();
    });
  }

  void _downloadExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      for (var name in _shuffledNames) {
        var index = _shuffledNames.indexOf(name);
        sheetObject.appendRow(['${index + 1}', name]);
      }
      var fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();
      File('${directory.path}/table_data.xlsx')
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('エクセルファイルがダウンロードされました: ${directory.path}/table_data.xlsx'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('エクセルファイルのダウンロードに失敗しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadImage() async {
    try {
      RenderRepaintBoundary boundary = _tableKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        var directory = await getApplicationDocumentsDirectory();
        File imgFile = File('${directory.path}/table_data.png');
        await imgFile.writeAsBytes(pngBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('画像ファイルがダウンロードされました: ${directory.path}/table_data.png'),
          ),
        );
      } else {
        throw Exception('画像データが取得できませんでした。');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('画像ファイルのダウンロードに失敗しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/haikei.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: RepaintBoundary(
              key: _tableKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.withOpacity(0.2)),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(0.2),
                        1: FlexColumnWidth(1.0),
                      },
                      children: List<TableRow>.generate(
                        _shuffledNames.length,
                        (index) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('${index + 1}'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('${_shuffledNames[index]} 様'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _shuffleNames,
            heroTag: null,
            child: const Icon(Icons.shuffle),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _downloadExcel,
            heroTag: 'excel',
            child: const Icon(Icons.file_download),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _downloadImage,
            heroTag: 'image',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
