import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/single_graph.dart';
import 'package:flutterdesktopapp/ui_elements/freescrollview.dart';

class StatementPage extends StatefulWidget {
  int statementIndex;

  StatementPage(this.statementIndex);

  @override
  _StatementPageState createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> with TickerProviderStateMixin{
  AnimationController _animationController;
  double animationDuration = 0.0;
  int NumberOfGraphs = 20;

  @override
  void initState() {
    super.initState();
    final int durationOfSingleGraph = 1500;
    final int totalDuration = NumberOfGraphs * durationOfSingleGraph;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));

    animationDuration = durationOfSingleGraph / totalDuration;
    _animationController.forward();
  }

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
