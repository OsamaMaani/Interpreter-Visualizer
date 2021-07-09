import 'package:flutter/cupertino.dart';
import 'package:flutterdesktopapp/models/statement.dart';
import 'package:flutterdesktopapp/models/tokens.dart';

class AppData with ChangeNotifier {
  bool _isVisualized = false;
  bool _isVisualizationReady = false;

  bool get isVisualizationReady => _isVisualizationReady;

  set isVisualizationReady(bool value) {
    _isVisualizationReady = value;
    notifyListeners();
  }

  bool atLeastOneCircle() {
    return (circleOneClicked || circleTwoClicked || circleThreeClicked);
  }

  bool _cirlcleOneClicked = false;
  bool _circleTwoClicked = false;
  bool _circleThreeClicked = false;
  bool _circleFourClicked = false;
  bool _tokensChange = false;

  List _tokensColors = [];
  List _tokensIndices = [];
  List<Token> _tokensList = [];

  List<Statement> _parsedStatementsList = [];

  List<Statement> get parsedStatementsList => _parsedStatementsList;

  set parsedStatementsList(List<Statement> value) {
    _parsedStatementsList = value;
  }

  List<String> _jsonList = [];
  List<String> _newNodeID = [];
  List<String> _nodeDataList = [];

  List<String> get jsonList => _jsonList;

  set jsonList(List<String> value) {
    _jsonList = value;
  }

  void refreshTokensChange() {
    _tokensChange = !_tokensChange;
    notifyListeners();
  }

  bool get tokensChange => _tokensChange;

  set tokensList(List<Token> value) {
    _tokensList = value;
  }

  List<Token> get tokensList => _tokensList;

  int _visualizedStatementIndex = 0;

  int get visualizedStatementIndex => _visualizedStatementIndex;

  void resetVisualizerStatementIndex() {
    _visualizedStatementIndex = 0;
  }

  set visualizedStatementIndex(int value) {
    _visualizedStatementIndex = value;
    notifyListeners();
  }

  List get tokensIndices => _tokensIndices;

  set tokensIndices(List value) {
    _tokensIndices = value;
  }

  List get tokensColors => _tokensColors;

  set tokensColors(List value) {
    _tokensColors = value;
    notifyListeners();
  }


  TextEditingController _editingController = TextEditingController();

  void changeCircleOneState() {
    if (_cirlcleOneClicked) {
      _cirlcleOneClicked = false;
    } else {
      _cirlcleOneClicked = true;
    }
    notifyListeners();
  }

  void changeCircleTwoState() {
    if (_circleTwoClicked) {
      _circleTwoClicked = false;
    } else {
      _circleTwoClicked = true;
    }
    notifyListeners();
  }

  void changeCircleThreeState() {
    if (_circleThreeClicked) {
      _circleThreeClicked = false;
    } else {
      _circleThreeClicked = true;
    }
    notifyListeners();
  }

  void changeCircleFourState() {
    if (_circleFourClicked) {
      _circleFourClicked = false;
    } else {
      _circleFourClicked = true;
    }
    notifyListeners();
  }

  void visualize() {
    _isVisualized = true;
    notifyListeners();
  }

  bool get circleOneClicked => _cirlcleOneClicked;

  bool get circleTwoClicked => _circleTwoClicked;

  bool get circleThreeClicked => _circleThreeClicked;

  bool get circleFourClicked => _circleFourClicked;

  bool get isVisualized => _isVisualized;

  TextEditingController get editingController => _editingController;

  List<String> get newNodeID => _newNodeID;

  set newNodeID(List<String> value) {
    _newNodeID = value;
  }

  List<String> get nodeDataList => _nodeDataList;

  set nodeDataList(List<String> value) {
    _nodeDataList = value;
  }
}
