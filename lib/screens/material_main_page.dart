import 'package:flutter/material.dart';
import 'package:flutterdesktopapp/utils/app_data.dart';
import 'package:flutterdesktopapp/utils/utilities_provider.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider<AppData>(create: (_) => AppData()),
    ChangeNotifierProvider<UtilitiesProvider>(create: (_) => UtilitiesProvider()),
    ],
    builder: (context, child){
      return MaterialApp(
        title: 'Interpreter Visualizer ',
        //theme: ,
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
    });
  }
}
