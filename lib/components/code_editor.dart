import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/code_text.dart';

class CodeEditor extends StatelessWidget {
  const CodeEditor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child:  Card(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CodeText(),
          ),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.blue,
              width: 3,
            ),
          ),
        )
    );
  }
}
