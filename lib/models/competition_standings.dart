import 'package:FlutterFootball/models/models.dart';

class Position {
  final int rank;
  final Team team;
  final int played;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final int wins;
  final int draws;
  final int losses;

  const Position(
      {this.rank, this.team, this.played, this.points, this.goalsFor, this.goalsAgainst, this.wins, this.draws, this.losses});

  int get goalsDifference {
    return goalsFor - goalsAgainst;
  }
}

class Standings {
  List<Position> positions;

  Standings({this.positions});
}
