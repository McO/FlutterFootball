import 'package:FlutterFootball/models/api_football/models.dart';

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
