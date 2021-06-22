import 'package:flutter/material.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interpreter Visualizer ',
      //theme: ,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
