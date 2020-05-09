class Score {
  final String winner;
  final String duration;
  final ScoreDetail fullTime;
  final ScoreDetail halfTime;
  final ScoreDetail extraTime;
  final ScoreDetail penalties;

  const Score({this.winner, this.duration, this.fullTime, this.halfTime, this.extraTime, this.penalties});

  static Score fromJson(dynamic json) {
    return Score(
        winner: json['winner'] as String,
        duration: json['duration'] as String,
        fullTime: ScoreDetail.fromJson(json['fullTime']),
        halfTime: ScoreDetail.fromJson(json['halfTime']),
        extraTime: ScoreDetail.fromJson(json['extraTime']),
        penalties: ScoreDetail.fromJson(json['penalties']));
  }
}

class ScoreDetail {
  final int homeTeam;
  final int awayTeam;

  const ScoreDetail({this.homeTeam, this.awayTeam});

  static ScoreDetail fromJson(dynamic json) {
    return ScoreDetail(
        homeTeam: json['homeTeam'] as int,
        awayTeam: json['awayTeam'] as int);
    }
}

