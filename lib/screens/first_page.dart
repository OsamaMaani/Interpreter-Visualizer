import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';

import '../ui_elements/modes_circles.dart';

class PageOne extends StatelessWidget {
  const PageOne({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TwoCircles(
          headline1: "1",
          title1: "Lexical Analysis",
          function1: appData.changeCircleOneState,
          headline2: "2",
          title2: "Syntactic Analysis",
          function2: appData.changeCircleTwoState,
        ),
        SizedBox(
          height: 50,
        ),
        TwoCircles(
          headline1: "3",
          title1: "Semantic Analysis",
          function1: appData.changeCircleThreeState,
          headline2: "4",
          title2: "Full Visualization",
          function2: appData.changeCircleFourState,
        ),
      ],
    );
  }
}
