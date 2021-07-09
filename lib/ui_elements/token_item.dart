import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:provider/provider.dart';
import 'colored_card_box.dart';

class TokenItem extends StatefulWidget {
  final int index;
  final double duration;
  final AnimationController animationController;
  TokenItem(this.index, this.duration, this.animationController);

  @override
  _TokenItemState createState() => _TokenItemState();
}

class _TokenItemState extends State<TokenItem>{
  Animation animation;
  Animation animationColor;
  double start;
  double end;
  bool showErrors = true;


  @override
  void initState() {
    print(widget.index.toString() + " signing in");
    super.initState();
    start = (widget.duration * widget.index ).toDouble();
    end = start + widget.duration;
    // end = (end > 1.0 ? 1.0 : end);
    print("START $start , end $end");

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );


    var appData = Provider.of<AppData>(context, listen: false);
    var tokenIndex = appData.tokensIndices[widget.index];
    var tokenGoalColor = appData.tokensColors[tokenIndex];


    animationColor = ColorTween(
      begin: Colors.black,
      end: tokenGoalColor,
    ).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          start,
          end,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );

    widget.animationController.addListener((){
      if(this.mounted)
        setState(() {
      });
    });
  }

  // @override
  void dispose() {
    print("Token Disposed");
  //   // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.index.toString() + " " + animation.value.toString());

    var appData = Provider.of<AppData>(context);
    final utilsProvider = Provider.of<UtilitiesProvider>(context);

    var tokensList = appData.tokensList;
    var tokenIndex = appData.tokensIndices[widget.index];
    var token = tokensList[widget.index];
    var tokenGoalColor = appData.tokensColors[tokenIndex];




    if(tokenIndex < utilsProvider.richTextList.length) {
      utilsProvider.richTextList[tokenIndex][1] = animationColor.value;
    }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (showErrors && animation.value >= start) {
          for(var error in token.errors) {
            utilsProvider.addConsoleMessage(error, 0);
          }
          showErrors = false;
        }

        var temp = List.from(utilsProvider.richTextList);
        utilsProvider.richTextList = temp;
      });

      return Opacity(
        opacity: animation.value,
        child: ColoredCardBox(
          color: animationColor.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Container(
                    child: Text("${tokensList[widget.index].tokenType}", style: text_style_table_row)),
                width: 125.0,
              ),
              SizedBox(
                child: Container(
                    child: Text("${tokensList[widget.index].lexeme}", style: text_style_table_row)),
                width: 80.0,
              ),
              SizedBox(
                child: Container(
                    child: Text("${tokensList[widget.index].literal}", style: text_style_table_row)),
                width: 80.0,
              ),
              SizedBox(
                child: Container(
                    child: Text("${tokensList[widget.index].line}", style: text_style_table_row)),
                width: 80.0,
              ),
            ],
          ),
        ),
      );
    }
  }
