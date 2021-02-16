import 'package:flutter/material.dart';

import 'package:FlutterFootball/models/match.dart';

class MatchOverview extends StatelessWidget {
  final Match match;

  const MatchOverview(this.match);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Overview")));
  }
}
