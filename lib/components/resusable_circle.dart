import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';

class ReusableCircle extends StatelessWidget {
  final Function function;
  final String headline,title;
  ReusableCircle({this.headline, this.title, this.function});
  @override
  Widget build(BuildContext context) {
    final isVisualizedProvider = Provider.of<AppData>(context).isVisualized;
    return InkWell(
      onTap:  isVisualizedProvider ? function : null ,
      child: CircleAvatar(
        backgroundColor: (isVisualizedProvider ? Colors.indigo : Colors.blueGrey),
        radius: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$headline", style: text_style_circle),
            SizedBox(height: 20,),
            Text("$title", style: text_style_circle),
          ],
        ),
      ),
    );
  }
}
