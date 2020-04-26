import 'dart:math';

import 'package:FlutterFootball/models/models.dart';

class DummyFootballRepository {
  List<CompetitionBase> dummyCompetitions = [
    new CompetitionBase(id: 1, name: "Bundesliga", teams: null),
    new CompetitionBase(id: 2, name: "Premier League", teams: null),
  ];

  List<Team> dummyTeams = [
    new Team(id: 1, name: "Union Berlin", logoUrl: ""),
    new Team(id: 2, name: "Hertha BSC", logoUrl: ""),
    new Team(id: 3, name: "Bayern München", logoUrl: ""),
    new Team(id: 4, name: "Borussia Dortmund", logoUrl: ""),
    new Team(id: 5, name: "Werder Bremen", logoUrl: ""),
    new Team(id: 6, name: "Schalke 04", logoUrl: ""),
    new Team(id: 7, name: "Eintracht Frankfurt", logoUrl: ""),
    new Team(id: 8, name: "Bayer 04 Leverkusen", logoUrl: ""),
    new Team(id: 9, name: "RB Leipzig", logoUrl: ""),
    new Team(id: 10, name: "1. FC Köln", logoUrl: ""),
    new Team(id: 11, name: "Fortuna Düsseldorf", logoUrl: ""),
    new Team(id: 12, name: "SC Freiburg", logoUrl: ""),
    new Team(id: 13, name: "VfL Wolfsburg", logoUrl: ""),
    new Team(id: 14, name: "SC Paderborn", logoUrl: ""),
    new Team(id: 15, name: "SC Augsburg", logoUrl: ""),
    new Team(id: 16, name: "Hoffenheim", logoUrl: ""),
  ];

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
    var random = new Random();
    List<DayCompetitionMatches> dayCompetitionMatches = [];

    dayCompetitionMatches.add(new DayCompetitionMatches(
        date: date, competition: dummyCompetitions[0], matchDayName: "10. Spieltag", matches: getMatches(1 + random.nextInt(5))));

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

  Future<List<Day>> fetchMatches() async {

    return getDays(5);
  }
}


