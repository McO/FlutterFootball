import 'dart:convert';
import 'dart:async';

import 'package:FlutterFootball/data/api_dao.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:FlutterFootball/models/api_football/models.dart';
import 'package:query_params/query_params.dart';

class ApiFootballClient {
  static const baseUrl = "https://api-football-beta.p.rapidapi.com/";
  // static const baseUrl = "https://v3.football.api-sports.io/";
  final http.Client httpClient;
  final String authToken;
  final ApiDao apiDao;

  ApiFootballClient({@required this.httpClient, @required this.authToken, @required this.apiDao})
      : assert(httpClient != null),
        assert(authToken.isNotEmpty);

  Map<String, String> getHeaders() {
    var headers = Map<String, String>();
    headers['x-rapidapi-key'] = authToken;
    return headers;
  }

  Future<League> league(int leagueId) async {
    URLQueryParams queryParams = new URLQueryParams();
    queryParams.append('id', leagueId);

    final url = '${baseUrl}leagues?$queryParams';
    print('league: $url');

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.isNotEmpty) {
      print('leagues from cache');
      return LeaguesResponse.fromJson(json.decode(jsonString)).leagues[0];
    }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return LeaguesResponse.fromJson(responseBody).leagues[0];
    } else {
      throw ResultError.fromJson(responseBody).message;
    }
  }

  Future<List<League>> leagues(String countryCode) async {
    var queryParams = URLQueryParams();
    if (countryCode != null && countryCode.isNotEmpty) queryParams.append('code', countryCode);

    final url = '${baseUrl}leagues?$queryParams';
    print('leagues: $url');

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.isNotEmpty) {
      print('leagues from cache');
      return LeaguesResponse.fromJson(json.decode(jsonString)).leagues;
    }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return LeaguesResponse.fromJson(responseBody).leagues;
    } else {
      throw ResultError.fromJson(responseBody).message;
    }
  }

  Future<List<Fixture>> fixtures(DateTime date, DateTime fromDate, DateTime toDate, int leagueId, int season) async {
    var queryParams = URLQueryParams();

    // queryParams.append('to', new DateFormat("yyyy-MM-dd").format(toDate));
    // queryParams.append('from', new DateFormat("yyyy-MM-dd").format(fromDate));
    queryParams.append('date', new DateFormat("yyyy-MM-dd").format(date));
    if (leagueId != null && season != null) {
      queryParams.append('league', leagueId);
      queryParams.append('season', season);
    }

    final url = '${baseUrl}fixtures?$queryParams';
    print('fixtures: $url');

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.isNotEmpty) {
      print('fixtures from cache');
      return FixturesResult.fromJson(json.decode(jsonString)).fixtures;
    }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return FixturesResult.fromJson(results).fixtures;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<Team>> teams(List<int> areaIds) async {
    var queryParams = URLQueryParams();
    queryParams.append('areas', areaIds.map((i) => i.toString()).join(","));

    final url = '${baseUrl}teams?$queryParams';
    print('teams: $url');

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.toString().isNotEmpty) {
      print('teams from cache');
      return TeamsResult.fromJson(json.decode(jsonString.toString())).teams;
    }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return TeamsResult.fromJson(results).teams;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<Country>> countries() async {
    final url = '${baseUrl}countries';
    print('countries: $url');

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.isNotEmpty) {
      print('countries from cache');
      return CountriesResult.fromJson(json.decode(jsonString)).countries;
    }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return CountriesResult.fromJson(results).countries;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }
}
