import 'package:flutter/material.dart';

import 'package:flutter_football/models/models.dart';

class CompetitionOverview extends StatelessWidget {
  final Competition competition;

  const CompetitionOverview(this.competition);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Overview")));
  }
}
