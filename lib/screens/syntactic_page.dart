import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/single_graph.dart';

class SyntacticPage extends StatelessWidget {
  const SyntacticPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int NumberOfGraphs = 2;
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 1000,
          width: 800,
          child: Stack(
            children: List.generate(NumberOfGraphs, (index) => SingleGraph(Duration(seconds: 2), index)),
          ),
        ),
      ),
    );
  }
}
