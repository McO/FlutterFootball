import 'package:FlutterFootball/models/competition.dart';
import 'package:FlutterFootball/models/match.dart';

class DayCompetitionMatches {
  final DateTime date;
  final Competition competition;
  final String matchDayName;
  final List<Match> matches;

  DayCompetitionMatches({this.date, this.competition,this.matchDayName, this.matches});
}