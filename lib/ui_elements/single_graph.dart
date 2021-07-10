import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';
import 'package:provider/provider.dart';


class SingleGraph extends StatefulWidget {
  final int statementIndex;
  final int index;
  final double duration;
  final AnimationController animationController;
  SingleGraph(this.index, this.statementIndex, this.animationController, this.duration);

  @override
  _SingleGraphState createState() => _SingleGraphState();
}

class _SingleGraphState extends State<SingleGraph> {
  Animation animation;
  Animation animationColor;
  double start;
  double end;
  var showErrors = true;

  @override
  void initState() {
    print(widget.index.toString() + " signing in");
    super.initState();
    start = (widget.duration * widget.index ).toDouble();
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




    animationColor = ColorTween(
      begin: Colors.white,
      end: Colors.black87,
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

    widget.animationController.addListener((){
      if(this.mounted)
        setState(() {
        });
    });

  }


  @override
  void dispose() {
    print("Graph Disposed");
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // ScrollController scrollController = ScrollController();
    // var scrollToBottom = (){
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
    // };


    var appData = Provider.of<AppData>(context);
    var currentStatement = appData.parsedStatementsList[widget.statementIndex];
    var graph = nodeInputFromJson(currentStatement.graphs[widget.index].toString());



    final utilsProvider = Provider.of<UtilitiesProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // scrollToBottom();

      var currentErrors = currentStatement.errors[widget.index];
      if (showErrors && currentErrors != null && currentErrors.isNotEmpty) {
        for (var error in currentErrors) {
          utilsProvider.addConsoleMessage(error, 0);
        }
        showErrors = false;
      }



    var consumedTokens = currentStatement.consumedTokens[widget.index];
    if(consumedTokens != null && consumedTokens.isNotEmpty) {
      for (int token in consumedTokens) {
        var tokenIndex = appData.tokensIndices[token];
        var tokenGoalColor = appData.tokensColors[tokenIndex];
        Color t = tokenGoalColor;
        Color x = animationColor.value;
        print(x.opacity);
        utilsProvider.richTextList[tokenIndex][1] = t.withOpacity(x.opacity);
      }
      var temp1 = List.from(utilsProvider.richTextList);
      utilsProvider.richTextList = temp1;
    }
    });

    print(widget.index);

    return Opacity(
      opacity: animation.value,
      child: AbsorbPointer(absorbing: false,
        child: DirectGraph(
          list: graph,
          cellWidth: 180.0,
          cellPadding: 14.0,
          contactEdgesDistance: 5.0,
          orientation: MatrixOrientation.Vertical,
          // pathBuilder: customEdgePathBuilder,
          builder: (ctx, node) {
            return Container(
              color: (currentStatement.visitedNode[widget.index] == int.parse(node.id) ? Colors.red : Colors.blue),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  // controller: scrollController,
                  itemCount: currentStatement.nodesData[widget.index][node.id].length,
                  itemBuilder: (context, index){
                    if(index == 0){
                      return Center(child: Text(currentStatement.nodesData[widget.index][node.id][index], style: text_style_graph_title));
                    }
                    return Text("- " + currentStatement.nodesData[widget.index][node.id][index], style: text_style_graph_text);
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
        ),
      ),
    );
  }


  Path customEdgePathBuilder(List<List<double>> points) {
    var path = Path();
    path.moveTo(points[0][0], points[0][1]);
    points.sublist(1).forEach((p) {
      path.lineTo(p[0], p[1]);
    });
    return path;
  }

}


