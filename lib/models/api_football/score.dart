class Score {
  final ScoreDetail fulltime;
  final ScoreDetail halftime;
  final ScoreDetail extratime;
  final ScoreDetail penalty;

  const Score({this.fulltime, this.halftime, this.extratime, this.penalty});

  static Score fromJson(dynamic json) {
    return Score(
        fulltime: ScoreDetail.fromJson(json['fulltime']),
        halftime: ScoreDetail.fromJson(json['halftime']),
        extratime: ScoreDetail.fromJson(json['extratime']),
        penalty: ScoreDetail.fromJson(json['penalty']));
  }
}

class ScoreDetail {
  final int home;
  final int away;

  const ScoreDetail({this.home, this.away});

  static ScoreDetail fromJson(dynamic json) {
    return ScoreDetail(home: json['home'] as int, away: json['away'] as int);
  }
}
