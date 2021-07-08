import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/ui_elements/token_item.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';
class TokensPage extends StatefulWidget {
  final int numberOfTokens;

  TokensPage(this.numberOfTokens);

  @override
  _TokensPageState createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage> with TickerProviderStateMixin{
  AnimationController _animationController;
  double animationDuration;
  int durationOfSingleToken;
  int totalDuration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    durationOfSingleToken = 1500;
    totalDuration = widget.numberOfTokens * durationOfSingleToken;
    _animationController = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));

    animationDuration = durationOfSingleToken / totalDuration;
    _animationController.forward();
  }


@override
void dispose() {
  print("Tokens Page Disposed");
  _animationController.dispose();
  super.dispose();
}

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
                  Text(
                    "Token Type",
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
              itemCount: widget.numberOfTokens,
              itemBuilder: (context, index) {
                return TokenItem(index, animationDuration, _animationController);
              },
            ),
          )
        ],
      ),
    );
  }
}