
import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/screens/select_visualization_mode.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/ui_elements/code_text.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      builder: (context, child){
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
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded( flex:3, child:CardBox(child: CodeText(),)),
                      Expanded( flex:1, child:CardBox(child: Container())),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: CardBox(child: Modes())),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
