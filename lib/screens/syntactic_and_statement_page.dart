import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/freescrollview.dart';
import 'package:flutterdesktopapp/ui_elements/single_graph.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';


class SyntacticPage extends StatefulWidget {
  final statementPageKey = GlobalKey<_StatementPageState>();

  @override
  _SyntacticPageState createState() => _SyntacticPageState();

}

class _SyntacticPageState extends State<SyntacticPage> {

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);

    return Container(
      child: StatementPage(key: widget.statementPageKey, statementIndex: appData.visualizedStatementIndex),
    );
  }
}

class StatementPage extends StatefulWidget {

  final int statementIndex;
  const StatementPage({Key key, this.statementIndex}) : super(key: key);

  @override
  _StatementPageState createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> with TickerProviderStateMixin{
  AnimationController _animationController;
  double animationDuration = 0.0;
  int NumberOfGraphs = 4;

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
    print("Statement Disposed");
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
              children: List.generate(NumberOfGraphs, (index) => SingleGraph(index, widget.statementIndex, _animationController, animationDuration)),
            ),
          ),
        ),
      ),
    );
  }
}
