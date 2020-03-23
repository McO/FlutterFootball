import 'package:FlutterFootball/models/team_model.dart';

class CompetitionModel {
  final String name;
  final String logoUrl;
  final List<TeamModel> teams;

  CompetitionModel({this.name, this.logoUrl, this.teams});
}