import 'package:FlutterFootball/models/models.dart';

class CompetitionBase {
  final int id;
  final String name;
  final String logoUrl;
  final List<Team> teams;

  const CompetitionBase({this.id, this.name, this.logoUrl, this.teams});
}
