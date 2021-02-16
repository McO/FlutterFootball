import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/classes/api_football.dart';
import 'package:FlutterFootball/classes/football_data.dart';

import 'package:FlutterFootball/repositories/repositories.dart';
import 'package:FlutterFootball/repositories/dummy_football_repository.dart';
import 'package:FlutterFootball/models/models.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();
}

class FetchMatches extends MatchesEvent {
  const FetchMatches();

  @override
  List<Object> get props => [];
}

class FetchLiveMatches extends MatchesEvent {
  const FetchLiveMatches();

  @override
  List<Object> get props => [];
}

class FetchFavouriteMatches extends MatchesEvent {
  final List<String> favouriteCompetitions;
  const FetchFavouriteMatches(this.favouriteCompetitions);

  @override
  List<Object> get props => [];
}

class RefreshMatches extends MatchesEvent {
  const RefreshMatches();

  @override
  List<Object> get props => [];
}

abstract class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

class MatchesUninitialized extends MatchesState {}

class MatchesEmpty extends MatchesState {}

class MatchesLoading extends MatchesState {}

class MatchesLoaded extends MatchesState {
  final List<Day> days;

  const MatchesLoaded({@required this.days}) : assert(days != null);

  @override
  List<Object> get props => [days];
}

class MatchesError extends MatchesState {}

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final DummyFootballRepository dummyFootballRepository;
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  MatchesBloc(
      {@required this.footballDataRepository, @required this.apiFootballRepository, this.dummyFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null),
        super(MatchesUninitialized());

  @override
  Stream<MatchesState> mapEventToState(MatchesEvent event) async* {
    yield MatchesLoading();
    try {
      List<String> favouriteCompetitions;
      bool showLiveMatches = false;
      if (event is FetchFavouriteMatches) {
        favouriteCompetitions = event.favouriteCompetitions;
      }

      if (event is FetchLiveMatches) {
        showLiveMatches = true;
      }

      var days = List<Day>.empty(growable: true);

      var useApiFootball = true;
      if (useApiFootball) {
        var apiFootball = ApiFootball(apiFootballRepository);
        days = await apiFootball.handleApiFootball(favouriteCompetitions, showLiveMatches);
      } else {
        var footballData = FootballData(footballDataRepository);
        await footballData.handleFootballData(days);
      }

//      days = await dummyFootballRepository.fetchMatches();

      if (days.length == 0) {
        yield MatchesEmpty();
      } else {
        yield MatchesLoaded(days: days);
      }
    } catch (e) {
      print('Exception: ' + e);
      yield MatchesError();
    }
  }
}
