import 'dart:math';

import 'package:FlutterFootball/models/competition.dart';
import 'package:FlutterFootball/models/day_competiition_matches.dart';
import 'package:FlutterFootball/models/day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/score.dart';
import '../models/team.dart';
import '../models/match.dart';
import '../widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  @override
  MatchesScreenState createState() {
    return new MatchesScreenState();
  }
}

class MatchesScreenState extends State<MatchesScreen> {
  List<Match> getMatches(int count) {
    var numGenerator = new Random();
    List<Match> matches = [];

    for (var i = 0; i < count; i++) {
      var homeTeamIndex = numGenerator.nextInt(dummyTeams.length);
      var awayTeamIndex;
      do {
        awayTeamIndex = numGenerator.nextInt(dummyTeams.length);
      } while (awayTeamIndex == homeTeamIndex);

      matches.add(
        new Match(
          homeTeam: dummyTeams[homeTeamIndex],
          awayTeam: dummyTeams[awayTeamIndex],
          time: "15:30",
          score: new Score(home: numGenerator.nextInt(4), away: numGenerator.nextInt(4)),
        ),
      );
    }

    return matches;
  }

  List<DayCompetitionMatches> getDayCompetitionMatches(DateTime date) {
    List<DayCompetitionMatches> dayCompetitionMatches = [];

    dayCompetitionMatches.add(new DayCompetitionMatches(
        date: date, competition: dummyCompetitions[0], matchDayName: "", matches: getMatches(5)));

    return dayCompetitionMatches;
  }

  List<Day> getDays(int count) {
    List<Day> days = [];

    for (var i = 1; i < count + 1; i++) {
      var date = DateTime.now().add(new Duration(days: i * 7));

      days.add(
        new Day(
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
    List<Day> days = getDays(3);

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
