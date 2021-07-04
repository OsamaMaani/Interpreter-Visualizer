import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/ui_elements/text_highlighter.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';
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
  Animation<Color> animationColor;
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

    var appdata = Provider.of<AppData>(context, listen: false);

    var tokenIndex = appdata.tokensIndices[widget.index];
    var tokenGoalColor = appdata.tokensColors[tokenIndex];
    animationColor = ColorTween(begin: Colors.black, end: tokenGoalColor).animate(animationController);

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
    var appdata = Provider.of<AppData>(context);
    var tokenIndex = appdata.tokensIndices[widget.index];
    var tokenGoalColor = appdata.tokensColors[tokenIndex];

    if(tokenIndex < appdata.richTextList.length) {
      appdata.richTextList[tokenIndex][1] = (animationColor.value == tokenGoalColor ? animationColor.value : Colors.black);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var temp = List.from(appdata.richTextList);
      appdata.richTextList = temp;
    });

    return Visibility(
      visible: (animation.value == 1.0 ? true : false),
      child: CardBox(
        child: Container(
          color: animationColor.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Container(
                    child: Text("${widget.tokenList[widget.index].tokenType}", style: text_style_table_row)),
                width: 125.0,
              ),
              SizedBox(
                child: Container(
                    child: Text("${widget.tokenList[widget.index].lexeme}", style: text_style_table_row)),
                width: 80.0,
              ),
              SizedBox(
                child: Container(
                    child: Text("${widget.tokenList[widget.index].literal}", style: text_style_table_row)),
                width: 80.0,
              ),
              SizedBox(
                child: Container(
                    child: Text("${widget.tokenList[widget.index].line}", style: text_style_table_row)),
                width: 80.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
