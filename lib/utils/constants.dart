import 'package:flutter/material.dart';




const String url_sendCode = "http://192.168.36.32:9090/interpreter/sourcecode/";
const String url_getTokens="http://192.168.36.32:9090/interpreter/lexical?token=";
const String url_getLexer="";
const String url_getParser="";


final ButtonStyle run_button_style =
ElevatedButton.styleFrom();


var text_style_header_button = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20
);



var text_style_table = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20.0
);

var text_style_error = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.red,
  fontSize: 20.0
);

var text_style_highlight = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    backgroundColor: Colors.yellow,
);

var text_style_circle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: Colors.white
);

var text_style_table_row = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
    color: Colors.black,
);


