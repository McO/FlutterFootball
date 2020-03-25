import 'score.dart';
import 'team.dart';

class Match {
  final Team homeTeam;
  final Team awayTeam;
  final String time;
  final Score score;

  Match({this.homeTeam, this.awayTeam, this.time, this.score});
}
