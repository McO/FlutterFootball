import 'package:FlutterFootball/models/api_football/models.dart';

class PlayerStatistics {
  final Player player;
  final String value;

  const PlayerStatistics({this.player, this.value});

  static PlayerStatistics fromJson(dynamic json) {
    // String stringValue;
    // int intValue;
    // try {
    //   stringValue = json['value'] as String;
    // } 
    // catch (e) {
    //   intValue = json['value'] as int;
    // }

    return PlayerStatistics(
      player: Player.fromJson(json['player']),
      // value: stringValue ?? intValue?.toString() ?? '0',
    );
  }
}

class FixturePlayersStatistics {
  final Team team;
  final List<PlayerStatistics> playerStatistics;

  const FixturePlayersStatistics({this.team, this.playerStatistics});

  static FixturePlayersStatistics fromJson(dynamic json) {
    return FixturePlayersStatistics(
        team: Team.fromJson(json['team']),
        playerStatistics: (json['players'] as List<dynamic>)
            .map((dynamic item) => PlayerStatistics.fromJson(item as Map<String, dynamic>))
            .toList());
  }
}

class FixturePlayerStatisticsResult {
  final List<FixturePlayersStatistics> fixturePlayersStatistics;
  final int results;

  const FixturePlayerStatisticsResult({this.fixturePlayersStatistics, this.results});

  static FixturePlayerStatisticsResult fromJson(Map<String, dynamic> json) {
    List<FixturePlayersStatistics> items;
    int results;

    try {
      results = json['results'] as int;
      items = (json['response'] as List<dynamic>)
          .map((dynamic item) => FixturePlayersStatistics.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
    }

    return FixturePlayerStatisticsResult(fixturePlayersStatistics: items, results: results);
  }
}
