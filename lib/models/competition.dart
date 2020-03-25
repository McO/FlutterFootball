import 'package:FlutterFootball/models/team.dart';

class Competition {
  final int id;
  final String name;
  final String logoUrl;
  final List<Team> teams;

  Competition({this.id, this.name, this.logoUrl, this.teams});
}

List<Competition> dummyCompetitions = [
  new Competition(id: 1, name: "Bundesliga", teams: null),
  new Competition(id: 2, name: "Premier League", teams: null),
];