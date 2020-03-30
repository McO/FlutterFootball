import 'package:flutter/material.dart';
import '../models/match.dart';

class MatchLineUp extends StatelessWidget {
  final Match match;

  const MatchLineUp(this.match);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Line-up"))
    );
  }
}
