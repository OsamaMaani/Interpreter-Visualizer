import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdesktopapp/ui_elements/text_highlighter.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';

class CodeText extends StatefulWidget {
  CodeText({Key key}) : super(key: key);

  @override
  _CodeTextState createState() => _CodeTextState();
}

class _CodeTextState extends State<CodeText> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context, listen: true);

    return SingleChildScrollView(
      child: SizedBox(
        height: 800,
        width: 1200,
        child: ((appData.isVisualized && appData.circleOneClicked))
            ? TextHighlighter()
            : TextField(
                controller: appData.editingController,
                autofocus: true,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Write some code here and visualize!",
                ),
                keyboardType: TextInputType.multiline,
                expands: true,
                maxLines: null,
              ),
      ),
    );
  }
}




/*
(appDate.isVisualized && appDate.circleOneClicked) ?
        RichText(
          text: TextSpan(
            text: 'Hello ',
            style: DefaultTextStyle.of(context).style,
            children: const <TextSpan>[
              TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' world!'),
            ],
          ),
        ):
 */
