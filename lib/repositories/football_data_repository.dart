import 'dart:async';

import 'package:meta/meta.dart';

import 'package:FlutterFootball/repositories/football_data_client.dart';
import 'package:FlutterFootball/models/api/models.dart';

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
}