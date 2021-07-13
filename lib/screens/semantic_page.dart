import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/graphs_provider.dart';
import 'package:provider/provider.dart';

import 'ast_graph.dart';

class SemanticPage extends StatefulWidget {
  final int numberOfSteps;
  final int visualizedStatementIndex;

  SemanticPage(this.numberOfSteps, this.visualizedStatementIndex);

  final semanticStatementPageKey = GlobalKey<_SemanticStatementPageState>();

  @override
  _SemanticPageState createState() => _SemanticPageState();
}

class _SemanticPageState extends State<SemanticPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SemanticStatementPage(
          key: widget.semanticStatementPageKey,
          numberOfSteps: widget.numberOfSteps,
          statementIndex: widget.visualizedStatementIndex),
    );
  }
}

class SemanticStatementPage extends StatefulWidget {
  final int numberOfSteps;
  final int statementIndex;

  const SemanticStatementPage(
      {Key key, this.numberOfSteps, this.statementIndex})
      : super(key: key);

  @override
  _SemanticStatementPageState createState() => _SemanticStatementPageState();
}

class _SemanticStatementPageState extends State<SemanticStatementPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  double animationDuration;
  int durationOfSingleStep;
  int totalDuration;
  int stepIndex = 0;
  Animation animation;

  @override
  void initState() {
    super.initState();
    durationOfSingleStep = 900;
    totalDuration = widget.numberOfSteps * durationOfSingleStep;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));

    _animationController.addListener(() {
      if (this.mounted) setState(() {});
    });

    animationDuration = durationOfSingleStep / totalDuration;
    _animationController.forward();
  }

  @override
  void setState(VoidCallback fn) {
    var start = (animationDuration * stepIndex).toDouble();
    var end = start + animationDuration;

    start *= totalDuration;
    end *= totalDuration;

    if (_animationController.lastElapsedDuration != null &&
        _animationController.lastElapsedDuration.inMilliseconds.toDouble() >
            end) {
      stepIndex++;
    }
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void dispose() {
    print("Statement AST Disposed");
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final graphProvider = Provider.of<GraphProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      graphProvider.visualizedStatementIndex = widget.statementIndex;
      graphProvider.visualizedStepIndex = stepIndex;
    });

    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Center(
                  child: Text("Abstract Syntax Tree",
                      style: text_style_phase_title))),
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
                    child: ASTGraph(stepIndex, widget.statementIndex,
                        _animationController, animationDuration),
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
