import 'package:flutter/material.dart';

class Token{
  String _tokenType;
  String _lexeme;
  String _literal;
  int _line;
  int _start;
  int _end;
  Color _color;

  Color get color => _color;

  Token(this._tokenType, this._lexeme, this._literal, this._line, this._start,
      this._end, int category){
    this._color = getTokenColor(category);
  }

  String get tokenType => _tokenType;

  String get lexeme => _lexeme;

  int get line => _line;

  String get literal => _literal;

  int get end => _end;

  int get start => _start;

  Color getTokenColor(var tokenType){
    switch(tokenType){
      case 1: return Colors.teal;break;
      case 2: return Colors.greenAccent;break;
      case 3: return Colors.amberAccent;break;
      case 4: return Colors.blueAccent;break;
      default: return Colors.grey;
    }
  }
}