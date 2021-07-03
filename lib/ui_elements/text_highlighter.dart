import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';

class TextHighlighter extends StatefulWidget {
  @override
  _TextHighlighterState createState() => _TextHighlighterState();
}

class _TextHighlighterState extends State<TextHighlighter>  {
  bool isHighlighted = false;

  void changeState() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    var list = appData.richTextList;
    // print(" Edit" +appData.editingController.r.toString());
    return Container(

    //  color: Colors.deepOrange,
      child: RichText(
          text: TextSpan(
              children: list
                  .map((e) {
                    // print(e);
                    return TextSpan(
                  text: e[0],
                  style: TextStyle( color: e[1],fontSize: 20, fontWeight: FontWeight.bold)
              );})
                  .toList())),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'card_box.dart';

class TokenItem extends StatefulWidget {
  const TokenItem(this.duration, this.tokenList, this.index);

  final Duration duration;
  final List<Token> tokenList;
  final int index;

  @override
  _TokenItemState createState() => _TokenItemState();
}

class _TokenItemState extends State<TokenItem>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  bool visible = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addStatusListener((status) {
      setState(() {});
    });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animation.value,
      child: CardBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Container(
                  child: Text("${widget.tokenList[widget.index].tokenType}")),
              width: 80.0,
            ),
            SizedBox(
              child: Container(
                  child: Text("${widget.tokenList[widget.index].lexeme}")),
              width: 80.0,
            ),
            SizedBox(
              child: Container(
                  child: Text("${widget.tokenList[widget.index].literal}")),
              width: 80.0,
            ),
            SizedBox(
              child: Container(
                  child: Text("${widget.tokenList[widget.index].line}")),
              width: 80.0,
            ),
          ],
        ),
      ),
    );
  }
}




 */