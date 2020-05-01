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
    final url = '${baseUrl}competitions/$competitionId';
    final response = await httpClient.get(
      url,
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
    final url = '${baseUrl}competitions';
    final response = await httpClient.get(
      url,
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
    URLQueryParams queryParams = new URLQueryParams();

    queryParams.append('dateFrom', new DateFormat("yyyy-MM-dd").format(fromDate));
    queryParams.append('dateTo', new DateFormat("yyyy-MM-dd").format(toDate));

    final url = '${baseUrl}matches?$queryParams';
    print('matches: $url');
    final response = await httpClient.get(
      url,
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return MatchesResult.fromJson(results).matches;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<Team>> teams(List<int> areaIds) async {
    URLQueryParams queryParams = new URLQueryParams();
    queryParams.append('areas', areaIds.map((i) => i.toString()).join(","));

    final url = '${baseUrl}teams?$queryParams';
    print('teams: $url');
    final response = await httpClient.get(
      url,
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return TeamsResult.fromJson(results).teams;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<Area>> areas() async {
    final url = '${baseUrl}areas';
    print('areas: $url');
    final response = await httpClient.get(
      url,
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AreasResult.fromJson(results).areas;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }
}
