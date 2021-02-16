import 'package:flutter_football/models/football_data/models.dart';

class MatchCompetition {
  final int id;
  final String name;
  final MatchArea area;

  const MatchCompetition({this.id, this.name, this.area});

  static MatchCompetition fromJson(dynamic json) {
    return MatchCompetition(
        id: json['id'] as int, name: json['name'] as String, area: MatchArea.fromJson(json['area']));
  }
}
