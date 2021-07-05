import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/single_graph.dart';
import 'package:flutterdesktopapp/ui_elements/freescrollview.dart';

class SyntacticPage extends StatefulWidget {
  // const SyntacticPage({Key? key}) : super(key: key);

  @override
  _SyntacticPageState createState() => _SyntacticPageState();
}

class _SyntacticPageState extends State<SyntacticPage> with TickerProviderStateMixin{
  AnimationController _animationController;
  double animationDuration = 0.0;
  int NumberOfGraphs = 4;

  @override
  void initState() {
    super.initState();
    final int totalDuration = NumberOfGraphs * 5000;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));
    animationDuration = totalDuration/(100*(totalDuration/NumberOfGraphs));
    _animationController.forward();
  }

  FlutterLogoStyle _logoStyle = FlutterLogoStyle.markOnly;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // int NumberOfGraphs = 4;
    return Container(
      child: FreeScrollView(
        child: SizedBox(
          height: 2000,
          width: 800,
          child: Container(
            child: Stack(
              children: List.generate(NumberOfGraphs, (index) => SingleGraph(index, _animationController, animationDuration)),
            ),
          ),
        ),
      ),
    );
  }
}
