import 'package:flutter/material.dart';

class Token {
  String _tokenType;
  String _lexeme;
  String _literal;
  int _line;
  int _start;
  int _end;
  Color _color;
  List<String> _errors;

  List<String> get errors => _errors;

  Color get color => _color;

  Token(this._tokenType, this._lexeme, this._literal, this._line, this._start,
      this._end, int category, this._errors) {
    this._color = getTokenColor(category);
  }

  factory Token.fromJson(int tokenIndex, Map<String, dynamic> json) {
    List<String> errors = [];
    if(json["Errors"][tokenIndex.toString()] != null){
      int length = (json["Errors"][tokenIndex.toString()] as List<dynamic>).length;
      for (int i = 0; i <length; i++){
        errors.add(json["Errors"][tokenIndex.toString()][i].toString());
      }
    }
    return Token(
        json["Tokens"][tokenIndex]['type'],
        json["Tokens"][tokenIndex]['lexeme'],
        json["Tokens"][tokenIndex]['literal'],
        json["Tokens"][tokenIndex]['line'],
        json["Tokens"][tokenIndex]['start'],
        json["Tokens"][tokenIndex]['end'],
        json["Tokens"][tokenIndex]['category'],
        errors,
    );
  }

  String get tokenType => _tokenType;

  String get lexeme => _lexeme;

  int get line => _line;

  String get literal => _literal;

  int get end => _end;

  int get start => _start;

  Color getTokenColor(var tokenType) {
    switch (tokenType) {
      case 1:
        return Colors.teal;
        break;
      case 2:
        return Colors.greenAccent;
        break;
      case 3:
        return Colors.amberAccent;
        break;
      case 4:
        return Colors.blueAccent;
        break;
      default:
        return Colors.grey;
    }
  }
}
