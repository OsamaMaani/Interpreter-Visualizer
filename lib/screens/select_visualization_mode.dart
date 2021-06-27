import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/full_visualization.dart';
import 'package:flutterdesktopapp/ui_elements/semantic_page.dart';
import 'package:flutterdesktopapp/ui_elements/syntactic_page.dart';
import 'package:flutterdesktopapp/ui_elements/tokens_page.dart';
import 'package:flutterdesktopapp/ui_elements/first_page.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';

class Modes extends StatefulWidget {
  const Modes({Key key}) : super(key: key);

  @override
  _ModesState createState() => _ModesState();
}

class _ModesState extends State<Modes> {
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
                  appData.visualize();
                }else if(appData.isVisualized && appData.circleOneClicked){
                  appData.changeCircleOneState();
                }else if(appData.isVisualized && appData.circleTwoClicked){
                  appData.changeCircleTwoState();
                }else if(appData.isVisualized && appData.circleThreeClicked){
                  appData.changeCircleThreeState();
                }else if(appData.isVisualized && appData.circleFourClicked){
                  appData.changeCircleFourState();
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
