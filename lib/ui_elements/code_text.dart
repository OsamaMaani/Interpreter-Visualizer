import 'package:flutter/material.dart';

class CodeText extends StatelessWidget {
  const CodeText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,//Normal textInputField will be displayed
        maxLines: 100,//
        // when user presses enter it will adapt to it
      ),
    );
    // return RichText(text: TextSpan(
    //   text: 'Hello'
    // ),);
  }
}
