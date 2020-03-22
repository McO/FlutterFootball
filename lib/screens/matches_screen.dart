import 'dart:math';

import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../models/team_model.dart';
import '../models/match_model.dart';
import '../widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  @override
  MatchesScreenState createState() {
    return new MatchesScreenState();
  }
}

class MatchesScreenState extends State<MatchesScreen> {
  List<MatchModel> getMatches() {
    var numGenerator = new Random();
    List<MatchModel> matches = [];

    for (var i = 0; i < 10; i++) {
      var homeTeamIndex = numGenerator.nextInt(dummyTeams.length);
      var awayTeamIndex;
      do {
        awayTeamIndex = numGenerator.nextInt(dummyTeams.length);
      } while (awayTeamIndex == homeTeamIndex);

      matches.add(
        new MatchModel(
          homeTeam: dummyTeams[homeTeamIndex],
          awayTeam: dummyTeams[awayTeamIndex],
          time: "15:30",
          score: new ScoreModel(home: numGenerator.nextInt(4), away: numGenerator.nextInt(4)),
        ),
      );
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    List<MatchModel> matches = getMatches();

    return new ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, i) => new Column(
        children: <Widget>[
          new Divider(
            height: 5.0,
          ),
          new MatchCard(matches[i])
        ],
      ),
    );
  }
}
