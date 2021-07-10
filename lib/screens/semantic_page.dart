
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/ui_elements/single_graph.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';



class SemanticPage extends StatefulWidget {
  final int numberOfGraphs;
  final int visualizedStatementIndex;

  SemanticPage(this.numberOfGraphs, this.visualizedStatementIndex);

  final semanticStatementPageKey = GlobalKey<_SemanticStatementPageState>();

  @override
  _SemanticPageState createState() => _SemanticPageState();

}

class _SemanticPageState extends State<SemanticPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SemanticStatementPage(key: widget.semanticStatementPageKey, numberOfGraphs: widget.numberOfGraphs, statementIndex: widget.visualizedStatementIndex),
    );
  }
}

class SemanticStatementPage extends StatefulWidget {
  final int numberOfGraphs;
  final int statementIndex;
  const SemanticStatementPage({Key key, this.numberOfGraphs, this.statementIndex}) : super(key: key);

  @override
  _SemanticStatementPageState createState() => _SemanticStatementPageState();
}

class _SemanticStatementPageState extends State<SemanticStatementPage> with TickerProviderStateMixin{
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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [ElevatedButton(onPressed: (){
              screenshotController.capture().then((Uint8List image) async {
                //Capture Done
                setState(() {
                  _imageFile = image;
                  print("hi");
                });


                Directory directory = await getTemporaryDirectory();
                String fileName = "Hi.png";
                var p = directory.path;
                var path = '$p';
                print(path);
                screenshotController.captureAndSave(path, fileName:fileName);

              }).catchError((onError) {
                print(onError);
              });


            }, child: Text("Capture The Graph")),
              Screenshot(
                controller: screenshotController,
                child: SizedBox(
                  height: 500000000,
                  width: 500000000,
                  child: Container(
                    child: SingleGraph(graphIndex, widget.statementIndex, _animationController, animationDuration),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
