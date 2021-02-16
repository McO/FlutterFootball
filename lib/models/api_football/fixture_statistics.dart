import 'package:flutter_football/models/api_football/models.dart';

class StatisticDetail {
  final String type;
  final String value;

  const StatisticDetail({this.type, this.value});

  static StatisticDetail fromJson(dynamic json) {
    String stringValue;
    int intValue;
    try {
      stringValue = json['value'] as String;
    } catch (e) {
      intValue = json['value'] as int;
    }

    return StatisticDetail(
      type: json['type'] as String,
      value: stringValue ?? intValue?.toString() ?? '0',
    );
  }
}

class FixtureStatistics {
  final Team team;
  final List<StatisticDetail> statistics;

  const FixtureStatistics({this.team, this.statistics});

  static FixtureStatistics fromJson(dynamic json) {
    return FixtureStatistics(
        team: Team.fromJson(json['team']),
        statistics: (json['statistics'] as List<dynamic>)
            .map((dynamic item) => StatisticDetail.fromJson(item as Map<String, dynamic>))
            .toList());
  }
}

class FixtureStatisticsResult {
  final List<FixtureStatistics> fixtureStatistics;
  final int results;

  const FixtureStatisticsResult({this.fixtureStatistics, this.results});

  static FixtureStatisticsResult fromJson(Map<String, dynamic> json) {
    List<FixtureStatistics> items;
    int results;

    try {
      results = json['results'] as int;
      items = (json['response'] as List<dynamic>)
          .map((dynamic item) => FixtureStatistics.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
    }

    return FixtureStatisticsResult(fixtureStatistics: items, results: results);
  }
}
