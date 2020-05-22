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

abstract class MatchEventsEvent extends Equatable {
  const MatchEventsEvent();
}

class FetchMatchEvents extends MatchEventsEvent {
  final Match match;
  const FetchMatchEvents({this.match});

  @override
  List<Object> get props => [match];
}

abstract class MatchEventsState extends Equatable {
  const MatchEventsState();

  @override
  List<Object> get props => [];
}

class MatchEventsUninitialized extends MatchEventsState {}

class MatchEventsEmpty extends MatchEventsState {}

class MatchEventsLoading extends MatchEventsState {}

class MatchEventsLoaded extends MatchEventsState {
  final MatchEvents events;

  const MatchEventsLoaded({@required this.events}) : assert(events != null);

  @override
  List<Object> get props => [events];
}

class MatchEventsError extends MatchEventsState {}

class MatchEventsBloc extends Bloc<MatchEventsEvent, MatchEventsState> {
  final DummyFootballRepository dummyFootballRepository;
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  MatchEventsBloc(
      {@required this.footballDataRepository, @required this.apiFootballRepository, this.dummyFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null);

  @override
  MatchEventsState get initialState => MatchEventsUninitialized();

  @override
  Stream<MatchEventsState> mapEventToState(MatchEventsEvent event) async* {
    yield MatchEventsLoading();
    try {
      if (event is FetchMatchEvents) {
        final apiFixtureEvents = await apiFootballRepository.fixturesEvents(int.parse(event.match.matchId));
        var events = MatchEvents(matchId: event.match.matchId, events: List<MatchEvent>());

        apiFixtureEvents.sort((b, a) => a.time.elapsed.compareTo(b.time.elapsed));
        apiFixtureEvents.forEach((element) {
          events.events.add(MatchEvent(
            minute: element.time.elapsed,
            text: '${element.comments} ${element.detail} ${element.type}'));
        });

        if (events.events?.length == 0) {
          yield MatchEventsEmpty();
        } else {
          yield MatchEventsLoaded(events: events);
        }
      }
    } catch (e) {
      print('Exception: ' + e);
      yield MatchEventsError();
    }
  }
}
