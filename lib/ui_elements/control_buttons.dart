import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/services/networking.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:provider/provider.dart';

class ControlButtons extends StatefulWidget {
  @override
  _ControlButtonsState createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  NetworkHelper networkHelper = NetworkHelper();

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final utilsProvider =
        Provider.of<UtilitiesProvider>(context, listen: false);

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
      var twoORthree = appData.circleTwoClicked | appData.circleThreeClicked;
      if (twoORthree && appData.visualizedStatementIndex > 0) {
        return () {
          appData.visualizedStatementIndex--;
        };
      }
      return null;
    }

    Function getNextButtonFunc() {
      var twoORthree = appData.circleTwoClicked | appData.circleThreeClicked;
      if (twoORthree &&
          appData.visualizedStatementIndex + 1 <
              appData.parsedStatementsList.length) {
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

    void compile(List consoleMessages) {
      utilsProvider.addConsoleMessageList(consoleMessages);

      var sourceCode = appData.editingController.text;
      var richTextList = [], tokensColors = [], tokensIndices = [];
      int lastEnd, shift = 0;
      var tokensList = appData.tokensList;

      for (int tokenIndex = 0; tokenIndex < tokensList.length; tokenIndex++) {
        Token token = tokensList[tokenIndex];

        var start = token.start - shift;
        var end = token.end - shift;
        if (tokenIndex > 0) {
          // no between text before the first token
          var betweenText = sourceCode.substring(lastEnd + 1, start);

          if (betweenText.length > 1 && betweenText[0] == "\n") {
            // betweenText = "\n";
            // shift += 2 * betweenText.length;
            // start -= betweenText.length;
            // end -= betweenText.length;
          }
          richTextList.add([betweenText, Colors.black, 0]);

          tokensColors.add(Colors.black);
        }
        if (token.tokenType != "EOF") {
          // no between text after EOF
          var tokenText = sourceCode.substring(start, end + 1);
          print(tokenText);
          richTextList.add([tokenText, Colors.black, 1]);
        }
        lastEnd = end;
        tokensIndices.add(tokensColors.length);
        tokensColors.add(tokensList[tokenIndex].color);
      }

      appData.tokensIndices = tokensIndices;
      utilsProvider.richTextList = richTextList;
      appData.tokensColors = tokensColors;

      appData.visualize();
    }

    void callInterpreter(String string, var context) {
      // final progress = ProgressHUD.of(context);
      // progress.show();
      List consoleMessages = [];
      networkHelper
          .sendCodeToInterpreter(appData.editingController.text.toString())
          .then((resultMessages) {
        consoleMessages = resultMessages;

        networkHelper.getLexicalAnalysis().then((value) {
          appData.tokensList = value;
          if (value != null) {
            consoleMessages.add(
                ["Requesting Lexical Analysis Completed Successfully!", 1]);
          } else
            consoleMessages.add(["Failed to receive lexical analysis.", 0]);

          networkHelper.getSyntacticAnalysis().then((value) {
            appData.parsedStatementsList = value;
            if (value != null) {
              consoleMessages.add(
                  ["Requesting Syntactic Analysis Completed Successfully!", 1]);
            } else
              consoleMessages.add(["Failed to receive syntactic analysis.", 0]);

            networkHelper.getSemanticAnalysis().then((value) {
              appData.astsList = value;
              if (value != null) {
                consoleMessages.add([
                  "Requesting Semantic Analysis Completed Successfully!",
                  1
                ]);
              } else
                consoleMessages
                    .add(["Failed to receive semantic analysis.", 0]);

              compile(consoleMessages);
            });
          });
        });
      });
    }

    void _VisualizeButtonLogic(BuildContext context) {
      appData.isVisualizationReady = false;
      utilsProvider.clearConsoleMessages();
      if (appData.editingController.text.isEmpty) {
        showAlertDialog(context);
      } else {
        callInterpreter(appData.editingController.text, context);
      }
    }

    void _BackButtonLogic() {
      if (appData.circleOneClicked) {
        appData.changeCircleOneState();
      } else if (appData.circleTwoClicked) {
        appData.changeCircleTwoState();
      } else if (appData.circleThreeClicked) {
        appData.changeCircleThreeState();
      }
      utilsProvider.resetRichTextListColors();
      appData.visualizedStatementIndex = 0;
    }

    Function getVisualizeButtonFunc(var context) {
      var atLeastOneCircle = appData.atLeastOneCircle();

      if (atLeastOneCircle) {
        return () {
          _BackButtonLogic();
        };
      }
      if (appData.isVisualizationReady || atLeastOneCircle)
        return () {
          _VisualizeButtonLogic(context);
        };
      return null;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton(
                onPressed: getVisualizeButtonFunc(context),
                child: Text(
                  getText(),
                  style: text_style_header_button,
                ),
                style: run_button_style,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton(
                  onPressed: getPrevButtonFunc(),
                  style: run_button_style,
                  child: Text(
                    "Previous Statement",
                    style: text_style_header_button,
                  )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton(
                  onPressed: getNextButtonFunc(),
                  style: run_button_style,
                  child:
                      Text("Next Statement", style: text_style_header_button)),
            ),
          )
        ],
      ),
    );
  }
}
