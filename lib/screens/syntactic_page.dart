import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/screens/statement_page.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:provider/provider.dart';


class SyntacticPage extends StatefulWidget {

  @override
  _SyntacticPageState createState() => _SyntacticPageState();

}

class _SyntacticPageState extends State<SyntacticPage> {

  @override
  Widget build(BuildContext context) {
    var appData = Provider.of<AppData>(context);
    return Container(
      child: StatementPage(appData.visualizedStatementIndex),
    );
  }
}
