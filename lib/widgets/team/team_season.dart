import 'package:flutter/material.dart';

import 'package:flutter_football/models/models.dart';

class TeamSeason extends StatelessWidget {
  final Team team;

  const TeamSeason(this.team);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Season")));
  }
}
