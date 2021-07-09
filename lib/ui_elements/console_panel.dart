import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/constants.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:provider/provider.dart';

class ConsolePanel extends StatefulWidget {
  const ConsolePanel({Key key}) : super(key: key);

  @override
  _ConsolePanelState createState() => _ConsolePanelState();
}

class _ConsolePanelState extends State<ConsolePanel> {

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<UtilitiesProvider>(context);
    var consoleMessages = appData.consoleMessages;
    return SizedBox(
        width: 1200,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (consoleMessages.isEmpty ? null : ListView.builder(
                itemCount: consoleMessages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text("-> " + consoleMessages[consoleMessages.length - index - 1][0], style: (consoleMessages[consoleMessages.length - index - 1][1] == 0 ? text_style_console_error : text_style_console_normal)),
                  );
                }
            )
        )));
  }
}