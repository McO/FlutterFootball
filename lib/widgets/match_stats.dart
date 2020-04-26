import 'package:flutter/material.dart';

import '../models/match.dart';

class MatchStats extends StatelessWidget {
  final Match match;

  const MatchStats(this.match);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Stats"))
    );
  }
}
