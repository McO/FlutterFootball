import 'package:FlutterFootball/models/competition_model.dart';
import 'package:FlutterFootball/models/match_model.dart';

class MatchDayModel {
  final CompetitionModel competition;
  final String name;
  final List<MatchModel> matches;

  MatchDayModel({this.competition, this.name, this.matches});
}