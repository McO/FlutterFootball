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

  Future<List<League>> leagues(String countryCode) async {
    var queryParams = URLQueryParams();
    if (countryCode != null && countryCode.isNotEmpty) queryParams.append('code', countryCode);

    final url = '${baseUrl}leagues?$queryParams';
    print('leagues: $url');

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('leagues from cache');
    //   return LeaguesResponse.fromJson(json.decode(jsonString)).leagues;
    // }

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

  Future<List<Fixture>> fixtures(
      DateTime date, DateTime fromDate, DateTime toDate, int leagueId, int season) async {
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

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('fixtures from cache');
    //   return FixturesResult.fromJson(json.decode(jsonString)).fixtures;
    // }

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

  Future<List<Fixture>> liveFixtures() async {
    var queryParams = URLQueryParams();
    queryParams.append('live', 'all');

    final url = '${baseUrl}fixtures?$queryParams';
    print('live fixtures: $url');

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('fixtures from cache');
    //   return FixturesResult.fromJson(json.decode(jsonString)).fixtures;
    // }

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

  Future<List<FixtureStatistics>> fixtureStatistics(int fixtureId) async {
    var queryParams = URLQueryParams();
    queryParams.append('fixture', fixtureId);

    final url = '${baseUrl}fixtures/statistics?$queryParams';
    print('fixture statistics: $url');

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('fixtures from cache');
    //   return FixturesResult.fromJson(json.decode(jsonString)).fixtures;
    // }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return FixtureStatisticsResult.fromJson(results).fixtureStatistics;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<FixturePlayersStatistics>> fixturePlayerStatistics(int fixtureId) async {
    var queryParams = URLQueryParams();
    queryParams.append('fixture', fixtureId);

    final url = '${baseUrl}fixtures/players?$queryParams';
    print('fixture statistics: $url');

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('fixtures from cache');
    //   return FixturesResult.fromJson(json.decode(jsonString)).fixtures;
    // }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return FixturePlayerStatisticsResult.fromJson(results).fixturePlayersStatistics;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<FixtureEvent>> fixtureEvents(int fixtureId) async {
    var queryParams = URLQueryParams();
    queryParams.append('fixture', fixtureId);

    final url = '${baseUrl}fixtures/events?$queryParams';
    print('fixture events: $url');

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('fixtures from cache');
    //   return FixturesResult.fromJson(json.decode(jsonString)).fixtures;
    // }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return FixtureEventsResult.fromJson(results).fixtureEvents;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<List<Lineup>> fixtureLineups(int fixtureId) async {
    var queryParams = URLQueryParams();
    queryParams.append('fixture', fixtureId);

    final url = '${baseUrl}fixtures/lineups?$queryParams';
    print('fixture lineups: $url');

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('lineups from cache');
    //   return FixtureLineupsResult.fromJson(json.decode(jsonString)).lineups;
    // }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return FixtureLineupsResult.fromJson(results).lineups;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }

  Future<StandingsLeague> standings(int leagueId, int season) async {
    var queryParams = URLQueryParams();
    queryParams.append('league', leagueId);
    queryParams.append('season', season);

    final url = '${baseUrl}standings?$queryParams';
    print('standings: $url');

    // var jsonString = await apiDao.get(url);
    // if (jsonString != null && jsonString.isNotEmpty) {
    //   print('fixtures from cache');
    //   return FixturesResult.fromJson(json.decode(jsonString)).fixtures;
    // }

    final response = await httpClient.get(
      url,
      headers: getHeaders(),
    );
    final results = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await apiDao.insert(url, response.body);
      return StandingsResponse.fromJson(results).leagues[0].league;
    } else {
      throw ResultError.fromJson(results).message;
    }
  }
}