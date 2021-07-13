import 'package:flutter/material.dart';

class CardBox extends StatelessWidget {
  final Widget child;

  CardBox({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
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
