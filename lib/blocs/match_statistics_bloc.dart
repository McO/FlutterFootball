import 'package:flutter/material.dart';

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/models/football_data/models.dart' as FootballDataModels;
import 'package:FlutterFootball/models/api_football/models.dart' as ApiFootballModels;
import 'package:FlutterFootball/repositories/repositories.dart';
import 'package:FlutterFootball/repositories/dummy_football_repository.dart';
import 'package:FlutterFootball/models/models.dart';

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
      : assert(footballDataRepository != null, apiFootballRepository != null);

  @override
  MatchStatisticsState get initialState => MatchStatisticsUninitialized();

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
            details: List<MatchStatisticDetail>());
        if (apiFixtureStatistics.length == 2) {
          var homeStatistics =
              apiFixtureStatistics.firstWhere((element) => element.team.id == event.match.homeTeam.id).statistics;
          homeStatistics.forEach((statisticsItem) {
            statistics.details.add(MatchStatisticDetail(name: statisticsItem.type, home: statisticsItem.value));
          });

          var awayStatistics =
              apiFixtureStatistics.firstWhere((element) => element.team.id == event.match.awayTeam.id).statistics;
          awayStatistics.forEach((statisticsItem) {
            statistics.details.firstWhere((element) => element.name == statisticsItem.type).away = statisticsItem.value;
          });
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
}
