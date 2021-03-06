import 'dart:convert';
import 'dart:async';

import 'package:flutter_football/data/api_dao.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_football/models/football_data/models.dart';
import 'package:query_params/query_params.dart';

class FootballDataClient {
  static const baseUrl = "https://api.football-data.org/v2/";
  final http.Client httpClient;
  final String authToken;
  final ApiDao apiDao;

  FootballDataClient({@required this.httpClient, @required this.authToken, @required this.apiDao})
      : assert(httpClient != null);

  Future<Competition> competition(int competitionId) async {
    final url = '${baseUrl}competitions/$competitionId';
    final response = await httpClient.get(
      Uri.parse(url),
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
      Uri.parse(url),
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
      Uri.parse(url),
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

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.toString().isNotEmpty) {
      print('teams from cache');
      return TeamsResult.fromJson(json.decode(jsonString.toString())).teams;
    }

    final response = await httpClient.get(
      Uri.parse(url),
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return TeamsResult.fromJson(results).teams;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<Area>> areas() async {
    final url = '${baseUrl}areas';
    print('areas: $url');

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.isNotEmpty) {
      print('areas from cache');
      return AreasResult.fromJson(json.decode(jsonString)).areas;
    }

    final response = await httpClient.get(
      Uri.parse(url),
      headers: {'X-Auth-Token': authToken},
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return AreasResult.fromJson(results).areas;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }
}
