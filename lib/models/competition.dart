import 'package:FlutterFootball/models/models.dart';

class Competition {
  final int id;
  final String name;
  final String logoUrl;
  final List<Team> teams;

  const Competition({this.id, this.name, this.logoUrl, this.teams});
}
