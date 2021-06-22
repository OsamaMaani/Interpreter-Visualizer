import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/components/code_editor.dart';
import 'package:flutterdesktopapp/components/console_panel.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/ui_elements/code_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interpreter Visualizer"),
      ),
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
           //   flex: 2,
              child: Column(
              //  mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded( flex:3,child:CardBox(child: Container(),)),
                  Expanded( flex:1,child:CardBox(child: Container())),
                ],
              ),
            ),
            Expanded(
          //    flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: CardBox(child: Container())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
