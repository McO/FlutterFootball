import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/models/football_data/models.dart' as FootballDataModels;
import 'package:FlutterFootball/models/api_football/models.dart' as ApiFootballModels;
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

class SearchCompetitions extends CompetitionsEvent {
  final String searchString;
  const SearchCompetitions(this.searchString);

  @override
  List<Object> get props => [searchString];
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
  final List<Competition> competitions;

  const CompetitionsLoaded({@required this.competitions}) : assert(competitions != null);

  @override
  List<Object> get props => [competitions];
}

class CompetitionsError extends CompetitionsState {}

class CompetitionsBloc extends Bloc<CompetitionsEvent, CompetitionsState> {
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  CompetitionsBloc({@required this.footballDataRepository, @required this.apiFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null),
        super(CompetitionsUninitialized());

  @override
  Stream<CompetitionsState> mapEventToState(CompetitionsEvent event) async* {
    yield CompetitionsLoading();
    try {
      var competitions = new List<Competition>.empty(growable: true);
      var useApiFootball = true;
      if (useApiFootball) {
        final List<ApiFootballModels.League> apiLeagues = await apiFootballRepository.leagues();
        apiLeagues.forEach((c) => competitions
            .add(Competition(id: c.league.id, name: c.league.name, logoUrl: c.league.logo, country: c.country.name)));
      } else {
        final List<FootballDataModels.Competition> apiCompetitions = await footballDataRepository.competitions();

        apiCompetitions
            .forEach((c) => competitions.add(Competition(id: c.id, name: c.name, logoUrl: c.area.ensignUrl)));
      }

      try {
        if (event is SearchCompetitions) {
          final String searchString = event.searchString.toLowerCase();
          competitions = competitions
              .where((competition) =>
                  competition.name.toLowerCase().contains(searchString) ||
                  (competition.country ?? '').toLowerCase().contains(searchString))
              .toList();
        }
      } catch (exception) {
        print(exception);
      }

      competitions.sort((a, b) => (a.country ?? '').compareTo(b.country ?? ''));

      if (competitions.length == 0) {
        yield CompetitionsEmpty();
      } else {
        yield CompetitionsLoaded(competitions: competitions);
      }
    } catch (e) {
      print(e);
      yield CompetitionsError();
    }
  }
}
