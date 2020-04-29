import 'package:FlutterFootball/models/day_competition_matches.dart';

class Day {
  final DateTime date;
  final List<DayCompetitionMatches> dayCompetitionsMatches;

  Day({this.date, this.dayCompetitionsMatches});
}
