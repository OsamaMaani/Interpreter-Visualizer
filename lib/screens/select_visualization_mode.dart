import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/modes_circles.dart';
import 'package:flutterdesktopapp/utils/constants.dart';

class Modes extends StatelessWidget {
  const Modes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "Visualize",
                style: TextStyle(color: Colors.greenAccent),
              ),
              style: run_button_style,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TwoCircles(
                  headline1: "1",
                  title1: "Lexical Analysis",
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
            ),
          ),
        ],
      ),
    );
  }
}
