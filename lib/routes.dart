import 'package:FlutterFootball/screens/settings_screen.dart';
import 'package:flutter/widgets.dart';

import 'football_home.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => FootballHome(),
  "/Settings": (BuildContext context) => SettingsScreen(),
  //"/ExScreen2": (BuildContext context) => ExScreen2(),
};