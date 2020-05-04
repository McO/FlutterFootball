import 'score.dart';
import 'team.dart';

class Match {
  final Team homeTeam;
  final Team awayTeam;
  final String time;
  final Score score;
  final MatchStatus status;

  Match({this.homeTeam, this.awayTeam, this.time, this.score, this.status});
}

enum MatchStatus {
  Scheduled,
  Postponed,
  Cancelled,
  Suspended,
  In_Play,
  Paused,
  Finished,
  Awarded
}