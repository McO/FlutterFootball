import 'dart:async';

import 'package:meta/meta.dart';

import 'package:FlutterFootball/repositories/football_data_client.dart';
import 'package:FlutterFootball/models/football_data/models.dart';

class FootballDataRepository {
  final FootballDataClient footballDataClient;

  FootballDataRepository({@required this.footballDataClient})
      : assert(footballDataClient != null);


  Future<List<Competition>> competitions() async {
    final resultAPI = await footballDataClient.competitions();
    return resultAPI;
  }

  Future<List<Match>> matches(DateTime fromDate, DateTime toDate) async {
    final resultAPI = await footballDataClient.matches(fromDate, toDate);
    return resultAPI;
  }

  Future<List<Team>> teams(List<int> areaIds) async {
    final resultAPI = await footballDataClient.teams(areaIds);
    return resultAPI;
  }

  Future<List<Area>> areas() async {
    final resultAPI = await footballDataClient.areas();
    return resultAPI;
  }
}