import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/components/resusable_circle.dart';

class ThreeCircles extends StatelessWidget {
  final String headline1, title1, headline2, title2, headline3, title3;
  final Function function1;
  final Function function2;
  final Function function3;

  ThreeCircles(
      {this.headline1,
      this.title1,
      this.function1,
      this.headline2,
      this.title2,
      this.function2,
      this.headline3,
      this.title3,
      this.function3});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ReusableCircle(
                  headline: headline1,
                  title: title1,
                  function: function1,
                )),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: ReusableCircle(
                  headline: headline2,
                  title: title2,
                  function: function2,
                ))
              ],
            ),
          ),
          Expanded(
              child: ReusableCircle(
                  headline: headline3, title: title3, function: function3)),
        ],
      ),
    );
  }
}
