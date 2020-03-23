import 'package:FlutterFootball/models/competition_model.dart';
import 'package:FlutterFootball/models/match_model.dart';

class DayCompetitionMatchesModel {
  final DateTime date;
  final CompetitionModel competition;
  final String matchDayName;
  final List<MatchModel> matches;

  DayCompetitionMatchesModel({this.date, this.competition,this.matchDayName, this.matches});
}