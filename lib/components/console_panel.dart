import 'package:flutter/material.dart';

class ConsolePanel extends StatelessWidget {
  const ConsolePanel({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Card(
        child: Container(
        ),
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.blue,
            width: 3,
          ),
        ),
      ),
    );
  }
}
