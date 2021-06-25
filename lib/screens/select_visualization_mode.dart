import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/TokensPage.dart';
import 'package:flutterdesktopapp/ui_elements/first_page.dart';
import 'package:flutterdesktopapp/ui_elements/modes_circles.dart';
import 'package:flutterdesktopapp/utils/constants.dart';

class Modes extends StatefulWidget {
  const Modes({Key key}) : super(key: key);

  @override
  _ModesState createState() => _ModesState();
}

class _ModesState extends State<Modes> {
  bool _isClicked = false;

  void visualize(){
    setState(() {
      _isClicked = true;
    });
  }
  void _back(){
    setState(() {
      _isClicked = false;
    });
  }

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
              onPressed: () {
                   _isClicked ? _back() : visualize();

              },
              child: Text(
                     _isClicked ? "Back" :  "Visualize" ,
                style: TextStyle(color: Colors.greenAccent),
              ),
              style: run_button_style,
            ),
          ),
          SizedBox(height: 20.0,),
          Expanded(
            child: _isClicked ? TokensPage() : PageOne(),
          ),
        ],
      ),
    );
  }
}
