import 'package:flutter/widgets.dart';

import 'football_home.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => FootballHome(),
  //"/ExScreen2": (BuildContext context) => ExScreen2(),
};