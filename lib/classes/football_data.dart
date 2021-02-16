import 'package:intl/intl.dart';

import 'package:FlutterFootball/repositories/football_data_repository.dart';

import 'package:FlutterFootball/models/models.dart';
import 'package:FlutterFootball/models/football_data/models.dart' as FootballDataModels;

class FootballData {
  final FootballDataRepository footballDataRepository;

  FootballData(this.footballDataRepository);

  Future handleFootballData(List<Day> days) async {
    final List<FootballDataModels.Match> apiMatches = await footballDataRepository.matches(
        DateTime.now().subtract(Duration(days: 0)), DateTime.now().add(Duration(days: 7)));
    //todo: parametrize date range (maximum 10 days)

    final List<FootballDataModels.Area> apiAreas = await footballDataRepository.areas();
    //      apiMatches.forEach((element) => print('Date: ${element.utcDate.toLocal().toString()}'));

    var areaIds = new List<int>.empty(growable: true);

    //adding match days
    apiMatches.forEach((FootballDataModels.Match m) {
      DateTime matchDateTime = m.utcDate.toLocal();
      DateTime matchDate = new DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);
      if (days.where((d) => d.date == matchDate).length == 0) {
        days.add(
            new Day(date: matchDate, dayCompetitionsMatches: new List<DayCompetitionMatches>.empty(growable: true)));
      }

      var countryCode = m.competition.area.countryCode;
      var areaId = apiAreas.firstWhere((a) => a.countryCode == countryCode).id;
      if (!areaIds.contains(areaId)) {
        areaIds.add(areaId);
      }
    });

    //adding competitions to match days
    days.forEach((Day d) {
      var matcherPerDay = apiMatches.where(
          (m) => m.utcDate.toLocal().isAfter(d.date) && m.utcDate.toLocal().isBefore(d.date.add(Duration(days: 1))));

      matcherPerDay.forEach((m) {
        if (d.dayCompetitionsMatches.where((d) => d.competition.id == m.competition.id).length == 0) {
          d.dayCompetitionsMatches.add(DayCompetitionMatches(
              date: d.date,
              competition:
                  Competition(id: m.competition.id, name: m.competition.name, logoUrl: m.competition.area.ensignUrl),
              matchDayName: getMatchDay(m),
              matches: List<Match>.empty(growable: true)));
        }
      });
    });

    final List<FootballDataModels.Team> apiTeams = await footballDataRepository.teams(areaIds);

    //adding matches
    apiMatches.forEach((FootballDataModels.Match m) {
      try {
        var matchDateTime = m.utcDate.toLocal();
        var matchDate = DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);

        var homeTeam = Team(
            id: m.homeTeam.id,
            name: m.homeTeam.name,
            shortName: apiTeams.firstWhere((t) => t.id == m.homeTeam.id).shortName,
            logoUrl: getLogoUrl(apiTeams, m.homeTeam.id));

        var awayTeam = Team(
            id: m.awayTeam.id,
            name: m.awayTeam.name,
            shortName: apiTeams.firstWhere((t) => t.id == m.awayTeam.id).shortName,
            logoUrl: getLogoUrl(apiTeams, m.awayTeam.id));

        var score = Score(home: m.score.fullTime.homeTeam, away: m.score.fullTime.awayTeam);
        var match = Match(
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          score: score,
          time: DateFormat('HH:mm').format(matchDateTime),
          status: MatchStatus.values.firstWhere((e) => e.toString().toUpperCase() == 'MATCHSTATUS.' + m.status),
        );
        days
            .where((d) => d.date == matchDate)
            .toList()[0]
            .dayCompetitionsMatches
            .where((c) => c.competition.id == m.competition.id)
            .toList()[0]
            .matches
            .add(match);
      } catch (e) {
        print(e);
        print('Match: ${m.id}');
      }
    });
  }

  String getLogoUrl(List<FootballDataModels.Team> apiTeams, int teamId) {
    final apiTeam = apiTeams.firstWhere((t) => t.id == teamId, orElse: () => null);
    if (apiTeam != null) return apiTeam.crestUrl;
    return '';
  }

  String getMatchDay(FootballDataModels.Match match) {
    try {
      if (match.stage == "REGULAR_SEASON") {
        return 'Matchweek ${match.matchDay}';
      }
    } catch (e) {
      print('getMatchDay: $e');
    }
    return '';
  }
}
