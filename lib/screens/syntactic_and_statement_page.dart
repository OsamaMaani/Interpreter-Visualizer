import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/freescrollview.dart';
import 'package:flutterdesktopapp/ui_elements/single.dart';
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
  int graphIndex = 0;
  Animation animation;

  @override
  void initState() {
    super.initState();
    durationOfSingleGraph = 900;
    totalDuration = widget.numberOfGraphs * durationOfSingleGraph;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));



    animation = ColorTween(
      begin: Colors.black45,
      end: Colors.blue,
    ).animate(_animationController);

    _animationController.addListener((){
      if(this.mounted)
        setState(() {
        });
    });


    animationDuration = durationOfSingleGraph / totalDuration;
    _animationController.forward();
  }

  @override
  void setState(VoidCallback fn) {
    var start = (animationDuration * graphIndex).toDouble();
    var end = start + animationDuration;

    start *= totalDuration;
    end *= totalDuration;

    if(_animationController.lastElapsedDuration != null && _animationController.lastElapsedDuration.inMilliseconds.toDouble() > end){
      graphIndex++;
    }
    // TODO: implement setState
    super.setState(fn);
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
          height: 3000,
          width: 1000,
          child: Container(
            child: SingleGraph(graphIndex, widget.statementIndex, _animationController, animationDuration),
          ),
        ),
      ),
    );
  }
}
