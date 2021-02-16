import 'package:flutter_football/models/api_football/models.dart';

class FixturesCoverage {
  final bool events;
  final bool lineups;
  final bool statisticsFixtures;
  final bool statisticsPlayers;

  const FixturesCoverage({this.events, this.lineups, this.statisticsFixtures, this.statisticsPlayers});

  static FixturesCoverage fromJson(dynamic json) {
    return FixturesCoverage(
      events: json['events'] as bool,
      lineups: json['lineups'] as bool,
      statisticsFixtures: json['statistics_fixtures'] as bool,
      statisticsPlayers: json['statistics_players'] as bool,
    );
  }
}

class Coverage {
  final FixturesCoverage fixtures;
  final bool standings;
  final bool players;
  final bool topScorers;
  final bool predictions;
  final bool odds;

  const Coverage({this.fixtures, this.standings, this.players, this.topScorers, this.predictions, this.odds});

  static Coverage fromJson(dynamic json) {
    return Coverage(
      fixtures: FixturesCoverage.fromJson(json['fixtures']),
      standings: json['standings'] as bool,
      players: json['players'] as bool,
      topScorers: json['topScorers'] as bool,
      predictions: json['predictions'] as bool,
      odds: json['odds'] as bool,
    );
  }
}

class Season {
  final int year;
  final String start;
  final String end;
  final bool current;
  final Coverage coverage;

  const Season({this.year, this.start, this.end, this.current, this.coverage});

  static Season fromJson(dynamic json) {
    return Season(
      year: json['year'] as int,
      start: json['start'] as String,
      end: json['end'] as String,
      current: json['current'] as bool,
      coverage: Coverage.fromJson(json['coverage']),
    );
  }
}

class LeagueDetails {
  final int id;
  final String name;
  final String type;
  final String logo;

  const LeagueDetails({this.id, this.name, this.type, this.logo});

  static LeagueDetails fromJson(dynamic json) {
    return LeagueDetails(
        id: json['id'] as int,
        name: json['name'] as String,
        type: json['type'] as String,
        logo: json['logo'] as String);
  }
}

class League {
  final LeagueDetails league;
  final Country country;
  final List<Season> seasons;

  const League({this.league, this.country, this.seasons});

  static League fromJson(dynamic json) {
    return League(
        league: LeagueDetails.fromJson(json['league']),
        country: Country.fromJson(json['country']),
        seasons: (json['seasons'] as List).map((leagueJson) => Season.fromJson(leagueJson)).toList());
  }
}

class LeaguesResponse {
  final int results;
  final List<League> leagues;

  const LeaguesResponse({this.results, this.leagues});

  static LeaguesResponse fromJson(dynamic json) {
    var leagueObjsJson = json['response'] as List;
    List<League> _leagues = leagueObjsJson.map((leagueJson) => League.fromJson(leagueJson)).toList();

    return LeaguesResponse(
      results: json['results'] as int,
      leagues: _leagues,
    );
  }
}
