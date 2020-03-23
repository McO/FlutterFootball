import 'package:FlutterFootball/models/team_model.dart';

class CompetitionModel {
  final int id;
  final String name;
  final String logoUrl;
  final List<TeamModel> teams;

  CompetitionModel({this.id, this.name, this.logoUrl, this.teams});
}

List<CompetitionModel> dummyCompetitions = [
  new CompetitionModel(id: 1, name: "Bundesliga", teams: null),
  new CompetitionModel(id: 2, name: "Premier League", teams: null),
];