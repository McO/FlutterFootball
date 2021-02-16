import 'package:FlutterFootball/models/football_data/models.dart';

class Match {
  final int id;
  final MatchCompetition competition;
  final DateTime utcDate;
  final String status;
  final int matchDay;
  final String stage;
  final String group;
  final Score score;
  final MatchTeam homeTeam;
  final MatchTeam awayTeam;

  const Match(
      {this.id,
      this.competition,
      this.utcDate,
      this.status,
      this.matchDay,
      this.stage,
      this.group,
      this.score,
      this.homeTeam,
      this.awayTeam});

  static Match fromJson(dynamic json) {
    return Match(
        id: json['id'] as int,
        competition: MatchCompetition.fromJson(json['competition']),
        utcDate: DateTime.parse(json['utcDate'] as String),
        status: json['status'] as String,
        matchDay: json['matchday'] as int,
        stage: json['stage'] as String,
        group: json['group'] as String,
        score: Score.fromJson(json['score']),
        homeTeam: MatchTeam.fromJson(json['homeTeam']),
        awayTeam: MatchTeam.fromJson(json['awayTeam']));
  }
}

class MatchesResult {
  final List<Match> matches;

  const MatchesResult({this.matches});

  static MatchesResult fromJson(Map<String, dynamic> json) {
    List<Match> items;
    try {
      items = (json['matches'] as List<dynamic>)
          .map((dynamic item) => Match.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
    }

    return MatchesResult(matches: items);
  }
}
