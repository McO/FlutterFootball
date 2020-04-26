import 'package:FlutterFootball/models/models.dart';

class MatchDayModel {
  final CompetitionBase competition;
  final String name;
  final List<Match> matches;

  MatchDayModel({this.competition, this.name, this.matches});
}