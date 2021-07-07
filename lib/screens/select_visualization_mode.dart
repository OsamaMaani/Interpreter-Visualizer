import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/screens/full_visualization.dart';
import 'package:flutterdesktopapp/screens/semantic_page.dart';
import 'package:flutterdesktopapp/screens/syntactic_and_statement_page.dart';
import 'package:flutterdesktopapp/screens/tokens_page.dart';
import 'package:flutterdesktopapp/screens/first_page.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/file_processes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutterdesktopapp/services/networking.dart';

class Modes extends StatefulWidget {
  Modes({Key key}) : super(key: key);

  @override
  _ModesState createState() => _ModesState();
}

class _ModesState extends State<Modes> {
  FileStorage fileStorage;
  NetworkHelper networkHelper = NetworkHelper();

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    Widget getClickedPage() {
      if (appData.isVisualized && appData.circleOneClicked) {
        return TokensPage(appData.tokensList.length);
      } else if (appData.isVisualized && appData.circleTwoClicked) {
        return SyntacticPage(4,
            appData.visualizedStatementIndex); //TODO add number of graphs ref
      } else if (appData.isVisualized && appData.circleThreeClicked)
        return SemanticPage();
      else if (appData.isVisualized && appData.circleFourClicked)
        return FullVisualization();

      return PageOne();
    }

    String getText() {
      if (appData.isVisualized &&
          (appData.circleOneClicked ||
              appData.circleTwoClicked ||
              appData.circleThreeClicked ||
              appData.circleFourClicked))
        return "Back";
      else
        return "Visualize";
    }

    Function getPrevButtonFunc() {
      if (appData.circleTwoClicked && appData.visualizedStatementIndex > 0) {
        return () {
          appData.visualizedStatementIndex--;
        };
      }
      return null;
    }

    Function getNextButtonFunc() {
      if (appData.circleTwoClicked) {
        return () {
          appData.visualizedStatementIndex++;
        };
      }
      return null;
    }

    void showAlertDialog(BuildContext context) {
      Widget okButton = ElevatedButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Notice"),
        content: Text(
            "Please, write down some code before attempting to visualize!"),
        actions: [
          okButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future<String> readFile() async {
      final String data = await rootBundle.loadString('assets/tokens_file.txt');
      return data;
    }

    void compile(List consoleMessages) {
      appData.addConsoleMessageList(consoleMessages);
      var sourceCode = appData.editingController.text;
      var richTextList = [],
          tokensColors = [],
          tokensIndices = [];
      int lastEnd,
          shift = 0;
      var tokensList = appData.tokensList;

      for (int tokenIndex = 0; tokenIndex < tokensList.length; tokenIndex++) {
        Token token = tokensList[tokenIndex];

          var start = token.start - shift;
          var end = token.end - shift;
          if (tokenIndex > 0) { // no between text before the first token
            var betweenText = sourceCode.substring(lastEnd + 1, start);

            if (betweenText.length > 1 && betweenText[0] == "\n") {
              betweenText = "\n";
              shift++;
              start--;
              end--;
            }
            richTextList.add([betweenText, Colors.black, 0]);

            tokensColors.add(Colors.black);
            }
          if (token.tokenType != "EOF") { // no between text after EOF
            var tokenText = sourceCode.substring(start, end + 1);
            richTextList.add([tokenText, Colors.black, 1]);
          }
          lastEnd = end;
        tokensIndices.add(tokensColors.length);
        tokensColors.add(tokensList[tokenIndex].color);
      }

      appData.tokensIndices = tokensIndices;
      appData.richTextList = richTextList;
      appData.tokensColors = tokensColors;

      appData.visualize();
    }





    // void compile(var progress) {
    //   var sourceCode = appData.editingController.text;
    //   progress.showWithText("Compiling ...");
    //   readFile().then((value) {
    //     var richTextList = [], tokensColors = [], tokensIndices = [];
    //     int counter = 0, lastEnd, shift = 0;
    //     appData.tokensList.clear();
    //     LineSplitter.split(value).forEach((line) {
    //       // print(" here is the $line");
    //       var splittedList = line.split(",");
    //
    //       if (splittedList[0] != "EOF") {
    //         var start = int.parse(splittedList[4]) - shift;
    //         var end = int.parse(splittedList[5]) - shift;
    //         if (counter > 0) {
    //           var betweenText = sourceCode.substring(lastEnd + 1, start);
    //           if (betweenText.length > 1 && betweenText[0] == "\n") {
    //             betweenText = "\n";
    //             shift++;
    //             start--;
    //             end--;
    //           }
    //           richTextList.add([betweenText, Colors.black, 0]);
    //           tokensColors.add(Colors.black);
    //         }
    //         print("RichText  : "+(richTextList.length > 0 ? richTextList.last : ""));
    //
    //         var tokenText = sourceCode.substring(start, end + 1);
    //
    //         richTextList.add([tokenText, Colors.black, 1]);
    //
    //         lastEnd = end;
    //       }
    //       counter++;
    //
    //       appData.tokensList.add(Token(
    //           splittedList[0],
    //           splittedList[1],
    //           splittedList[2],
    //           int.parse(splittedList[3]),
    //           int.parse(splittedList[4]),
    //           int.parse(splittedList[5]),
    //           int.parse(splittedList[6])));
    //
    //       // print(tokensColors.length);
    //       tokensIndices.add(tokensColors.length);
    //       tokensColors.add(appData.tokensList.last.color);
    //
    //       // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    //       //print("added to the list");
    //     });
    //
    //     // for (var x in tokensColors){
    //     //   if(x != Colors.black)print(x);
    //     // }
    //     appData.tokensIndices = tokensIndices;
    //     appData.richTextList = richTextList;
    //     appData.tokensColors = tokensColors;
    //
    //     print(tokensIndices);
    //     print(appData.tokensList.length);
    //     print(richTextList.length);
    //     print(tokensColors.length);
    //
    //     appData.visualize();
    //     progress.dismiss();
    //   });
    //
    //   // print("Here is the code << ${appData.editingController.text} >>");
    // }

    void callInterpreter(String string) {
      List consoleMessages = [];
      networkHelper
          .sendCodeToInterpreter(appData.editingController.text.toString())
          .then((resultMessages) {
            consoleMessages = resultMessages;
        networkHelper.getTokens().then((value){
          appData.tokensList = value;
          if(value != null)
            consoleMessages.add(["Requesting Lexical Analysis Completed Successfully!", 1]);
          else
            consoleMessages.add(["Failed to receive lexical analysis.", 0]);
          compile(consoleMessages);
        });
      });
    }

    void _VisualizeLogic(BuildContext context) {
      // final progress = ProgressHUD.of(context);
      if(!(appData.circleOneClicked && appData.circleTwoClicked && appData.circleThreeClicked)) {
        if (appData.editingController.text.isEmpty) {
          showAlertDialog(context);
        } else {
          callInterpreter(appData.editingController.text);
        }
      }

      if (appData.isVisualized && appData.circleOneClicked) {
        appData.changeCircleOneState();
      } else if (appData.isVisualized && appData.circleTwoClicked) {
        appData.changeCircleTwoState();
      } else if (appData.isVisualized && appData.circleThreeClicked) {
        appData.changeCircleThreeState();
      } else if (appData.isVisualized && appData.circleFourClicked) {
        appData.changeCircleFourState();
      }
    }

    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 800,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _VisualizeLogic(context);
                        },
                        child: Text(
                          getText(),
                          style: text_style_header_button,
                        ),
                        style: run_button_style,
                      ),
                      ElevatedButton(
                          onPressed: getPrevButtonFunc(),
                          style: run_button_style,
                          child: Text(
                            "Previous",
                            style: text_style_header_button,
                          )),
                      ElevatedButton(
                          onPressed: getNextButtonFunc(),
                          style: run_button_style,
                          child: Text("Next", style: text_style_header_button))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: getClickedPage(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
