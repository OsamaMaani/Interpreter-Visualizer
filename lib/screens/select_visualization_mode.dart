import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/screens/full_visualization.dart';
import 'package:flutterdesktopapp/screens/semantic_page.dart';
import 'package:flutterdesktopapp/screens/syntactic_page.dart';
import 'package:flutterdesktopapp/screens/tokens_page.dart';
import 'package:flutterdesktopapp/screens/first_page.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/file_processes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class Modes extends StatefulWidget {
  Modes({Key key}) : super(key: key);

  @override
  _ModesState createState() => _ModesState();
}

class _ModesState extends State<Modes> {
  FileStorage fileStorage;

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


    Future<String> readFile() async {
      final String data = await rootBundle.loadString('assets/tokens_file.txt');
      return data;
    }

    void compile(var progress){
      progress.showWithText("Compiling ...");
      readFile().then((value) {
        LineSplitter.split(value).forEach((line){
          int start1 =0 ;
          int end1 =0;
          int start2=0;
          int end2= 0;
          int i;

          for(i =0; i< line.length ;i++){
            //print("11111111");
            //print(line[i]);
            if(line[i] == " "){
              end1 = i;
              start2= ++i;
              break;
            }
          }

          //print("**********************");
          for(i; i<line.length ;i++){
            //print("2222222222");
            //print(line[i]);
            if(line[i] == " "){
              end2 = i;
              break;
            }
          }
          appData.list.add(Token(line.substring(start1,end1), line.substring(start2,end2),"sfd","fsd"));
          // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
          //print("added to the list");
        });
        appData.visualize();
        progress.dismiss();
      });

      print("Here is the code << ${appData.editingController.text} >>");
    }

    return ProgressHUD(
      child: Builder(
        builder: (context){
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
                      final progress = ProgressHUD.of(context);
                      if(!appData.isVisualized) {
                        if(appData.editingController.text.isEmpty){
                          showAlertDialog(context);
                        }else{
                          compile(progress);
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
                      }else{
                        compile(progress);
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
        },
      ),
    );
  }
}
