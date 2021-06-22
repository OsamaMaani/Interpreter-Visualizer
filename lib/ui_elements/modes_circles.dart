import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/components/resusable_circle.dart';

class TwoCircles extends StatelessWidget {
  final String headline1,title1, headline2, title2 ;
  TwoCircles({this.headline1,this.title1,this.headline2, this.title2});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: ReusableCircle(headline: headline1,title: title1,)),
          SizedBox(width: 30,),
          Expanded(child: ReusableCircle(headline: headline2,title: title2,))
        ],
      ),
    );
  }
}
