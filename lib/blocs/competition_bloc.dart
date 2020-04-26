import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/repositories/repositories.dart';
import 'package:FlutterFootball/models/models.dart';

abstract class CompetitionsEvent extends Equatable {
  const CompetitionsEvent();
}

class FetchCompetitions extends CompetitionsEvent {

  const FetchCompetitions();

  @override
  List<Object> get props => [];
}

class RefreshCompetitions extends CompetitionsEvent {

  const RefreshCompetitions();

  @override
  List<Object> get props => [];
}

abstract class CompetitionsState extends Equatable {
  const CompetitionsState();

  @override
  List<Object> get props => [];
}

class CompetitionsUninitialized extends CompetitionsState {}

class CompetitionsEmpty extends CompetitionsState {}

class CompetitionsLoading extends CompetitionsState {}

class CompetitionsLoaded extends CompetitionsState {
  final List<CompetitionBase> competitions;

  const CompetitionsLoaded({@required this.competitions}) : assert(competitions != null);

  @override
  List<Object> get props => [competitions];
}

class CompetitionsError extends CompetitionsState {}

class CompetitionBloc extends Bloc<CompetitionsEvent, CompetitionsState> {
  final FootballDataRepository footballDataRepository;

  CompetitionBloc({@required this.footballDataRepository})
      : assert(footballDataRepository != null);

  @override
  CompetitionsState get initialState => CompetitionsUninitialized();

  @override
  Stream<CompetitionsState> mapEventToState(CompetitionsEvent event) async* {
    yield CompetitionsLoading();
    try {
      final List<CompetitionBase> competitions = await footballDataRepository.competitions();
      if (competitions.length == 0) {
        yield CompetitionsEmpty();
      } else {
        yield CompetitionsLoaded(competitions: competitions);
      }
    } catch (_) {
      yield CompetitionsError();
    }

//    if (event is FetchCompetitions) {
//      yield* _mapFetchCompetitionsToState(event);
//    } else if (event is RefreshCompetitions) {
//      yield* _mapRefreshCompetitionsToState(event);
//    }
  }

//  Stream<CompetitionsState> _mapFetchCompetitionsToState(FetchCompetitions event) async* {
//    yield CompetitionsLoading();
//    try {
//      final List<CompetitionBase> competitions = await footballDataRepository.competitions();
//      if (competitions.length == 0) {
//        yield CompetitionsEmpty();
//      } else {
//        yield CompetitionsLoaded(competitions: competitions);
//      }
//    } catch (_) {
//      yield CompetitionsError();
//    }
//  }
//
//  Stream<CompetitionsState> _mapRefreshCompetitionsToState(RefreshCompetitions event) async* {
//    yield CompetitionsLoading();
//    try {
//      final List<CompetitionBase> competitions = await footballDataRepository.competitions();
//      if (competitions.length == 0) {
//        yield CompetitionsEmpty();
//      } else {
//        yield CompetitionsLoaded(competitions: competitions);
//      }
//    } catch (_) {
//      yield state;
//    }
//  }
}