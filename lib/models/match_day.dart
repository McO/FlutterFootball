import 'package:FlutterFootball/models/competition.dart';
import 'package:FlutterFootball/models/match.dart';

class MatchDayModel {
  final Competition competition;
  final String name;
  final List<Match> matches;

  MatchDayModel({this.competition, this.name, this.matches});
}