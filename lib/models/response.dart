import 'dart:convert';

import 'package:flutterdesktopapp/models/statement.dart';
import 'package:flutterdesktopapp/models/tokens.dart';

class ResponseParser{

  List<Token> listOfTokens(String responseBody){
    Map<String, dynamic> jsonList = json.decode(responseBody);
    int len = (jsonList["Tokens"] as List<dynamic>).length;
    List<Token> listOfTokens = [];
    for(int tokenIndex = 0;tokenIndex < len;tokenIndex++) {
      listOfTokens.add(Token.fromJson(tokenIndex, jsonList));
    }
    return listOfTokens;
  }


  List<Statement> listOfParsedStatements(String responseBody){
    Map<String, dynamic> jsonList = json.decode(responseBody);
    // print((jsonList["Statements"] as List<dynamic>));
    int len = (jsonList["Statements"] as List<dynamic>).length;

    List<Statement> statements = [];
    for(int statementIndex = 0;statementIndex < len;statementIndex++){
     statements.add(Statement.fromJson(jsonList["Statements"][statementIndex]));
    }

    return statements;
  }




}