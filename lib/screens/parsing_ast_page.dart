import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/graphs_provider.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class ParsingASTPage extends StatefulWidget {
  @override
  _ParsingASTPageState createState() => _ParsingASTPageState();
}

class _ParsingASTPageState extends State<ParsingASTPage> {

  ScreenshotController screenshotController = ScreenshotController();
  int _counter = 0;
  Uint8List _imageFile;

  void _takeScreenshot(var context) {
    screenshotController.capture().then((Uint8List image) async {
      //Capture Done
      setState(() {
        _imageFile = image;
        print("hi");
      });

      Directory directory = await getDownloadsDirectory();
      String fileName = "Statement AST Tree" + ".png";
      var p = directory.path;
      var path = '$p';
      print(path);
      screenshotController.captureAndSave(path, fileName: fileName);
      final snackBar = SnackBar(
        content: Text('Graph is saved to $path'),
      );
      ;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Abstract Syntax Tree",
                      style: text_style_phase_title),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => _takeScreenshot(context),
                  )
                ],
              )),
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Screenshot(
                controller: screenshotController,
                  child: SizedBox(
                    width: 3000,
                    height: 2000,
                    child: Container(
                      child: ParsingASTGraph(),
                    ),
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

class ParsingASTGraph extends StatefulWidget {
  @override
  _ParsingASTGraphState createState() => _ParsingASTGraphState();
}

class _ParsingASTGraphState extends State<ParsingASTGraph> {
  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context, listen: false);
    final graphProvider = Provider.of<GraphProvider>(context);

    int statementIndex = appData.visualizedStatementIndex;
    int graphIndex = graphProvider.visualizedGraphIndex;

    var currentStatement = appData.parsedStatementsList[statementIndex];
    var astGraphIndex = currentStatement.astGraphIndexSync[graphIndex];

    if (astGraphIndex == -1) return Container();

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
          color: (astGraph.visitedNode[astGraphIndex] == int.parse(node.id)
              ? Colors.red
              : Colors.blue),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              // controller: scrollController,
              itemCount: astGraph.nodesData[astGraphIndex][node.id].length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                      child: Text(
                          astGraph.nodesData[astGraphIndex][node.id][index],
                          style: text_style_graph_title));
                }
                return Text(
                    "- " + astGraph.nodesData[astGraphIndex][node.id][index],
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
