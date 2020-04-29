import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/models/api/models.dart' as ApiModels;
import 'package:FlutterFootball/repositories/repositories.dart';
import 'package:FlutterFootball/data/dummy_football_repository.dart';
import 'package:FlutterFootball/models/models.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();
}

class FetchMatches extends MatchesEvent {
  const FetchMatches();

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

class MatchBloc extends Bloc<MatchesEvent, MatchesState> {
  final FootballDataRepository footballDataRepository;
  final DummyFootballRepository dummyFootballRepository;

  MatchBloc({@required this.footballDataRepository, this.dummyFootballRepository}) : assert(footballDataRepository != null);

  @override
  MatchesState get initialState => MatchesUninitialized();

  @override
  Stream<MatchesState> mapEventToState(MatchesEvent event) async* {
    yield MatchesLoading();
    try {
      final apiMatches = await footballDataRepository.matches(DateTime.now().subtract(Duration(days: 1)), DateTime.now());
      //TODO: map api matches to domain model
      var matches = new List<Match>();
//      apiMatches.forEach((c) => matches.add(new Match(id: c.id,name: c.name,logoUrl: c.area.ensignUrl)));
      var days = await dummyFootballRepository.fetchMatches();
      if (days.length == 0) {
        yield MatchesEmpty();
      } else {
        yield MatchesLoaded(days: days);
      }
    } catch (_) {
      yield MatchesError();
    }
  }
}
