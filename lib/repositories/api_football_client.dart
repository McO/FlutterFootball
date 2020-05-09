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
  final http.Client httpClient;
  final String authToken;
  final ApiDao apiDao;

  ApiFootballClient(
      {@required this.httpClient,
      @required this.authToken,
      @required this.apiDao})
      : assert(httpClient != null),assert(authToken.isNotEmpty);

  Future<League> league(int leagueId) async {
    final url = '${baseUrl}leagues/$leagueId';
    final response = await httpClient.get(
      url,
      headers: {'x-rapidapi-key': authToken},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final leagueJson = jsonDecode(response.body);
      return League.fromJson(leagueJson);
    } else {
      throw ResultError.fromJson(response).message;
    }
  }

  Future<List<League>> leagues(String countryCode) async {
    URLQueryParams queryParams = new URLQueryParams();

    queryParams.append('country', countryCode);
    // queryParams.append('dateTo', new DateFormat("yyyy-MM-dd").format(toDate));

    final url = '${baseUrl}leagues';
    print('leagues: $url');

    var jsonString = await apiDao.get(url);
    if (jsonString != null && jsonString.isNotEmpty) {
      print('leagues from cache');
      return LeaguesResponse.fromJson(json.decode(jsonString)).leagues;
    }

    final response = await httpClient.get(
      url,
      headers: {'x-rapidapi-key': authToken},
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return LeaguesResponse.fromJson(responseBody).leagues;
    } else {
      throw ResultError.fromJson(responseBody).message;
    }
  }

  Future<List<Match>> matches(DateTime fromDate, DateTime toDate) async {
    URLQueryParams queryParams = new URLQueryParams();

    queryParams.append(
        'dateFrom', new DateFormat("yyyy-MM-dd").format(fromDate));
    queryParams.append('dateTo', new DateFormat("yyyy-MM-dd").format(toDate));

    final url = '${baseUrl}matches?$queryParams';
    print('matches: $url');

    final response = await httpClient.get(
      url,
      headers: {'x-rapidapi-key': authToken},
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
      url,
      headers: {'x-rapidapi-key': authToken},
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
      headers: {'x-rapidapi-key': authToken},
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
