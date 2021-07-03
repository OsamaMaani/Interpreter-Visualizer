import 'package:flutter/cupertino.dart';
import 'package:flutterdesktopapp/models/tokens.dart';

class AppData with ChangeNotifier{

   bool _isVisualized = false;

   bool _cirlcleOneClicked = false;
   bool _circleTwoClicked = false;
   bool _circleThreeClicked = false;
   bool _circleFourClicked = false;

   List<Token> _list = [];
   List _richTextList = [];

   set richTextList(List value) {
    _richTextList = value;
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
      list.add(token);
      notifyListeners();
   }


   bool get circleOneClicked => _cirlcleOneClicked;

   bool get circleTwoClicked => _circleTwoClicked;

   bool get circleThreeClicked => _circleThreeClicked;

   bool get circleFourClicked => _circleFourClicked;

   bool get isVisualized => _isVisualized;
   //For testing purposes
   List<Token> get list => _list;

   TextEditingController get editingController => _editingController;
}