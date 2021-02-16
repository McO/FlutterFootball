import 'package:FlutterFootball/models/api_football/models.dart';

class Goals {
  final int for_;
  final int against;

  const Goals({this.for_, this.against});

  static Goals fromJson(dynamic json) {
    return Goals(
      for_: json['for'] as int,
      against: json['against'] as int,
    );
  }
}

class PositionDetails {
  final int played;
  final int win;
  final int draw;
  final int lose;
  final Goals goals;

  const PositionDetails({this.played, this.win, this.draw, this.lose, this.goals});

  static PositionDetails fromJson(dynamic json) {
    return PositionDetails(
      played: json['played'] as int,
      win: json['win'] as int,
      draw: json['draw'] as int,
      lose: json['lose'] as int,
      goals: Goals.fromJson(json['goals']),
    );
  }
}

class Position {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final PositionDetails all;
  final PositionDetails home;
  final PositionDetails away;
  final String status;
  final String form;
  final String description;
  final String group;

  const Position(
      {this.rank,
      this.team,
      this.points,
      this.goalsDiff,
      this.all,
      this.away,
      this.home,
      this.status,
      this.form,
      this.description,
      this.group});

  static Position fromJson(dynamic json) {
    return Position(
      rank: json['rank'] as int,
      team: Team.fromJson(json['team']),
      points: json['points'] as int,
      goalsDiff: json['goalsDiff'] as int,
      all: PositionDetails.fromJson(json['all']),
      home: PositionDetails.fromJson(json['home']),
      away: PositionDetails.fromJson(json['away']),
      status: json['status'] as String,
      form: json['form'] as String,
      description: json['description'] as String,
      group: json['group'] as String,
    );
  }
}

class PositionContainer {
  final List<Position> positions;

  const PositionContainer({this.positions});

  static PositionContainer fromJson(dynamic json) {
    return PositionContainer(positions: (json as List).map((i) => Position.fromJson(i)).toList());
  }
}

class StandingsLeague {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String flag;
  final int season;
  final List<PositionContainer> standings;

  const StandingsLeague({this.id, this.name, this.country, this.logo, this.flag, this.season, this.standings});

  static StandingsLeague fromJson(dynamic json) {
    return StandingsLeague(
        id: json['id'] as int,
        name: json['name'] as String,
        country: json['country'] as String,
        logo: json['logo'] as String,
        flag: json['flag'] as String,
        season: json['season'] as int,
        standings: (json['standings'] as List).map((i) => PositionContainer.fromJson(i)).toList()
        //List<Position>.from(json['standings'].map((i) => Position.fromJson(i))).toList()
        //List<Position>.from(json['standings']).map((Map model)=> Position.fromJson(model)).toList()
        // (json['standings'] as List<dynamic>)
        //     .map((dynamic item) => Position.fromJson(item as Map<String, dynamic>))
        // .toList()
        );
  }
}

class StandingsLeagueContainer {
  final StandingsLeague league;

  const StandingsLeagueContainer({this.league});

  static StandingsLeagueContainer fromJson(dynamic json) {
    return StandingsLeagueContainer(
      league: StandingsLeague.fromJson(json['league']),
    );
  }
}

class StandingsResponse {
  final int results;
  final List<StandingsLeagueContainer> leagues;

  const StandingsResponse({this.results, this.leagues});

  static StandingsResponse fromJson(dynamic json) {
    var leagueObjsJson = json['response'] as List;
    var _leagues = leagueObjsJson.map((leagueJson) => StandingsLeagueContainer.fromJson(leagueJson)).toList();

    return StandingsResponse(
      results: json['results'] as int,
      leagues: _leagues,
    );
  }
}
