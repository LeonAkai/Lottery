import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:xml/xml.dart';
import 'dart:io';
import 'result_screen.dart';

class FileImportScreen extends StatefulWidget {
  const FileImportScreen({Key? key}) : super(key: key);

  @override
  _FileImportScreenState createState() => _FileImportScreenState();
}

class _FileImportScreenState extends State<FileImportScreen> {
  List<String> _names = [];
  Map<String, bool> _selectedNames = {};
  int _selectedColumn = 0;

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileExtension = result.files.single.extension!;
        switch (fileExtension) {
          case 'txt':
            _loadNamesFromTextFile(file);
            break;
          case 'docx':
            _loadNamesFromWordFile(file);
            break;
          case 'xlsx':
            _showColumnPickerDialog(file);
            break;
          default:
            _showErrorMessage('未対応のファイル形式です。');
            break;
        }
      }
    } catch (e) {
      _showErrorMessage('ファイルの読み込みに失敗しました。');
    }
  }

  void _loadNamesFromTextFile(File file) async {
    String content = await file.readAsString(encoding: utf8);
    List<String> names = content.split('\n');
    setState(() {
      _names = names;
      _selectedNames = Map.fromIterable(names, key: (e) => e, value: (e) => false);
    });
  }

  void _loadNamesFromWordFile(File file) async {
    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    
    for (final file in archive) {
      if (file.isFile && file.name == "word/document.xml") {
        final document = XmlDocument.parse(String.fromCharCodes(file.content as List<int>));
        final paragraphs = document.findAllElements('w:p');
        
        final extractedNames = paragraphs.map((node) => 
          node.text.trim()).where((text) => text.isNotEmpty).toList();

        setState(() {
          _names = extractedNames;
        });

        break;
      }
    }
  }

  void _loadNamesFromExcelFile(File file, int column) async {
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    List<String> names = [];

    for (var table in excel.tables.keys) {
      var rows = excel.tables[table]!.rows;
      for (var row in rows) {
        if (row.length > column && row[column] != null) {
          names.add(row[column]!.value.toString());
        }
      }
      break; // 最初のシートのみ処理
    }

    setState(() {
      _names = names;
      _selectedNames = Map.fromIterable(names, key: (e) => e, value: (e) => false);
    });
  }

  void _showColumnPickerDialog(File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('読み込む列を選択'),
          content: DropdownButton<int>(
            value: _selectedColumn,
            items: List.generate(10, (index) {
              return DropdownMenuItem(
                value: index,
                child: Text('列 ${index + 1}'),
              );
            }),
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedColumn = newValue;
                });
                Navigator.of(context).pop();
                _loadNamesFromExcelFile(file, newValue);
              }
            },
          ),
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _removeSelectedNames() {
    setState(() {
      _names.removeWhere((name) => _selectedNames[name] ?? false);
      _selectedNames.removeWhere((key, value) => value);
    });
  }

  void _goToResultScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(names: _names)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ファイルから読み込む'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('ファイルを選択'),
            ),
            ElevatedButton(
              onPressed: _removeSelectedNames,
              child: const Text('選択した名前を削除'),
            ),
            ElevatedButton(
              onPressed: _names.isNotEmpty ? _goToResultScreen : null,
              child: const Text('抽選する'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _names.length,
                itemBuilder: (context, index) {
                  final name = _names[index];
                  return ListTile(
                    title: Text(name),
                    leading: Checkbox(
                      value: _selectedNames[name] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedNames[name] = value!;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
