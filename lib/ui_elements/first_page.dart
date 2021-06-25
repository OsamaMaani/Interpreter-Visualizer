import 'package:flutter/material.dart';

import 'modes_circles.dart';

class PageOne extends StatelessWidget {
  const PageOne({Key key}) : super(key: key);

  void _function1(){

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TwoCircles(
          headline1: "1",
          title1: "Lexical Analysis",
          function1: ()=> _function1(),
          headline2: "2",
          title2: "Syntactic Analysis",
        ),
        SizedBox(
          height: 50,
        ),
        TwoCircles(
          headline1: "3",
          title1: "Semantic Analysis",
          headline2: "4",
          title2: "Full Visualization",
        ),
      ],
    );
  }
}
