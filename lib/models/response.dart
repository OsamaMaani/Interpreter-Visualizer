import 'dart:convert';

import 'package:flutterdesktopapp/models/tokens.dart';

class ResponseParser{


  Token _parseTokens(int tokenIndex, Map<String, dynamic> json){
     return Token.fromJson(tokenIndex, json);
  }

  List<Token> listOfTokens(String responseBody){
    Map<String, dynamic> jsonList = json.decode(responseBody);
    int len = (jsonList["Tokens"] as List<dynamic>).length;
    List<Token> listOfTokens = [];
    for(int tokenIndex = 0;tokenIndex < len;tokenIndex++) {
      listOfTokens.add(_parseTokens(tokenIndex, jsonList));
    }
    return listOfTokens;
  }



}