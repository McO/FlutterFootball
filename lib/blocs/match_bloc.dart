import 'dart:async';

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/models/api/models.dart' as ApiModels;
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
      final List<ApiModels.Match> apiMatches = await footballDataRepository.matches(DateTime.now().subtract(Duration(days: 60)), DateTime.now().subtract(Duration(days: 55)));
      //TODO: map api matches to domain model
      List<Day> days = new List<Day>();
//      apiMatches.forEach((element) => print('Date: ${element.utcDate.toLocal().toString()}'));

      //adding match days
      apiMatches.forEach((ApiModels.Match m) {
        DateTime matchDateTime = m.utcDate.toLocal();
        DateTime matchDate = new DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);
        if (days.where((d) => d.date == matchDate).length == 0) {
          days.add(new Day(date: matchDate, dayCompetitionsMatches: new List<DayCompetitionMatches>()));
        }
      });

      //adding competitions to match days
      days.forEach((Day d) {
        var matcherPerDay = apiMatches.where((m) => m.utcDate.toLocal().isAfter(d.date) && m.utcDate.toLocal().isBefore(d.date.add(Duration(days: 1))));

        matcherPerDay.forEach((m) {
          if (d.dayCompetitionsMatches.where((d) => d.competition.id == m.competition.id).length == 0) {
            d.dayCompetitionsMatches.add(DayCompetitionMatches(date: d.date, competition: Competition(id: m.competition.id, name: m.competition.name), matchDayName: '', matches: List<Match>()));
          }
        });
      });

      //adding matches
      apiMatches.forEach((ApiModels.Match m) {
        DateTime matchDateTime = m.utcDate.toLocal();
        DateTime matchDate = new DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);

        Team homeTeam = new Team(id: m.homeTeam.id, name: m.homeTeam.name);
        Team awayTeam = new Team(id: m.awayTeam.id, name: m.awayTeam.name);
        Score score = new Score(home: m.score.fullTime.homeTeam, away: m.score.fullTime.awayTeam);
        Match match = new Match(homeTeam: homeTeam, awayTeam: awayTeam, score: score, time: DateFormat('HH:mm').format(matchDateTime));
        days.where((d) => d.date == matchDate).toList()[0].dayCompetitionsMatches.where((c) => c.competition.id == m.competition.id).toList()[0].matches.add(match);
      });

//      var matches = new List<Match>();
//      apiMatches.forEach((c) => matches.add(new Match(id: c.id,name: c.name,logoUrl: c.area.ensignUrl)));

//      days = await dummyFootballRepository.fetchMatches();
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
