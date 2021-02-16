import 'package:intl/intl.dart';

import 'package:flutter_football/repositories/api_football_repository.dart';

import 'package:flutter_football/models/api_football/models.dart' as ApiFootballModels;
import 'package:flutter_football/models/models.dart';

class ApiFootball {
  final ApiFootballRepository apiFootballRepository;

  ApiFootball(this.apiFootballRepository);

  Future<List<Day>> handleApiFootball(List<String> favouriteCompetitions, bool showLiveMatches) async {
    var apiFixtures = List<ApiFootballModels.Fixture>.empty(growable: true);
    var apiLeagues = await apiFootballRepository.leagues();

    if (showLiveMatches) {
      apiFixtures = await apiFootballRepository.liveFixtures();
    } else if (favouriteCompetitions != null && favouriteCompetitions.length > 0) {
      await Future.forEach(favouriteCompetitions, (competition) async {
        var currentSeason = apiLeagues
            .singleWhere((l) => l.league.id == int.parse(competition))
            .seasons
            .singleWhere((s) => s.current == true)
            .year;
        var apiCompetitionFixtures = await apiFootballRepository.fixtures(DateTime.now().add(Duration(days: 0)),
            fromDate: null, toDate: null, leagueId: int.parse(competition), season: currentSeason);
        apiFixtures.addAll(apiCompetitionFixtures);
      });
    } else {
      var tempApiFixtures = await apiFootballRepository.fixtures(DateTime.now().add(Duration(days: 0)),
          fromDate: DateTime.now().subtract(Duration(days: 0)),
          toDate: DateTime.now().add(Duration(days: 7)),
          leagueId: null,
          season: null);
      //TODO hard coded limit
      apiFixtures = tempApiFixtures.toList().take(50).toList();
    }

    print('Matches found:' + apiFixtures.length.toString());

    return getDays(apiFixtures, apiLeagues);
  }

  List<Day> getDays(List<ApiFootballModels.Fixture> apiFixtures, List<ApiFootballModels.League> apiLeagues) {
    var days = List<Day>.empty(growable: true);
    //adding match days
    apiFixtures.forEach((ApiFootballModels.Fixture f) {
      var matchDateTime = f.details.date.toLocal();
      var matchDate = DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);
      if (days.where((d) => d.date == matchDate).length == 0) {
        days.add(Day(date: matchDate, dayCompetitionsMatches: List<DayCompetitionMatches>.empty(growable: true)));
      }
    });

    //adding competitions to match days
    days.forEach((Day day) {
      var matchesPerDay = apiFixtures.where((f) =>
          f.details.date.difference(day.date).inSeconds == 0 ||
          (f.details.date.isAfter(day.date) &&
              f.details.date.isBefore(day.date.add(Duration(days: 1)).subtract(Duration(seconds: 1)))));

      matchesPerDay.forEach((m) {
        if (day.dayCompetitionsMatches.where((d) => d.competition.id == m.league.id).length == 0) {
          day.dayCompetitionsMatches.add(DayCompetitionMatches(
              date: day.date,
              competition: Competition(
                  id: m.league.id,
                  name: m.league.name,
                  logoUrl: m.league.logo,
                  hasStandings: apiLeagues == null ? false : hasStandings(apiLeagues, m.league.id),
                  year: m.league.season,
                  type: apiLeagues == null ? CompetitionType.League : getCompetitionType(apiLeagues, m.league.id)),
              matchDayName: m.league.round,
              matches: List<Match>.empty(growable: true)));
        }
      });
    });

    //adding matches
    apiFixtures.forEach((ApiFootballModels.Fixture f) {
      try {
        var matchDateTime = f.details.date.toLocal();
        var matchDate = DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);

        var match = getMatch(f);
        days
            .firstWhere((d) => d.date == matchDate)
            .dayCompetitionsMatches
            .firstWhere((c) => c.competition.id == f.league.id)
            .matches
            .add(match);
      } catch (e) {
        print(e);
        print('Fixture: ${f.details.id}');
      }
    });

    return days;
  }

  bool hasStandings(List<ApiFootballModels.League> leagues, int competitionId) {
    bool hasStandings = false;
    hasStandings = leagues
        .singleWhere((l) => l.league.id == competitionId)
        .seasons
        .singleWhere((s) => s.current)
        .coverage
        .standings;
    return hasStandings;
  }

  CompetitionType getCompetitionType(List<ApiFootballModels.League> leagues, int competitionId) {
    var type = leagues.singleWhere((l) => l.league.id == competitionId).league.type;
    if (type.toLowerCase() == 'cup') return CompetitionType.Cup;
    return CompetitionType.League;
  }

  Match getMatch(ApiFootballModels.Fixture fixture) {
    var homeTeam = Team(
        id: fixture.teams.home.id,
        name: fixture.teams.home.name,
        shortName: fixture.teams.home.name,
        logoUrl: fixture.teams.home.logo);
    var awayTeam = Team(
        id: fixture.teams.away.id,
        name: fixture.teams.away.name,
        shortName: fixture.teams.away.name,
        logoUrl: fixture.teams.away.logo);

    var score = Score(home: fixture.goals.home, away: fixture.goals.away);
    var match = Match(
      matchId: fixture.details.id.toString(),
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      score: score,
      time: DateFormat('HH:mm').format(fixture.details.date.toLocal()),
      status: getMatchStatus(fixture),
    );
    return match;
  }

  MatchStatus getMatchStatus(ApiFootballModels.Fixture fixture) {
    var status = MatchStatus.Unknown;
    switch (fixture.details.status.short) {
      case 'PST':
        status = MatchStatus.Postponed;
        break;
      case 'FT':
      case 'AET':
      case 'PEN':
        status = MatchStatus.Finished;
        break;
      case 'CANC':
        status = MatchStatus.Cancelled;
        break;
      case '1H':
      case 'HT':
      case '2H':
      case 'ET':
      case 'P':
        status = MatchStatus.In_Play;
        break;
      case 'NS':
        status = MatchStatus.Scheduled;
        break;
    }

// TBD : Time To Be Defined
// NS : Not Started
// 1H : First Half, Kick Off
// HT : Halftime
// 2H : Second Half, 2nd Half Started
// ET : Extra Time
// P : Penalty In Progress
// FT : Match Finished
// AET : Match Finished After Extra Time
// PEN : Match Finished After Penalty
// BT : Break Time (in Extra Time)
// SUSP : Match Suspended
// INT : Match Interrupted
// PST : Match Postponed
// CANC : Match Cancelled
// ABD : Match Abandoned
// AWD : Technical Loss
// WO : WalkOver

    return status;
  }
}
