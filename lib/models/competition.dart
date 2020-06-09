import 'package:FlutterFootball/models/models.dart';

enum CompetitionType
{
  Cup,
  League
}

class Competition {
  final int id;
  final String name;
  final String logoUrl;
  final String country;
  final List<Team> teams;
  final bool hasStandings;
  final int year;
  final CompetitionType type;

  const Competition({this.id, this.name, this.logoUrl, this.country, this.teams, this.hasStandings, this.year, this.type});

  String toString() {
    return "Competition: $name";
  }
}
