import 'package:flutter/material.dart';
import '../models/match.dart';

class MatchLiveTicker extends StatelessWidget {
  final Match match;

  const MatchLiveTicker(this.match);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Live Ticker"))
    );
  }
}
