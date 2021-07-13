import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/ui_elements/card_box.dart';
import 'package:flutterdesktopapp/ui_elements/symbo_table_item.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/graphs_provider.dart';
import 'package:provider/provider.dart';

class SymbolTable extends StatefulWidget {
  @override
  _SymbolTableState createState() => _SymbolTableState();
}

class _SymbolTableState extends State<SymbolTable>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    print("Symbol Table Page Disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);
    final graphProvider = Provider.of<GraphProvider>(context);

    var symbolTable =
        appData.astsList[graphProvider.visualizedStatementIndex].symbolTable;
    var symbolTableSyncIndex = appData
        .astsList[graphProvider.visualizedStatementIndex]
        .symbolTableIndexSync[graphProvider.visualizedStepIndex];
    var currentSymbolTable = symbolTable[symbolTableSyncIndex];

    List scopes = [], variables = [], values = [];
    for (var scope in currentSymbolTable.keys) {
      for (var variable in currentSymbolTable[scope].keys) {
        scopes.add(scope);
        variables.add(variable);
        values.add(currentSymbolTable[scope][variable]);
      }
    }

    int len = scopes.length;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardBox(
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Variable Name",
                    style: text_style_table,
                  ),
                  Text(
                    "Value",
                    style: text_style_table,
                  ),
                  Text(
                    "Scope",
                    style: text_style_table,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: len,
              itemBuilder: (context, index) {
                return SymbolTableItem(scopes[index].toString(),
                    variables[index].toString(), values[index].toString());
              },
            ),
          )
        ],
      ),
    );
  }
}
