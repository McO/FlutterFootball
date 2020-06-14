import 'package:FlutterFootball/models/models.dart';

enum Status { Up, Same, Down }

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
  final String description;
  final String form;
  final Status status;

  const Position(
      {this.rank,
      this.team,
      this.played,
      this.points,
      this.goalsFor,
      this.goalsAgainst,
      this.wins,
      this.draws,
      this.losses,
      this.description,
      this.form,
      this.status});

  int get goalsDifference {
    return goalsFor - goalsAgainst;
  }
}

class Standings {
  String description;
  List<Position> positions;

  Standings({this.description, this.positions});
}
