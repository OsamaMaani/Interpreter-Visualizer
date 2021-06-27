import 'package:flutter/cupertino.dart';

class AppData with ChangeNotifier{

   bool _isVisualized = false;

   bool _cirlcleOneClicked = false;
   bool _circleTwoClicked = false;
   bool _circleThreeClicked = false;
   bool _circleFourClicked = false;


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

   bool get isVisualized => _isVisualized;

   bool get circleFourClicked => _circleFourClicked;

   bool get circleThreeClicked => _circleThreeClicked;

   bool get circleTwoClicked => _circleTwoClicked;
}