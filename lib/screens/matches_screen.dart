import 'dart:math';

import 'package:FlutterFootball/models/competition_model.dart';
import 'package:FlutterFootball/models/day_competiition_matches.dart';
import 'package:FlutterFootball/models/day_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<MatchModel> getMatches(int count) {
    var numGenerator = new Random();
    List<MatchModel> matches = [];

    for (var i = 0; i < count; i++) {
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

  List<DayCompetitionMatchesModel> getDayCompetitionMatches(DateTime date) {
    List<DayCompetitionMatchesModel> dayCompetitionMatches = [];

    dayCompetitionMatches.add(new DayCompetitionMatchesModel(
        date: date, competition: dummyCompetitions[0], matchDayName: "", matches: getMatches(5)));

    return dayCompetitionMatches;
  }

  List<DayModel> getDays(int count) {
    List<DayModel> days = [];

    for (var i = 1; i < count + 1; i++) {
      var date = DateTime.now().add(new Duration(days: i * 7));

      days.add(
        new DayModel(
          date: date,
          dayCompetitionsMatches: getDayCompetitionMatches(date),
        ),
      );
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
//    List<MatchModel> matches = getMatches(10);
    List<DayModel> days = getDays(3);

    return new ListView.builder(
      itemCount: days.length,
      itemBuilder: (context, i) => new Column(
        children: <Widget>[
          Container(
              child: Text(
            DateFormat('EEEE, MMMM d').format(days[i].date),
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
          ListView.builder(
            shrinkWrap: true,
            itemCount: days[i].dayCompetitionsMatches.length,
            itemBuilder: (context, j) => Card(
              child: new Column(
                children: <Widget>[
                  Container(
                      child: Text(
                    days[i].dayCompetitionsMatches[j].competition.name,
                    textAlign: TextAlign.start,
                    style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  new ListView.builder(
                    shrinkWrap: true,
                    itemCount: days[i].dayCompetitionsMatches[j].matches.length,
                    itemBuilder: (context, k) => new Column(
                      children: <Widget>[
                        new Divider(
                          height: 5.0,
                        ),
                        new MatchCard(days[i].dayCompetitionsMatches[j].matches[k])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

//    return new ListView.builder(
//      itemCount: matches.length,
//      itemBuilder: (context, i) => new Column(
//        children: <Widget>[
//          new Divider(
//            height: 5.0,
//          ),
//          new MatchCard(matches[i])
//        ],
//      ),
//    );
  }
}
