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

  Future<List<Match>> matches(DateTime fromDate, DateTime toDate) async {
    final resultAPI = await apiFootballClient.matches(fromDate, toDate);
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