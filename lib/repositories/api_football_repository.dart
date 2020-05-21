import 'dart:async';

import 'package:meta/meta.dart';

import 'package:FlutterFootball/repositories/api_football_client.dart';
import 'package:FlutterFootball/models/api_football/models.dart';

class ApiFootballRepository {
  final ApiFootballClient apiFootballClient;

  ApiFootballRepository({@required this.apiFootballClient})
      : assert(apiFootballClient != null);


  Future<List<League>> leagues(String countryCode) async {
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

  Future<List<Team>> teams(List<int> areaIds) async {
    final resultAPI = await apiFootballClient.teams(areaIds);
    return resultAPI;
  }

  Future<List<Country>> countries() async {
    final resultAPI = await apiFootballClient.countries();
    return resultAPI;
  }
}