import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:FlutterFootball/models/api/models.dart';
import 'package:query_params/query_params.dart';

class FootballDataClient {
  static const baseUrl = "https://api.football-data.org/v2/";
  final http.Client httpClient;
  final String authToken;

  FootballDataClient({@required this.httpClient, @required this.authToken}) : assert(httpClient != null);

  Future<Competition> competition(int competitionId) async {
    final competitionUrl = '$baseUrl/competitions/$competitionId';
    final response = await httpClient.get(
      competitionUrl,
      headers: {'X-Auth-Token': authToken},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final competitionJson = jsonDecode(response.body);
      return Competition.fromJson(competitionJson);
    } else {
      throw ResultError.fromJson(response).message;
    }
  }

  Future<List<Competition>> competitions() async {
    final competitionsUrl = '$baseUrl/competitions';
    final response = await httpClient.get(
      competitionsUrl,
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return CompetitionsResult.fromJson(results).competitions;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<Match>> matches(DateTime fromDate, DateTime toDate) async {
    final competitionsUrl = '$baseUrl/matches';

    URLQueryParams queryParams = new URLQueryParams();

    queryParams.append('dateFrom', new DateFormat("yyyy-MM-dd").format(fromDate));
    queryParams.append('dateTo', new DateFormat("yyyy-MM-dd").format(toDate));

    final response = await httpClient.get(
      '$competitionsUrl?$queryParams',
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return MatchesResult.fromJson(results).matches;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }
}
