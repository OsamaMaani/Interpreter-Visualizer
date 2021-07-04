import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/ui_elements/text_highlighter.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
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
  Animation<Color> animation1;
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
    animation1 = ColorTween(begin: Colors.black, end: appdata.tokensColors[tokenIndex])
        .animate(animationController);
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

    if(tokenIndex < appdata.richTextList.length) {
      appdata.richTextList[tokenIndex][1] = animation1.value;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var temp = List.from(appdata.richTextList);
      appdata.richTextList = temp;
    });

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
