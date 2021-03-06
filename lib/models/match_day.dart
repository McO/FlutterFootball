import 'package:flutter_football/models/models.dart';

class MatchDayModel {
  final Competition competition;
  final String name;
  final List<Match> matches;

  MatchDayModel({this.competition, this.name, this.matches});
}
