import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';

class TextHighlighter extends StatefulWidget {
  // final int initialValue;
  //
  // TextHighlighter(this.initialValue);
  @override
  _TextHighlighterState createState() => _TextHighlighterState();

}

class _TextHighlighterState extends State<TextHighlighter> {

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context,listen: true);
    var list = appData.richTextList;
    // bool getTokensCnage(){
    //   return (appData.tokensChange || !(appData.tokensChange));
    // }
    return Container(
      child: RichText(
          text:
          TextSpan(
              children: list
                  .map((e){
                    return TextSpan(
                  text: e[0],
                  style: TextStyle( color: e[1],fontSize: 30, fontWeight: FontWeight.bold)
              );})
                  .toList())

      ),
    );
  }
}


