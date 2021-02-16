import 'package:flutter_football/models/models.dart';

class Lineup {
  Team team;
  // Coach coach;
  List<Player> startingPlayers;
  List<Player> benchPlayers;
  String formation;

  Lineup({this.team});
}

class MatchLineups {
  final String matchId;
  final Lineup home;
  final Lineup away;

  MatchLineups({this.matchId, this.home, this.away});
}
