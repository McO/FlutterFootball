import 'package:FlutterFootball/models/api_football/models.dart';

class LeagueDetails {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String flag;
  final int season;
  final String round;

  const LeagueDetails({this.id, this.name, this.country, this.logo, this.flag, this.season, this.round});

  static LeagueDetails fromJson(dynamic json) {
    return LeagueDetails(
        id: json['id'] as int,
        name: json['name'] as String,
        country: json['country'] as String,
        logo: json['logo'] as String,
        flag: json['flag'] as String,
        season: json['season'] as int,
        round: json['round'] as String);
  }
}

class League {
  final LeagueDetails league;
  final Country country;

  const League({this.league, this.country});

  static League fromJson(dynamic json) {
    return League(
        league: LeagueDetails.fromJson(json['league']),
        country: Country.fromJson(json['country'])
    );
  }
}

class LeaguesResponse {
  final int results;
  final List<League> leagues;

  const LeaguesResponse({this.results, this.leagues});

  static LeaguesResponse fromJson(dynamic json) {
    var leagueObjsJson = json['response'] as List;
    List<League> _leagues = leagueObjsJson
        .map((leagueJson) => League.fromJson(leagueJson))
        .toList();

    return LeaguesResponse(
      results: json['results'] as int,
      leagues: _leagues,
    );
  }
}
