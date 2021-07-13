import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';
import 'package:provider/provider.dart';

class ASTGraph extends StatefulWidget {
  final int statementIndex;
  final int index;
  final double duration;
  final AnimationController animationController;

  ASTGraph(
      this.index, this.statementIndex, this.animationController, this.duration);

  @override
  _ASTGraphState createState() => _ASTGraphState();
}

class _ASTGraphState extends State<ASTGraph> {
  Animation animation;
  Animation animationColor;
  double start;
  double end;
  var showErrors = true;
  var showOutput = true;

  @override
  void initState() {
    print(widget.index.toString() + " signing in");
    super.initState();
    start = (widget.duration * widget.index).toDouble();
    end = start + widget.duration;
    print("START $start , end $end");

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );

    widget.animationController.addListener(() {
      if (this.mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    print("AST Graph Disposed");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context, listen: false);
    final utilsProvider =
        Provider.of<UtilitiesProvider>(context, listen: false);

    var currentStatement = appData.astsList[widget.statementIndex];

    var graph = nodeInputFromJson(currentStatement.astGraph);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var error = currentStatement.errors[widget.index];
      if (showErrors && error != null && error != "") {
        utilsProvider.addConsoleMessage(error, 0);
        showErrors = false;
      }
      var outputMessage = currentStatement.outputMessages[widget.index];
      if (showOutput && outputMessage != null && outputMessage != "") {
        utilsProvider.addConsoleMessage(outputMessage, 1);
        showOutput = false;
      }
    });

    return DirectGraph(
      list: graph,
      cellWidth: 180.0,
      cellPadding: 14.0,
      contactEdgesDistance: 5.0,
      orientation: MatrixOrientation.Vertical,
      // pathBuilder: customEdgePathBuilder,
      builder: (ctx, node) {
        return Container(
          color:
              (currentStatement.visitedNode[widget.index] == int.parse(node.id)
                  ? Colors.red
                  : Colors.blue),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              // controller: scrollController,
              itemCount:
                  currentStatement.nodesData[widget.index][node.id].length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                      child: Text(
                          currentStatement.nodesData[widget.index][node.id]
                              [index],
                          style: text_style_graph_title));
                }
                return Text(
                    "- " +
                        currentStatement.nodesData[widget.index][node.id]
                            [index],
                    style: text_style_graph_text);
              },
            ),
          ),
        );
      },
      paintBuilder: (edge) {
        var p = Paint()
          ..color = Colors.blueGrey
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 2;
        return p;
      },
    );
  }
}
