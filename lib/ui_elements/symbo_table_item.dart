import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/constants.dart';

import 'colored_card_box.dart';

class SymbolTableItem extends StatefulWidget {
  final String scope;
  final String variable;
  final String value;

  SymbolTableItem(this.scope, this.variable, this.value);

  @override
  _SymbolTableItemState createState() => _SymbolTableItemState();
}

class _SymbolTableItemState extends State<SymbolTableItem> {
  // @override
  void dispose() {
    print("Symbol Table Item Disposed");
    //   // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredCardBox(
      color: Colors.lightGreenAccent[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            child: Container(
                child: Text("${widget.variable}", style: text_style_table_row)),
            width: 125.0,
          ),
          SizedBox(
            child: Container(
                child: Text("${widget.value}", style: text_style_table_row)),
            width: 80.0,
          ),
          SizedBox(
            child: Container(
                child: Text("${widget.scope}", style: text_style_table_row)),
            width: 80.0,
          ),
        ],
      ),
    );
  }
}
