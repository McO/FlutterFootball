import 'package:FlutterFootball/models/models.dart';

class Competition {
  final int id;
  final String name;
  final String logoUrl;
  final String country;
  final List<Team> teams;
  final bool hasStandings;
  final int year;

  const Competition({this.id, this.name, this.logoUrl, this.country, this.teams, this.hasStandings, this.year});

  String toString() {
    return "Competition: $name";
  }
}
