import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/screens/select_visualization_mode.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/ui_elements/code_text.dart';
import 'package:flutterdesktopapp/ui_elements/console_panel.dart';
import 'package:flutterdesktopapp/ui_elements/control_buttons.dart';
import 'package:flutterdesktopapp/ui_elements/symbol_table.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';

import 'parsing_ast_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

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
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 3,
                      child: CardBox(
                        child: CodeText(),
                      )),
                  Expanded(flex: 1, child: CardBox(child: ConsolePanel())),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: CardBox(child: ControlButtons())),
                  Expanded(
                      flex: 7,
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: CardBox(child: Modes())),
                          Visibility(
                              visible: appData.circleTwoClicked,
                              child: Expanded(
                                  flex: 1,
                                  child: CardBox(child: ParsingASTPage()))),
                        ],
                      )),
                  Visibility(
                    visible: (appData.circleThreeClicked),
                    child:
                        Expanded(flex: 3, child: CardBox(child: SymbolTable())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
