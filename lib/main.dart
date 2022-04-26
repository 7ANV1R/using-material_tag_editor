import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_tag_editor/tag_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material Tag Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Recovery Phrase',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF23262F),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Write down or copy these words in the right order and save them somewhere safe',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777E90),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TagEditor(
                  length: _values.length,
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  delimiters: const [',', ' ', '\n'],
                  hasAddButton: false,
                  resetTextOnSubmitted: false,
                  // This is set to grey just to illustrate the `textStyle` prop
                  textStyle: const TextStyle(color: Colors.grey),
                  onSubmitted: (outstandingValue) {
                    if (_textEditingController.text != '') {
                      setState(() {
                        _values.add(outstandingValue);
                      });
                    }
                  },
                  inputDecoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                  ),
                  onTagChanged: (newValue) {
                    setState(() {
                      _values.add(newValue);
                    });
                  },
                  tagBuilder: (context, index) => _Chip(
                    index: index,
                    label: _values[index],
                    onDeleted: _onDelete,
                  ),
                  // InputFormatters example, this disallow \ and /
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: const Color(0xFF1652F0),
      labelPadding: const EdgeInsets.only(left: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      label: Text(
        '${index + 1} $label',
        style: const TextStyle(color: Colors.white),
      ),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
        color: Colors.white,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
