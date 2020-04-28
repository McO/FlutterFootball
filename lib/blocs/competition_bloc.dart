import 'dart:async';

import 'package:FlutterFootball/models/api/competition.dart';
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
      final List<Competition> apiCompetitions = await footballDataRepository.competitions();
      List<CompetitionBase> competitions = new List<CompetitionBase>();
      apiCompetitions.forEach((c) => competitions.add(new CompetitionBase(id: c.id,name: c.name,logoUrl: c.area.ensignUrl)));
      if (competitions.length == 0) {
        yield CompetitionsEmpty();
      } else {
        yield CompetitionsLoaded(competitions: competitions);
      }
    } catch (_) {
      yield CompetitionsError();
    }
  }
}