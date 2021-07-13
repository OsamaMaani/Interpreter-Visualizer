import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GraphProvider with ChangeNotifier {
  int _visualizedGraphIndex = 0;
  int _visualizedStatementIndex = 0;
  int _visualizedStepIndex = 0;

  int get visualizedStatementIndex => _visualizedStatementIndex;

  set visualizedStatementIndex(int value) {
    _visualizedStatementIndex = value;
    notifyListeners();
  }

  set visualizedGraphIndex(int value) {
    _visualizedGraphIndex = value;
    notifyListeners();
  }

  int get visualizedGraphIndex => _visualizedGraphIndex;

  int get visualizedStepIndex => _visualizedStepIndex;

  set visualizedStepIndex(int value) {
    _visualizedStepIndex = value;
    notifyListeners();
  }
}
