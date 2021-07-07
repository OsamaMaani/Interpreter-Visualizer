import 'package:flutter/cupertino.dart';
import 'package:flutterdesktopapp/models/tokens.dart';

class AppData with ChangeNotifier{

   bool _isVisualized = false;

   bool _cirlcleOneClicked = false;
   bool _circleTwoClicked = false;
   bool _circleThreeClicked = false;
   bool _circleFourClicked = false;
   bool _tokensChange = false;

   List _richTextList = [];
   List _tokensColors = [];
   List _tokensIndices = [];
   List<Token> _tokensList = [];

   List<String> _jsonList =[];
   List<String> _newNodeID =[];
   List<String> _nodeDataList = [];

   List _consoleMessages = [];


   List get consoleMessages => _consoleMessages;

   set consoleMessages(List value) {
    _consoleMessages = value;
  }

  void addConsoleMessage(String message, int type){ // 0 for errors, 1 otherwise
    consoleMessages.add([message, type]);
     var temp = List.from(consoleMessages);
    consoleMessages = temp;
  }

   void addConsoleMessageList(List messages){ // 0 for errors, 1 otherwise
     if(messages == null) return;
     for(var m in messages){
       consoleMessages.add([m[0], m[1]]);
     }

     WidgetsBinding.instance.addPostFrameCallback((_) {
       var temp = List.from(consoleMessages);
       consoleMessages = temp;
     });
   }


   List<String> get jsonList => _jsonList;

  set jsonList(List<String> value) {
    _jsonList = value;
  }

  void refreshTokensChange(){
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


   void resetVisualizerStatementIndex(){
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

  set richTextList(List value) {
    _richTextList = value;
    notifyListeners();
  }

  List get richTextList => _richTextList;
   TextEditingController _editingController = TextEditingController();

   void changeCircleOneState(){
      if(_cirlcleOneClicked){
         _cirlcleOneClicked = false;
      }else {
         _cirlcleOneClicked = true;
      }
      notifyListeners();
   }

   void changeCircleTwoState(){
      if(_circleTwoClicked){
         _circleTwoClicked = false;
      }else {
         _circleTwoClicked = true;
      }
      notifyListeners();
   }

   void changeCircleThreeState(){
      if(_circleThreeClicked){
         _circleThreeClicked = false;
      }else {
         _circleThreeClicked = true;
      }
      notifyListeners();
   }
   void changeCircleFourState(){
      if(_circleFourClicked){
         _circleFourClicked = false;
      }else {
         _circleFourClicked = true;
      }
      notifyListeners();
   }

   void visualize(){
      _isVisualized =true;
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