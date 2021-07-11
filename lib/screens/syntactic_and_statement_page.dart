
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdesktopapp/ui_elements/single_graph.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/graphs_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';



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

  ScreenshotController screenshotController = ScreenshotController();
  int _counter = 0;
  Uint8List _imageFile;

  @override
  void initState() {
    super.initState();
    durationOfSingleGraph = 900;
    totalDuration = widget.numberOfGraphs * durationOfSingleGraph;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));


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
      print("Test: " + graphIndex.toString());
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
    final graphProvider = Provider.of<GraphProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      graphProvider.visualizedGraphIndex = graphIndex;
    });


    return Container(
      child: Column(
        children: [
          Expanded(flex:1, child: Center(child: Text("Parsing Tree", style: text_style_phase_title))),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 500000000,
                  width: 500000000,
                  child: Container(
                    child: SingleGraph(graphIndex, widget.statementIndex, _animationController, animationDuration),
                    ),
                  ),
                ),
          ),
            ),
        ],
      ),
    );
  }
}
