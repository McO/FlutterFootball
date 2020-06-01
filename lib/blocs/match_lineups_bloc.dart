import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/models/football_data/models.dart' as FootballDataModels;
import 'package:FlutterFootball/models/api_football/models.dart' as ApiFootballModels;
import 'package:FlutterFootball/repositories/repositories.dart';
import 'package:FlutterFootball/repositories/dummy_football_repository.dart';
import 'package:FlutterFootball/models/models.dart';

abstract class MatchLineupsEvent extends Equatable {
  const MatchLineupsEvent();
}

class FetchMatchLineups extends MatchLineupsEvent {
  final Match match;
  const FetchMatchLineups({this.match});

  @override
  List<Object> get props => [match];
}

abstract class MatchLineupsState extends Equatable {
  const MatchLineupsState();

  @override
  List<Object> get props => [];
}

class MatchLineupsUninitialized extends MatchLineupsState {}

class MatchLineupsEmpty extends MatchLineupsState {}

class MatchLineupsLoading extends MatchLineupsState {}

class MatchLineupsLoaded extends MatchLineupsState {
  final MatchLineups lineups;

  const MatchLineupsLoaded({@required this.lineups}) : assert(lineups != null);

  @override
  List<Object> get props => [lineups];
}

class MatchLineupsError extends MatchLineupsState {}

class MatchLineupsBloc extends Bloc<MatchLineupsEvent, MatchLineupsState> {
  final DummyFootballRepository dummyFootballRepository;
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  MatchLineupsBloc(
      {@required this.footballDataRepository, @required this.apiFootballRepository, this.dummyFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null);

  @override
  MatchLineupsState get initialState => MatchLineupsUninitialized();

  @override
  Stream<MatchLineupsState> mapEventToState(MatchLineupsEvent event) async* {
    yield MatchLineupsLoading();
    try {
      if (event is FetchMatchLineups) {
        final apiLineups = await apiFootballRepository.fixturesLineups(int.parse(event.match.matchId));
        if (apiLineups == null || apiLineups.length == 0) yield MatchLineupsEmpty();

        var home = getTeamLineup(apiLineups[0]);
        var away = getTeamLineup(apiLineups[1]);
        var lineups = MatchLineups(matchId: event.match.matchId, home: home, away: away);

        yield MatchLineupsLoaded(lineups: lineups);
      }
    } catch (e) {
      print('Exception: ' + e);
      yield MatchLineupsError();
    }
  }

  Lineup getTeamLineup(ApiFootballModels.Lineup apiLineup) {
    var teamLineup = Lineup(
        team: Team(
            id: apiLineup.team.id,
            name: apiLineup.team.name,
            shortName: apiLineup.team.name,
            logoUrl: apiLineup.team.logo));

    var startingPlayers = List<Player>();
    apiLineup.startXI.forEach((p) {
      startingPlayers.add(Player(
          id: p.player.id,
          name: p.player.name,
          pictureUrl: p.player.photo,
          position: p.player.pos,
          number: p.player.number));
    });
    teamLineup.startingPlayers = startingPlayers;
    var benchPlayers = List<Player>();
    apiLineup.substitutes.forEach((p) {
      benchPlayers.add(Player(
          id: p.player.id,
          name: p.player.name,
          pictureUrl: p.player.photo,
          position: p.player.pos,
          number: p.player.number));
    });
    teamLineup.benchPlayers = benchPlayers;
    teamLineup.formation = apiLineup.formation;
    return teamLineup;
  }
}
