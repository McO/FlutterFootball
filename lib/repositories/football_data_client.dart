import 'dart:convert';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

//import 'package:FlutterFootball/models/models.dart';

import 'package:FlutterFootball/models/api/competition.dart';
import 'package:FlutterFootball/models/api/competitions_result.dart';
import 'package:FlutterFootball/models/api/result_error.dart';

class FootballDataClient {
  static const baseUrl = "https://api.football-data.org/v2/";
  final http.Client httpClient;
  final String authToken;

  FootballDataClient({@required this.httpClient, @required this.authToken}) : assert(httpClient != null);

  Future<List<Competition>> competitions() async {
    final response = await httpClient.get(
      Uri.parse("$baseUrl" + "competitions"),
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CompetitionsResult.fromJson(results).competitions;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }
}
