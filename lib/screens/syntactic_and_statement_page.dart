import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/freescrollview.dart';
import 'package:flutterdesktopapp/ui_elements/single_graph.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';


class SyntacticPage extends StatefulWidget {
 final int numberOfGraphs;
 final int visualizedStatementIndex;

 SyntacticPage(this.numberOfGraphs, this.visualizedStatementIndex);

  final statementPageKey = GlobalKey<_StatementPageState>();

  @override
  _SyntacticPageState createState() => _SyntacticPageState();

}

class _SyntacticPageState extends State<SyntacticPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StatementPage(key: widget.statementPageKey, numberOfGraphs: widget.numberOfGraphs, statementIndex: widget.visualizedStatementIndex),
    );
  }
}

class StatementPage extends StatefulWidget {
  final int numberOfGraphs;
  final int statementIndex;
  const StatementPage({Key key, this.numberOfGraphs, this.statementIndex}) : super(key: key);

  @override
  _StatementPageState createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> with TickerProviderStateMixin{
  AnimationController _animationController;
  double animationDuration;
  int durationOfSingleGraph;
  int totalDuration;

  @override
  void initState() {
    super.initState();
    durationOfSingleGraph = 1500;
    totalDuration = widget.numberOfGraphs * durationOfSingleGraph;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));

    animationDuration = durationOfSingleGraph / totalDuration;
    _animationController.forward();
  }

  @override
  void dispose() {
    print("Statement Disposed");
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FreeScrollView(
        child: SizedBox(
          height: 2000,
          width: 800,
          child: Container(
            child: Stack(
              children: List.generate(widget.numberOfGraphs, (index) => SingleGraph(index, widget.statementIndex, _animationController, animationDuration)),
            ),
          ),
        ),
      ),
    );
  }
}
