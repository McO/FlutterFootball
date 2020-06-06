import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/classes/api_football.dart';
import 'package:FlutterFootball/repositories/repositories.dart';
import 'package:FlutterFootball/models/models.dart';

abstract class CompetitionRoundEvent extends Equatable {
  const CompetitionRoundEvent();
}

class FetchCompetitionRound extends CompetitionRoundEvent {
  final Competition competition;
  final String round;
  const FetchCompetitionRound(this.competition, this.round);

  @override
  List<Object> get props => [this.competition, this.round];
}

abstract class CompetitionRoundState extends Equatable {
  const CompetitionRoundState();

  @override
  List<Object> get props => [];
}

class CompetitionRoundUninitialized extends CompetitionRoundState {}

class CompetitionRoundEmpty extends CompetitionRoundState {}

class CompetitionRoundLoading extends CompetitionRoundState {}

class CompetitionRoundLoaded extends CompetitionRoundState {
  final List<Day> days;
  // final List<Match> matches;
  final List<Round> rounds;

  const CompetitionRoundLoaded({@required this.days, this.rounds}) : assert(days != null);

  @override
  List<Object> get props => [days, rounds];
}

class CompetitionRoundError extends CompetitionRoundState {}

class CompetitionRoundBloc extends Bloc<CompetitionRoundEvent, CompetitionRoundState> {
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  CompetitionRoundBloc({@required this.footballDataRepository, @required this.apiFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null);

  @override
  CompetitionRoundState get initialState => CompetitionRoundUninitialized();

  @override
  Stream<CompetitionRoundState> mapEventToState(CompetitionRoundEvent event) async* {
    yield CompetitionRoundLoading();
    try {
      var rounds = List<Round>();
      // var matches = List<Match>();
      var days = List<Day>();

      if (event is FetchCompetitionRound) {
        var round = event.round;
        var competitionId = event.competition.id;
        var year = event.competition.year;
        if (round == null) round = await apiFootballRepository.currentRound(competitionId, year);

        var apiRounds = await apiFootballRepository.rounds(competitionId, year);
        apiRounds.forEach((element) {
          rounds.add(Round(name: element, current: element == round));
        });

        var apiMatches = await apiFootballRepository.roundFixtures(competitionId, year, round);
        apiMatches.sort((a, b) => a.details.date.compareTo(b.details.date));


        var apiFootball = ApiFootball(apiFootballRepository);
        days = apiFootball.getDays(apiMatches, null).toList();

        if (rounds.length == 0) {
          yield CompetitionRoundEmpty();
        } else {
          yield CompetitionRoundLoaded(days: days, rounds: rounds);
        }
      }
    } catch (e) {
      print(e);
      yield CompetitionRoundError();
    }
  }
}
