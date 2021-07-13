import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UtilitiesProvider with ChangeNotifier {
  List _consoleMessages = [];

  List get consoleMessages => _consoleMessages;

  set consoleMessages(List value) {
    _consoleMessages = value;
    notifyListeners();
  }

  void clearConsoleMessages() {
    consoleMessages = [];
  }

  void addConsoleMessage(String message, int type) {
    // 0 for errors, 1 otherwise
    _consoleMessages.add([message, type]);
    var temp = List.from(consoleMessages);
    consoleMessages = temp;
  }

  void addConsoleMessageList(List messages) {
    // 0 for errors, 1 otherwise
    if (messages == null) return;
    for (var m in messages) {
      _consoleMessages.add([m[0], m[1]]);
    }

    var temp = List.from(consoleMessages);
    consoleMessages = temp;
  }

  List _richTextList = [];

  List get richTextList => _richTextList;

  set richTextList(List value) {
    _richTextList = value;
    notifyListeners();
  }

  void resetRichTextListColors() {
    var len = _richTextList.length;
    for (int i = 0; i < len; i++) _richTextList[i][1] = Colors.black;
  }
}
