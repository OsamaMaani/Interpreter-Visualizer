import 'package:flutter/material.dart';

class SnackBarMessage extends StatelessWidget {
  String path;
  SnackBarMessage(this.path);

  @override
  Widget build(BuildContext context) {
    return  SnackBar(
      content: Text('Graph is saved to $path'),
    );
  }
}
