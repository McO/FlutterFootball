import 'score.dart';
import 'team.dart';

class Match {
  final String matchId;
  final Team homeTeam;
  final Team awayTeam;
  final String time;
  final Score score;
  final MatchStatus status;

  Match({this.matchId, this.homeTeam, this.awayTeam, this.time, this.score, this.status});
}

enum MatchStatus { Unknown, Scheduled, Postponed, Cancelled, Suspended, In_Play, Paused, Finished, Awarded }
