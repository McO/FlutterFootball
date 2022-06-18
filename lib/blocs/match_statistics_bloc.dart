import 'package:flutter/material.dart';

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

//import 'package:flutter_football/models/football_data/models.dart' as FootballDataModels;
import 'package:flutter_football/models/api_football/models.dart' as ApiFootballModels;
import 'package:flutter_football/repositories/repositories.dart';
//import 'package:flutter_football/repositories/dummy_football_repository.dart';
import 'package:flutter_football/models/models.dart';

abstract class MatchStatisticsEvent extends Equatable {
  const MatchStatisticsEvent();
}

class FetchMatchStatistics extends MatchStatisticsEvent {
  final Match match;
  const FetchMatchStatistics({this.match});

  @override
  List<Object> get props => [match];
}

abstract class MatchStatisticsState extends Equatable {
  const MatchStatisticsState();

  @override
  List<Object> get props => [];
}

class MatchStatisticsUninitialized extends MatchStatisticsState {}

class MatchStatisticsEmpty extends MatchStatisticsState {}

class MatchStatisticsLoading extends MatchStatisticsState {}

class MatchStatisticsLoaded extends MatchStatisticsState {
  final MatchStatistics statistics;

  const MatchStatisticsLoaded({@required this.statistics}) : assert(statistics != null);

  @override
  List<Object> get props => [statistics];
}

class MatchStatisticsError extends MatchStatisticsState {}

class MatchStatisticsBloc extends Bloc<MatchStatisticsEvent, MatchStatisticsState> {
  final DummyFootballRepository dummyFootballRepository;
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  MatchStatisticsBloc(
      {@required this.footballDataRepository, @required this.apiFootballRepository, this.dummyFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null),
        super(MatchStatisticsUninitialized());

  @override
  Stream<MatchStatisticsState> mapEventToState(MatchStatisticsEvent event) async* {
    yield MatchStatisticsLoading();
    try {
      if (event is FetchMatchStatistics) {
        final apiFixtureStatistics = await apiFootballRepository.fixturesStatistics(int.parse(event.match.matchId));
        var statistics = MatchStatistics(
            matchId: event.match.matchId,
            homeTeam: event.match.homeTeam,
            awayTeam: event.match.awayTeam,
            details: List<MatchStatisticDetail>.empty(growable: true));
        if (apiFixtureStatistics.length == 2) {
          statistics.details = getStatistics(apiFixtureStatistics, event.match.homeTeam.id, event.match.awayTeam.id);
        }

        if (statistics.details?.length == 0) {
          yield MatchStatisticsEmpty();
        } else {
          yield MatchStatisticsLoaded(statistics: statistics);
        }
      }
    } catch (e) {
      print('Exception: ' + e);
      yield MatchStatisticsError();
    }
  }

  List<MatchStatisticDetail> getStatistics(
      List<ApiFootballModels.FixtureStatistics> apiFixtureStatistics, int homeTeamId, int awayTeamId) {
    var statistics = List<MatchStatisticDetail>.empty(growable: true);
    var homeStatistics = apiFixtureStatistics.firstWhere((element) => element.team.id == homeTeamId).statistics;
    var awayStatistics = apiFixtureStatistics.firstWhere((element) => element.team.id == awayTeamId).statistics;

    var key = "Total Shots";

    // General
    key = "Ball Possession";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.General,
        home: getIntFromPercentage(homeStatistics, key),
        away: getIntFromPercentage(awayStatistics, key),
        isPercentage: true));

    key = "Corner Kicks";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.General,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Offsides";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.General,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    //Offense
    key = "Total Shots";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Offense,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Shots on Goal";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Offense,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Shots off Goal";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Offense,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Blocked Shots";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Offense,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Shots insidebox";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Offense,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Shots outsidebox";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Offense,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Goalkeeper Saves";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Offense,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    //Distribution
    key = "Total passes";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Distribution,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Passes accurate";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Discipline,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Passes %";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Discipline,
        home: getIntFromPercentage(homeStatistics, key),
        away: getIntFromPercentage(awayStatistics, key),
        isPercentage: true));

    //Discipline
    key = "Fouls";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Discipline,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Yellow Cards";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Discipline,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    key = "Red Cards";
    statistics.add(MatchStatisticDetail(
        name: key,
        category: StatisticsCategory.Discipline,
        home: getInt(homeStatistics, key),
        away: getInt(awayStatistics, key),
        isPercentage: false));

    return statistics;
  }

  int getInt(List<ApiFootballModels.StatisticDetail> statistics, String key) {
    return int.tryParse(statistics.firstWhere((element) => element.type == key).value) ?? 0;
  }

  int getIntFromPercentage(List<ApiFootballModels.StatisticDetail> statistics, String key) {
    return int.tryParse(statistics.firstWhere((element) => element.type == key).value.replaceAll('%', '')) ?? 0;
  }
}
