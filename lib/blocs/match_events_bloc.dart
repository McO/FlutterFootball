import 'dart:async';

import "package:collection/collection.dart";
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
        final apiPlayerStatistics = await apiFootballRepository.fixturePlayerStatistics(int.parse(event.match.matchId));

        final apiFixtureEvents = await apiFootballRepository.fixturesEvents(int.parse(event.match.matchId));
        var matchEvents = MatchEvents(matchId: event.match.matchId, events: List<MatchEvent>());

        var events = List<MatchEvent>();
        var currentScore = Score(home: 0, away: 0);
        for (var i = 0; i < apiFixtureEvents.length; i++) {
          var element = apiFixtureEvents[i];
          currentScore = calculateScore(element, currentScore, event.match);
          events.add(MatchEventFactory.createFrom(element, apiPlayerStatistics, currentScore));
        }

        var cardEventsByPlayers = groupBy(events.where((e) => e.type == EventType.Card), (e) => e.data.booked.id);
        cardEventsByPlayers.removeWhere((key, value) => value.length == 1);
        if (cardEventsByPlayers.length > 0) {
          // 2nd yellow card for at least one player
          cardEventsByPlayers.forEach((key, value) {
            removeSecondYellowCardEvent(events, key);
            changeRedCardToYellowRedCardEvent(events, key);
          });
        }

        matchEvents.events = List.from(events.reversed);

        if (matchEvents.events?.length == 0) {
          yield MatchEventsEmpty();
        } else {
          yield MatchEventsLoaded(events: matchEvents);
        }
      }
    } catch (e) {
      print('Exception: ' + e);
      yield MatchEventsError();
    }
  }

  void changeRedCardToYellowRedCardEvent(List<MatchEvent> events, key) {
    (events
            .firstWhere((element) =>
                element.type == EventType.Card &&
                (element.data as Card).booked.id == key &&
                (element.data as Card).type == CardType.Red)
            .data as Card)
        .type = CardType.YellowRed;
  }

  void removeSecondYellowCardEvent(List<MatchEvent> events, key) {
       var index = events.lastIndexWhere((element) =>
        element.type == EventType.Card &&
        (element.data as Card).booked.id == key &&
        (element.data as Card).type == CardType.Yellow);
    events.removeAt(index);
  }

  Score calculateScore(ApiFootballModels.FixtureEvent event, Score currentScore, Match match) {
    var newScore = new Score(home: currentScore.home, away: currentScore.away);
    if (event.type.toLowerCase() == 'goal' && event.detail.toLowerCase() != 'missed penalty') {
      var scoringTeamId = event.team.id;
      if (match.homeTeam.id == scoringTeamId) {
        newScore.home = currentScore.home + 1;
        newScore.away = currentScore.away;
      } else {
        newScore.home = currentScore.home;
        newScore.away = currentScore.away + 1;
      }
    }
    return newScore;
  }
}
