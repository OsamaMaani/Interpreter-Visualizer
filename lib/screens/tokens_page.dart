import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/models/tokens.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/ui_elements/token_item.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:provider/provider.dart';
class TokensPage extends StatefulWidget {
  // const TokensPage({Key? key}) : super(key: key);

  @override
  _TokensPageState createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage> {

  // TokensPage({Key key}) : super(key: key);

  DateTime lastRender;

  get _duration {
    var now = DateTime.now();
    var defaultDelay = Duration(seconds: 1);
    Duration delay;
    if (lastRender == null) {
      lastRender = now;
      delay = defaultDelay;
    } else {

      var difference = now.difference(lastRender);
      if (difference > defaultDelay) {
        lastRender = now;
        delay = defaultDelay;
      } else {
        var durationOffcet = difference - defaultDelay;
        delay = defaultDelay + (-durationOffcet);

        lastRender = now.add(-durationOffcet);
      }
      return delay;
    }

    return defaultDelay;
  }

  @override
  Widget build(BuildContext context) {
    final List<Token> tokenList = Provider.of<AppData>(context).tokensList;

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
                return TokenItem(_duration, tokenList, index);
              },
            ),
          )
        ],
      ),
    );
  }
}



//
// class TokensPage extends StatelessWidget {
//   TokensPage({Key key}) : super(key: key);
//
//   DateTime lastRender;
//
//   get _duration {
//     var now = DateTime.now();
//     var defaultDelay = Duration(seconds: 1);
//     Duration delay;
//     if (lastRender == null) {
//       lastRender = now;
//       delay = defaultDelay;
//     } else {
//
//       var difference = now.difference(lastRender);
//       if (difference > defaultDelay) {
//         lastRender = now;
//         delay = defaultDelay;
//       } else {
//         var durationOffcet = difference - defaultDelay;
//         delay = defaultDelay + (-durationOffcet);
//
//         lastRender = now.add(-durationOffcet);
//       }
//       return delay;
//     }
//
//     return defaultDelay;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Token> tokenList = Provider.of<AppData>(context).tokensList;
//
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CardBox(
//             child: SizedBox(
//               height: 30,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "TokenType",
//                     style: text_style_table,
//                   ),
//                   Text(
//                     "Lexeme",
//                     style: text_style_table,
//                   ),
//                   Text(
//                     "Literal",
//                     style: text_style_table,
//                   ),
//                   Text(
//                     "Line No.",
//                     style: text_style_table,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: tokenList.length,
//               itemBuilder: (_, index) {
//                 return TokenItem(_duration, tokenList, index);
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }