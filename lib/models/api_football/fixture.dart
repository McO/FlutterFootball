import 'package:flutter_football/models/api_football/models.dart';

class FixtureTeams {
  final Team home;
  final Team away;

  const FixtureTeams({this.home, this.away});

  static FixtureTeams fromJson(dynamic json) {
    return FixtureTeams(home: Team.fromJson(json['home']), away: Team.fromJson(json['away']));
  }
}

class Venue {
  final int id;
  final String name;
  final String city;

  const Venue({this.id, this.name, this.city});

  static Venue fromJson(dynamic json) {
    return Venue(id: json['id'] as int, name: json['name'] as String, city: json['city'] as String);
  }
}

class FixtureStatus {
  final String long;
  final String short;
  final int ellapsed;

  const FixtureStatus({this.long, this.short, this.ellapsed});

  static FixtureStatus fromJson(dynamic json) {
    var status;
    try {
      status = FixtureStatus(
          long: json['long'] as String, short: json['short'] as String, ellapsed: json['ellapsed'] as int);
    } catch (e) {
      print(e);
      print(json);
    }

    return status;
  }
}

class FixtureDetails {
  final int id;
  final Venue venue;
  final String referee;
  final String timezone;
  final DateTime date;
  final FixtureStatus status;

  const FixtureDetails({this.id, this.venue, this.referee, this.timezone, this.date, this.status});

  static FixtureDetails fromJson(dynamic json) {
    var fixture;
    try {
      fixture = FixtureDetails(
          id: json['id'] as int,
          venue: Venue.fromJson(json['venue']),
          referee: json['referee'] as String,
          timezone: json['timezone'] as String,
          date: DateTime.parse(json['date'] as String),
          status: FixtureStatus.fromJson(json['status']));
    } catch (e) {
      print(e);
      print(json);
    }

    return fixture;
  }
}

class Fixture {
  final FixtureDetails details;
  final FixtureLeague league;
  final FixtureTeams teams;
  final ScoreDetail goals;
  final Score score;

  const Fixture({this.details, this.league, this.teams, this.goals, this.score});

  static Fixture fromJson(dynamic json) {
    return Fixture(
        details: FixtureDetails.fromJson(json['fixture']),
        league: FixtureLeague.fromJson(json['league']),
        teams: FixtureTeams.fromJson(json['teams']),
        goals: ScoreDetail.fromJson(json['goals']),
        score: Score.fromJson(json['score']));
  }
}

class FixturesResult {
  final List<Fixture> fixtures;
  final int results;

  const FixturesResult({this.fixtures, this.results});

  static FixturesResult fromJson(Map<String, dynamic> json) {
    List<Fixture> items;
    int results;

    try {
      results = json['results'] as int;
      items = (json['response'] as List<dynamic>)
          .map((dynamic item) => Fixture.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
    }

    return FixturesResult(fixtures: items, results: results);
  }
}
