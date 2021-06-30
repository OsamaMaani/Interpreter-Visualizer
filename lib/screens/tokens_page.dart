import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';

class TokensPage extends StatefulWidget {
  TokensPage({Key key}) : super(key: key);

  @override
  _TokensPageState createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage> {




  @override
  Widget build(BuildContext context) {
    final List<Token> tokenList = Provider.of<AppData>(context).list;
    List<Token> tokenToView;

    // setState(() {
    //   Timer(Duration(seconds: 2),(){
    //     tokenToView.add(tokenList[i]);
    //   });
    // });


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
                  Text(
                    "TokenType",
                    style: text_style_table,
                  ),
                  Text(
                    "Lexeme",
                    style: text_style_table,
                  ),
                  Text(
                    "Literal",
                    style: text_style_table,
                  ),
                  Text(
                    "Line No.",
                    style: text_style_table,
                  )
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
                      SizedBox(
                        child: Container(
                            child: Text("${tokenList[index].tokenType}")),
                        width: 80.0,
                      ),
                      SizedBox(
                        child: Container(
                            child: Text("${tokenList[index].lexeme}")),
                        width: 80.0,
                      ),
                      SizedBox(
                        child: Container(
                            child: Text("${tokenList[index].literal}")),
                        width: 80.0,
                      ),
                      SizedBox(
                        child:
                            Container(child: Text("${tokenList[index].line}")),
                        width: 80.0,
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
