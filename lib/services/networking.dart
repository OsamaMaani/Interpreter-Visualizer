import 'dart:convert';

import 'dart:async';
import 'package:flutterdesktopapp/models/response.dart';
import 'package:flutterdesktopapp/models/statement.dart';
import 'package:flutterdesktopapp/models/tokens.dart';

import 'package:http/http.dart' as http;

import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';


class NetworkHelper {
  factory NetworkHelper() {
    return internalObject;
  }


  static const String ip_address = "http://192.168.8.102";
  static const String port = "9090";
  static const String url_sendCode = "/interpreter/sourcecode/";
  static const String url_getLexical="/interpreter/lexical?token=";
  static const String url_getSyntactic="/interpreter/syntactic?token=";
  static const String url_getSemantic="/interpreter/semantic?token=";



  static final NetworkHelper internalObject = NetworkHelper._internal();

  static var token;

  NetworkHelper._internal();
  ResponseParser responseParser = ResponseParser();

  Future<List> sendCodeToInterpreter(String code) async{
    List consoleMessages = [];

    final response = await http.post(
      Uri.parse('$ip_address:$port$url_sendCode'),

      headers: <String, String>{
        'Content-Type': 'application/json',
         'Access-Control-Allow-Origin':'*'
      },
      body: code,
    );

    if (response.statusCode == 200) {
      consoleMessages.add(["Connection Established!", 1]);
      consoleMessages.add(["Authentication Token Received Successfully!", 1]);
      token = json.decode(response.body)["Token"];
    }else {
      consoleMessages.add(["Failed to send the code.", 0]);
    }

    return consoleMessages;
  }

  Future<List<Token>> getLexicalAnalysis() async{
    final response = await http.get(Uri.parse('$ip_address:$port$url_getLexical$token'));
    if(response.statusCode == 200){
      print("Requesting Lexical Analysis Completed Successfully!");
      // print(responseParser.listOfTokens(response.body));
      return  responseParser.listOfTokens(response.body);
    }else{
    }
  }

  Future<List<Statement>> getSyntacticAnalysis() async{
    final response = await http.get(Uri.parse('$ip_address:$port$url_getSyntactic$token'));
    if(response.statusCode == 200){

      return  responseParser.listOfParsedStatements(response.body);
    }else{
    }
  }


}