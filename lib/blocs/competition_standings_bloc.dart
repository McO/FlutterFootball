import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

//import 'package:flutter_football/models/football_data/models.dart' as FootballDataModels;
//import 'package:flutter_football/models/api_football/models.dart' as ApiFootballModels;
import 'package:flutter_football/repositories/repositories.dart';
import 'package:flutter_football/models/models.dart';

abstract class StandingsEvent extends Equatable {
  const StandingsEvent();
}

class FetchStandings extends StandingsEvent {
  final Competition competition;
  const FetchStandings({this.competition});

  @override
  List<Object> get props => [competition];
}

abstract class StandingsState extends Equatable {
  const StandingsState();

  @override
  List<Object> get props => [];
}

class StandingsUninitialized extends StandingsState {}

class StandingsEmpty extends StandingsState {}

class StandingsLoading extends StandingsState {}

class StandingsLoaded extends StandingsState {
  final List<Standings> standings;

  const StandingsLoaded({@required this.standings}) : assert(standings != null);

  @override
  List<Object> get props => [standings];
}

class StandingsError extends StandingsState {}

class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  StandingsBloc({@required this.footballDataRepository, @required this.apiFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null),
        super(StandingsUninitialized());

  @override
  Stream<StandingsState> mapEventToState(StandingsEvent event) async* {
    yield StandingsLoading();
    try {
      if (event is FetchStandings) {
        var allStandings = List<Standings>.empty(growable: true);
        final apiStandings = await apiFootballRepository.standings(event.competition.id, event.competition.year);

        apiStandings.standings.forEach((s) {
          var standings = Standings(positions: List<Position>.empty(growable: true));

          s.positions.forEach((element) {
            standings.description = element.group;
            standings.positions.add(Position(
                rank: element.rank,
                team: Team(id: element.team.id, name: element.team.name, logoUrl: element.team.logo),
                played: element.all.played,
                points: element.points,
                goalsFor: element.all.goals.goalsFor,
                goalsAgainst: element.all.goals.goalsAgainst,
                wins: element.all.win,
                draws: element.all.draw,
                losses: element.all.lose,
                description: element.description,
                form: element.form,
                status: getStatus(element.status)));
          });

          allStandings.add(standings);
        });

        if (allStandings.length == 0) {
          yield StandingsEmpty();
        } else {
          yield StandingsLoaded(standings: allStandings);
        }
      }
    } catch (e) {
      print(e);
      yield StandingsError();
    }
  }
}

Status getStatus(String status) {
  switch (status.toLowerCase()) {
    case 'up':
      return Status.Up;
      break;
    case 'down':
      return Status.Down;
      break;
    default:
      return Status.Same;
      break;
  }
}
