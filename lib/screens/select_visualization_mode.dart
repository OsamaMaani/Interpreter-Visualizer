import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/screens/full_visualization.dart';
import 'package:flutterdesktopapp/screens/semantic_page.dart';
import 'package:flutterdesktopapp/screens/syntactic_page.dart';
import 'package:flutterdesktopapp/screens/tokens_page.dart';
import 'package:flutterdesktopapp/screens/first_page.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';

class Modes extends StatelessWidget {
  const Modes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    Widget getClickedPage() {
      if (appData.isVisualized && appData.circleOneClicked)
        return TokensPage();
      else if (appData.isVisualized && appData.circleTwoClicked)
        return SyntacticPage();
      else if(appData.isVisualized && appData.circleThreeClicked)
        return SemanticPage();
      else if(appData.isVisualized && appData.circleFourClicked)
        return FullVisualization();

      return PageOne();
    }

    String getText(){
      if(appData.isVisualized && (appData.circleOneClicked
          || appData.circleTwoClicked
          || appData.circleThreeClicked
          || appData.circleFourClicked)) return "Back";
      else return "Visualize";
    }

    void showAlertDialog(BuildContext context){

      Widget okButton = ElevatedButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Notice"),
        content: Text("Please, write down some code before attempting to visualize!"),
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

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: 190,
            child: ElevatedButton(
              onPressed: () {
                if(!appData.isVisualized) {
                  if(appData.editingController.text.isEmpty){
                    showAlertDialog(context);
                  }else{
                    appData.visualize();
                    print("Here is the code << ${appData.editingController.text} >>");
                  }
                }else if(appData.isVisualized && appData.circleOneClicked){
                  appData.changeCircleOneState();
                }else if(appData.isVisualized && appData.circleTwoClicked){
                  appData.changeCircleTwoState();
                }else if(appData.isVisualized && appData.circleThreeClicked){
                  appData.changeCircleThreeState();
                }else if(appData.isVisualized && appData.circleFourClicked){
                  appData.changeCircleFourState();
                }else if(appData.isVisualized && appData.editingController.text.isEmpty){
                  showAlertDialog(context);
                }
              },
              child: Text(
                getText(),
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              style: run_button_style,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: getClickedPage(),
          ),
        ],
      ),
    );
  }
}
