import 'package:flutter/cupertino.dart';
import 'package:flutterdesktopapp/models/tokens.dart';

class AppData with ChangeNotifier{

   bool _isVisualized = false;

   bool _cirlcleOneClicked = false;
   bool _circleTwoClicked = false;
   bool _circleThreeClicked = false;
   bool _circleFourClicked = false;
   bool _tokensChange = false;


  void refreshTokensChange(){
     _tokensChange = !_tokensChange;
     notifyListeners();
  }

  bool get tokensChange => _tokensChange;
  List<Token> _tokensList = [];

   List<Token> get tokensList => _tokensList;

  List _richTextList = [];
  List _tokensColors = [];
  List _tokensIndices = [];

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


   //For testing purposes.
   void addToken(Token token){
     _tokensList.add(token);
      notifyListeners();
   }


   bool get circleOneClicked => _cirlcleOneClicked;

   bool get circleTwoClicked => _circleTwoClicked;

   bool get circleThreeClicked => _circleThreeClicked;

   bool get circleFourClicked => _circleFourClicked;

   bool get isVisualized => _isVisualized;


   TextEditingController get editingController => _editingController;
}