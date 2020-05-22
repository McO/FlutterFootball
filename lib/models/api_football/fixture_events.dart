import 'package:FlutterFootball/models/api_football/models.dart';

class Time {
  final int elapsed;
  final String extra;

  const Time({this.elapsed, this.extra});

  static Time fromJson(dynamic json) {
    return Time(
      elapsed: json['elapsed'] as int,
      extra: json['extra'] as String,
    );
  }
}

class FixtureEvent {
  final Team team;
  final String type;
  final String detail;
  final String comments;
  final Time time;

  const FixtureEvent({this.team, this.type, this.detail, this.comments, this.time});

  static FixtureEvent fromJson(dynamic json) {
    return FixtureEvent(
      team: Team.fromJson(json['team']),
      type: json['type'] as String,
      detail: json['detail'] as String,
      comments: json['comments'] as String,
      time: Time.fromJson(json['time']),
    );
  }
}

class FixtureEventsResult {
  final List<FixtureEvent> fixtureEvents;
  final int results;

  const FixtureEventsResult({this.fixtureEvents, this.results});

  static FixtureEventsResult fromJson(Map<String, dynamic> json) {
    List<FixtureEvent> items;
    int results;

    try {
      results = json['results'] as int;
      items = (json['response'] as List<dynamic>)
          .map((dynamic item) => FixtureEvent.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
    }

    return FixtureEventsResult(fixtureEvents: items, results: results);
  }
}
