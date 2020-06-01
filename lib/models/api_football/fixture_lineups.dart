import 'package:FlutterFootball/models/api_football/models.dart';

class Coach {
  final int id;
  final String name;

  const Coach({this.id, this.name});

  static Coach fromJson(dynamic json) {
    return Coach(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class PlayerContainer {
  final Player player;

  const PlayerContainer({this.player});

  static PlayerContainer fromJson(dynamic json) {
    return PlayerContainer(
      player: Player.fromJson(json['player']),
    );
  }
}

class Lineup {
  final Team team;
  final Coach coach;
  final String formation;
  final List<PlayerContainer> startXI;
  final List<PlayerContainer> substitutes;

  const Lineup({this.team, this.coach, this.formation, this.startXI, this.substitutes});

  static Lineup fromJson(dynamic json) {
    return Lineup(
      team: Team.fromJson(json['team']),
      coach: Coach.fromJson(json['coach']),
      formation: json['formation'] as String,
      startXI: (json['startXI'] as List<dynamic>)
          .map((dynamic item) => PlayerContainer.fromJson(item as Map<String, dynamic>))
          .toList(),
      substitutes: (json['substitutes'] as List<dynamic>)
          .map((dynamic item) => PlayerContainer.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FixtureLineupsResult {
  final List<Lineup> lineups;
  final int results;

  const FixtureLineupsResult({this.lineups, this.results});

  static FixtureLineupsResult fromJson(Map<String, dynamic> json) {
    List<Lineup> items;
    int results;

    try {
      results = json['results'] as int;
      items = (json['response'] as List<dynamic>)
          .map((dynamic item) => Lineup.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
    }

    return FixtureLineupsResult(lineups: items, results: results);
  }
}
