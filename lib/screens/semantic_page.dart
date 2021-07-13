import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/graphs_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

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
      String fileName = "AST Tree Statement #" +
          widget.statementIndex.toString() +
          ".png";
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Abstract Syntax Tree",
                      style: text_style_phase_title),
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
                    height: 3000,
                    width: 2000,
                    child: Container(
                      child: ASTGraph(stepIndex, widget.statementIndex,
                          _animationController, animationDuration),
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
