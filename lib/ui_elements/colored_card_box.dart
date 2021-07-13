import 'package:flutter/material.dart';

class ColoredCardBox extends StatelessWidget {
  final Widget child;
  final Color color;

  ColoredCardBox({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: child,
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
