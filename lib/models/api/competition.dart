import 'package:FlutterFootball/models/api/models.dart';

class Competition {
  final int id;
  final String name;
  final String logoUrl;
  final List<Team> teams;
  final Area area;

  const Competition({this.id, this.name, this.logoUrl, this.teams, this.area});

  static Competition fromJson(dynamic json) {
    return Competition(
        id: json['id'] as int,
        name: json['name'] as String,
        area: Area.fromJson(json['area'])
    );
  }
}

class CompetitionsResult {
  final List<Competition> competitions;

  const CompetitionsResult({this.competitions});

  static CompetitionsResult fromJson(Map<String, dynamic> json) {
    final items = (json['competitions'] as List<dynamic>)
        .map((dynamic item) =>
        Competition.fromJson(item as Map<String, dynamic>))
        .toList();
    return CompetitionsResult(competitions: items);
  }
}

