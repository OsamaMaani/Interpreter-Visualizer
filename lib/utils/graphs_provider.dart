import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class GraphProvider with ChangeNotifier{
  int _visualizedGraphIndex = 0;

  set visualizedGraphIndex(int value) {
    _visualizedGraphIndex = value;
    notifyListeners();
  }

  int get visualizedGraphIndex => _visualizedGraphIndex;

  void incrementVisualizedGraphIndex() {
    _visualizedGraphIndex++;
    notifyListeners();
  }

}