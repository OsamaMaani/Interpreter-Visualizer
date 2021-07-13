import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:provider/provider.dart';

class TextHighlighter extends StatefulWidget {
  @override
  _TextHighlighterState createState() => _TextHighlighterState();
}

class _TextHighlighterState extends State<TextHighlighter> {
  @override
  Widget build(BuildContext context) {
    final utilsProvider = Provider.of<UtilitiesProvider>(context);
    var list = utilsProvider.richTextList;

    return Container(
      child: RichText(
          text: TextSpan(
              children: list.map((e) {
        return TextSpan(
            text: e[0],
            style: TextStyle(
                backgroundColor: e[1],
                fontSize: 30,
                fontWeight: FontWeight.bold));
      }).toList())),
    );
  }
}
