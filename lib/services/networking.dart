import 'dart:convert';

import 'dart:async';
import 'package:flutterdesktopapp/models/response.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NetworkHelper {
  factory NetworkHelper() {
    return internalObject;
  }

  static final NetworkHelper internalObject = NetworkHelper._internal();

  static var token;

  NetworkHelper._internal();
  ResponseParser responseParser = ResponseParser();

  Future<List> sendCodeToInterpreter(String code) async{
    List consoleMessages = [];
    final response = await http.post(
      Uri.parse('$url_sendCode'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: code,
    );

    if (response.statusCode == 200) {
      consoleMessages.add(["Connection Established!", 1]);
      consoleMessages.add(["Authentication Token Received Successfully!", 1]);
      token = json.decode(response.body)["Token"];
    }else {
      consoleMessages.add(["Failed to send the code.", 0]);
      throw Exception('Failed to send the code.');
    }
    return consoleMessages;
  }

  Future<List<Token>> getTokens() async{
    final response = await http.get(Uri.parse('$url_getTokens$token'));
    if(response.statusCode == 200){

      print("Requesting Lexical Analysis Completed Successfully!");
      // print(responseParser.listOfTokens(response.body));
      return  responseParser.listOfTokens(response.body);
    }else{
      throw Exception('Failed to receive lexical analysis.');
    }
  }

  // Future<List<String>> getTokenErrors()async{
  //
  // }

  //Future<String> get



}








