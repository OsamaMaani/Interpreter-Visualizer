import 'package:flutter/material.dart';

class ReusableCircle extends StatelessWidget {

  final String headline,title;
  ReusableCircle({this.headline, this.title});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 150.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$headline"),
          SizedBox(height: 20,),
          Text("$title"),
        ],
      ),
    );
  }
}
