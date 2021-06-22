import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeText extends StatelessWidget {
  const CodeText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 700,
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Write some code here and visualize!",

          ),
          keyboardType: TextInputType.multiline,
          expands: true,
          maxLines: null,
         // maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      ),
    );
  }
}
