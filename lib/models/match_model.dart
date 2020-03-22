import 'score_model.dart';
import 'team_model.dart';

class MatchModel {
  final TeamModel homeTeam;
  final TeamModel awayTeam;
  final String time;
  final ScoreModel score;

  MatchModel({this.homeTeam, this.awayTeam, this.time, this.score});
}
