import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/screens/semantic_page.dart';
import 'package:flutterdesktopapp/screens/syntactic_and_statement_page.dart';
import 'package:flutterdesktopapp/screens/tokens_page.dart';
import 'package:flutterdesktopapp/screens/first_page.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/file_processes.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutterdesktopapp/services/networking.dart';

class Modes extends StatefulWidget {
  Modes({Key key}) : super(key: key);

  @override
  _ModesState createState() => _ModesState();
}

class _ModesState extends State<Modes> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    Widget getClickedPage() {
      if (appData.isVisualized && appData.circleOneClicked) {
        return TokensPage(appData.tokensList.length);
      } else if (appData.isVisualized && appData.circleTwoClicked) {
        return SyntacticPage(appData.parsedStatementsList[appData.visualizedStatementIndex].graphs.length,
            appData.visualizedStatementIndex);
      } else if (appData.isVisualized && appData.circleThreeClicked) {
        return SemanticPage(appData.parsedStatementsList[appData.visualizedStatementIndex].graphs.length,
            appData.visualizedStatementIndex);
      }

      return PageOne();
    }

    return Builder(
      builder: (context) {
        return Container(
          child: getClickedPage(),
        );
      },
    );
  }
}
