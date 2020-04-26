import 'dart:async';

import 'package:meta/meta.dart';

import 'package:FlutterFootball/repositories/football_data_client.dart';
import 'package:FlutterFootball/models/models.dart';

class FootballDataRepository {
  final FootballDataClient footballDataClient;

  FootballDataRepository({@required this.footballDataClient})
      : assert(footballDataClient != null);


  Future<List<CompetitionBase>> competitions() async {
    final resultAPI = await footballDataClient.competitions();
    return resultAPI;
  }
}