import 'package:FlutterFootball/routes.dart';
import 'package:FlutterFootball/theme/style.dart';
import 'package:flutter/material.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FootballApp());
}

class FootballApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Football",
      theme: buildThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
    );
  }
}
