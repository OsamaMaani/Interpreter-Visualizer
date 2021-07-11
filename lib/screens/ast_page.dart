import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/graphs_provider.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';
import 'package:provider/provider.dart';

class ASTPage extends StatefulWidget {
  // const ASTPage({Key? key}) : super(key: key);

  // int visualizedGraphIndex;
  //
  // ASTPage(this.visualizedGraphIndex);

  @override
  _ASTPageState createState() => _ASTPageState();
}

class _ASTPageState extends State<ASTPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Expanded(flex:1, child: Center(child: Text("Abstract Syntax Tree", style: text_style_phase_title))),
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 500000000,
                  height: 500000000,
                  child: Container(
                    child: ASTGraph(),
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


class ASTGraph extends StatefulWidget {
  @override
  _ASTGraphState createState() => _ASTGraphState();
}

class _ASTGraphState extends State<ASTGraph> {
  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context, listen: false);
    final graphProvider = Provider.of<GraphProvider>(context);

    int statementIndex = appData.visualizedStatementIndex;
    int graphIndex = graphProvider.visualizedGraphIndex;

    var currentStatement = appData.parsedStatementsList[statementIndex];
    var astGraphIndex = currentStatement.astGraphIndexSync[graphIndex];

    if(astGraphIndex == -1) return Container();

    var astGraph = currentStatement.astGraph;

    var graph = nodeInputFromJson(astGraph.graphs[astGraphIndex].toString());


    return DirectGraph(
      list: graph,
      cellWidth: 180.0,
      cellPadding: 14.0,
      contactEdgesDistance: 5.0,
      orientation: MatrixOrientation.Vertical,
      // pathBuilder: customEdgePathBuilder,
      builder: (ctx, node) {
        return Container(
          color: (astGraph.visitedNode[astGraphIndex] == int.parse(node.id) ? Colors.red : Colors.blue),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              // controller: scrollController,
              itemCount: astGraph.nodesData[astGraphIndex][node.id].length,
              itemBuilder: (context, index){
                if(index == 0){
                  return Center(child: Text(astGraph.nodesData[astGraphIndex][node.id][index], style: text_style_graph_title));
                }
                return Text("- " + astGraph.nodesData[astGraphIndex][node.id][index], style: text_style_graph_text);
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
