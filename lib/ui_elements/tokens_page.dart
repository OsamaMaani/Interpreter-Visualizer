import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/utils/constants.dart';

class TokensPage extends StatelessWidget {
  TokensPage({Key key}) : super(key: key);

  final List<Token> tokenList = [
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
    Token("operator", "+", "null", "1"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardBox(
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("TokenType",style: text_style_table,),
                  Text("Lexeme",style: text_style_table,),
                  Text("Literal",style: text_style_table,),
                  Text("Line No.",style: text_style_table,)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tokenList.length,
              itemBuilder: (_, index) {
                return CardBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardBox(
                        child: Text("${tokenList[index].tokenType}"),
                      ),
                      CardBox(
                        child: Text("${tokenList[index].lexeme}"),
                      ),
                      CardBox(
                        child: Text("${tokenList[index].literal}"),
                      ),
                      CardBox(
                        child: Text("${tokenList[index].line}"),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
