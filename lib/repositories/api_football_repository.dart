import 'dart:async';

import 'package:meta/meta.dart';

import 'package:FlutterFootball/repositories/api_football_client.dart';
import 'package:FlutterFootball/models/api_football/models.dart';

class ApiFootballRepository {
  final ApiFootballClient apiFootballClient;

  ApiFootballRepository({@required this.apiFootballClient})
      : assert(apiFootballClient != null);


  Future<List<League>> leagues() async {
    final resultAPI = await apiFootballClient.leagues(null);
    return resultAPI;
  }

  Future<List<League>> leaguesByCountry(String countryCode) async {
    final resultAPI = await apiFootballClient.leagues(countryCode);
    return resultAPI;
  }

  Future<List<Fixture>> fixtures(DateTime date,{ DateTime fromDate, DateTime toDate, int leagueId, int season}) async {
    final resultAPI = await apiFootballClient.fixtures(date, fromDate, toDate, leagueId, season);
    return resultAPI;
  }

  Future<List<Fixture>> liveFixtures() async {
    final resultAPI = await apiFootballClient.liveFixtures();
    return resultAPI;
  }

  Future<List<FixtureStatistics>> fixturesStatistics(int fixtureId) async {
    final resultAPI = await apiFootballClient.fixtureStatistics(fixtureId);
    return resultAPI;
  }

  Future<List<FixtureEvent>> fixturesEvents(int fixtureId) async {
    final resultAPI = await apiFootballClient.fixtureEvents(fixtureId);
    return resultAPI;
  }

  Future<List<FixturePlayersStatistics>> fixturePlayerStatistics(int fixtureId) async {
    final resultAPI = await apiFootballClient.fixturePlayerStatistics(fixtureId);
    return resultAPI;
  }

  Future<StandingsLeague> standings(int leagueId, int season) async {
    final resultAPI = await apiFootballClient.standings(leagueId, season);
    return resultAPI;
  }
}