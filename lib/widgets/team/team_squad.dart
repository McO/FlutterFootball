import 'package:flutter/material.dart';

import 'package:FlutterFootball/models/models.dart';

class TeamSquad extends StatelessWidget {
  final Team team;

  const TeamSquad(this.team);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Squad"))
    );
  }
}
