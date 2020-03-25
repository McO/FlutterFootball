import 'package:FlutterFootball/models/team.dart';

class Competition {
  final int id;
  final String name;
  final String logoUrl;
  final List<Team> teams;

  Competition({this.id, this.name, this.logoUrl, this.teams});
}
