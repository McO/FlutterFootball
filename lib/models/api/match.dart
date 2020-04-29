import 'package:FlutterFootball/models/api/models.dart';

class Match {
  final int id;
  final Competition competition;
  final DateTime utcDate;
  final Score score;
  final Team homeTeam;
  final Team awayTeam;

  const Match({this.id, this.competition, this.utcDate, this.score, this.homeTeam, this.awayTeam});

  static Match fromJson(dynamic json) {
    return Match(
        id: json['id'] as int,
        competition: Competition.fromJson(json['competition']),
        utcDate: json['utcDate'] as DateTime,
        score: Score.fromJson(json['score']),
        homeTeam: Team.fromJson(json['homeTeam']),
        awayTeam: Team.fromJson(json['awayTeam']));
  }
}


class MatchesResult {
  final List<Match> matches;

  const MatchesResult({this.matches});

  static MatchesResult fromJson(Map<String, dynamic> json) {
    final items = (json['matches'] as List<dynamic>)
        .map((dynamic item) =>
        Match.fromJson(item as Map<String, dynamic>))
        .toList();
    return MatchesResult(matches: items);
  }
}

