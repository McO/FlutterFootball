import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:FlutterFootball/models/football_data/models.dart' as FootballDataModels;
import 'package:FlutterFootball/models/api_football/models.dart' as ApiFootballModels;
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

class FetchLiveMatches extends MatchesEvent {
  const FetchLiveMatches();

  @override
  List<Object> get props => [];
}

class FetchFavouriteMatches extends MatchesEvent {
  final List<String> favouriteCompetitions;
  const FetchFavouriteMatches(this.favouriteCompetitions);

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

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final DummyFootballRepository dummyFootballRepository;
  final FootballDataRepository footballDataRepository;
  final ApiFootballRepository apiFootballRepository;

  MatchesBloc(
      {@required this.footballDataRepository, @required this.apiFootballRepository, this.dummyFootballRepository})
      : assert(footballDataRepository != null, apiFootballRepository != null);

  @override
  MatchesState get initialState => MatchesUninitialized();

  @override
  Stream<MatchesState> mapEventToState(MatchesEvent event) async* {
    yield MatchesLoading();
    try {
      List<String> favouriteCompetitions;
      bool showLiveMatches = false;
      if (event is FetchFavouriteMatches) {
        favouriteCompetitions = event.favouriteCompetitions;
      }

      if (event is FetchLiveMatches) {
        showLiveMatches = true;
      }

      var days = List<Day>();

      var useApiFootball = true;
      if (useApiFootball) {
        await handleApiFootball(days, favouriteCompetitions, showLiveMatches);
      } else {
        await handleFootballData(days);
      }

//      days = await dummyFootballRepository.fetchMatches();

      if (days.length == 0) {
        yield MatchesEmpty();
      } else {
        yield MatchesLoaded(days: days);
      }
    } catch (e) {
      print('Exception: ' + e);
      yield MatchesError();
    }
  }

  Future handleFootballData(List<Day> days) async {
    final List<FootballDataModels.Match> apiMatches = await footballDataRepository.matches(
        DateTime.now().subtract(Duration(days: 0)), DateTime.now().add(Duration(days: 7)));
    //todo: parametrize date range (maximum 10 days)

    final List<FootballDataModels.Area> apiAreas = await footballDataRepository.areas();
    var areaIds = new List<int>();
    //      apiMatches.forEach((element) => print('Date: ${element.utcDate.toLocal().toString()}'));

    //adding match days
    apiMatches.forEach((FootballDataModels.Match m) {
      DateTime matchDateTime = m.utcDate.toLocal();
      DateTime matchDate = new DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);
      if (days.where((d) => d.date == matchDate).length == 0) {
        days.add(new Day(date: matchDate, dayCompetitionsMatches: new List<DayCompetitionMatches>()));
      }

      var countryCode = m.competition.area.countryCode;
      var areaId = apiAreas.firstWhere((a) => a.countryCode == countryCode).id;
      if (!areaIds.contains(areaId)) {
        areaIds.add(areaId);
      }
    });

    //adding competitions to match days
    days.forEach((Day d) {
      var matcherPerDay = apiMatches.where(
          (m) => m.utcDate.toLocal().isAfter(d.date) && m.utcDate.toLocal().isBefore(d.date.add(Duration(days: 1))));

      matcherPerDay.forEach((m) {
        if (d.dayCompetitionsMatches.where((d) => d.competition.id == m.competition.id).length == 0) {
          d.dayCompetitionsMatches.add(DayCompetitionMatches(
              date: d.date,
              competition:
                  Competition(id: m.competition.id, name: m.competition.name, logoUrl: m.competition.area.ensignUrl),
              matchDayName: getMatchDay(m),
              matches: List<Match>()));
        }
      });
    });

    final List<FootballDataModels.Team> apiTeams = await footballDataRepository.teams(areaIds);

    //adding matches
    apiMatches.forEach((FootballDataModels.Match m) {
      try {
        var matchDateTime = m.utcDate.toLocal();
        var matchDate = DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);

        var homeTeam = Team(
            id: m.homeTeam.id,
            name: m.homeTeam.name,
            shortName: apiTeams.firstWhere((t) => t.id == m.homeTeam.id).shortName,
            logoUrl: getLogoUrl(apiTeams, m.homeTeam.id));
        var awayTeam = Team(
            id: m.awayTeam.id,
            name: m.awayTeam.name,
            shortName: apiTeams.firstWhere((t) => t.id == m.awayTeam.id).shortName,
            logoUrl: getLogoUrl(apiTeams, m.awayTeam.id));

        var score = Score(home: m.score.fullTime.homeTeam, away: m.score.fullTime.awayTeam);
        var match = Match(
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          score: score,
          time: DateFormat('HH:mm').format(matchDateTime),
          status: MatchStatus.values.firstWhere((e) => e.toString().toUpperCase() == 'MATCHSTATUS.' + m.status),
        );
        days
            .where((d) => d.date == matchDate)
            .toList()[0]
            .dayCompetitionsMatches
            .where((c) => c.competition.id == m.competition.id)
            .toList()[0]
            .matches
            .add(match);
      } catch (e) {
        print(e);
        print('Match: ${m.id}');
      }
    });
  }

  Future handleApiFootball(List<Day> days, List<String> favouriteCompetitions, bool showLiveMatches) async {
    var apiFixtures = List<ApiFootballModels.Fixture>();

    if (showLiveMatches) {
      apiFixtures = await apiFootballRepository.liveFixtures();
    } else if (favouriteCompetitions != null && favouriteCompetitions.length > 0) {
      await Future.forEach(favouriteCompetitions, (competition) async {
        //TODO: hard coded season
        var apiCompetitionFixtures = await apiFootballRepository.fixtures(DateTime.now().add(Duration(days: 0)),
            fromDate: null, toDate: null, leagueId: int.parse(competition), season: 2019);
        apiFixtures.addAll(apiCompetitionFixtures);
      });
    } else {
      var tempApiFixtures = await apiFootballRepository.fixtures(DateTime.now().add(Duration(days: 0)),
          fromDate: DateTime.now().subtract(Duration(days: 0)),
          toDate: DateTime.now().add(Duration(days: 7)),
          leagueId: null,
          season: null);
      //TODO hard coded limit
      apiFixtures = tempApiFixtures.toList().take(50).toList();
    }

    print(apiFixtures.length);

    //adding match days
    apiFixtures.forEach((ApiFootballModels.Fixture f) {
      var matchDateTime = f.details.date.toLocal();
      var matchDate = DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);
      if (days.where((d) => d.date == matchDate).length == 0) {
        days.add(Day(date: matchDate, dayCompetitionsMatches: List<DayCompetitionMatches>()));
      }
    });

    //adding competitions to match days
    days.forEach((Day day) {
      var matchesPerDay = apiFixtures.where((f) =>
          f.details.date.difference(day.date).inSeconds == 0 ||
          (f.details.date.isAfter(day.date) &&
              f.details.date.isBefore(day.date.add(Duration(days: 1)).subtract(Duration(seconds: 1)))));

      matchesPerDay.forEach((m) {
        if (day.dayCompetitionsMatches.where((d) => d.competition.id == m.league.id).length == 0) {
          day.dayCompetitionsMatches.add(DayCompetitionMatches(
              date: day.date,
              competition: Competition(id: m.league.id, name: m.league.name, logoUrl: m.league.logo),
              matchDayName: m.league.round,
              matches: List<Match>()));
        }
      });
    });

    //adding matches
    apiFixtures.forEach((ApiFootballModels.Fixture f) {
      try {
        var matchDateTime = f.details.date.toLocal();
        var matchDate = DateTime(matchDateTime.year, matchDateTime.month, matchDateTime.day);

        var match = getMatch(f, matchDateTime);
        days
            .firstWhere((d) => d.date == matchDate)
            .dayCompetitionsMatches
            .firstWhere((c) => c.competition.id == f.league.id)
            .matches
            .add(match);
      } catch (e) {
        print(e);
        print('Fixture: ${f.details.id}');
      }
    });
  }

  Match getMatch(ApiFootballModels.Fixture f, DateTime matchDateTime) {
    var homeTeam =
        Team(id: f.teams.home.id, name: f.teams.home.name, shortName: f.teams.home.name, logoUrl: f.teams.home.logo);
    var awayTeam =
        Team(id: f.teams.away.id, name: f.teams.away.name, shortName: f.teams.away.name, logoUrl: f.teams.away.logo);

    var score = Score(home: f.goals.home, away: f.goals.away);
    var match = Match(
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      score: score,
      time: DateFormat('HH:mm').format(matchDateTime),
      status: getMatchStatus(f),
    );
    return match;
  }

  String getLogoUrl(List<FootballDataModels.Team> apiTeams, int teamId) {
    final apiTeam = apiTeams.firstWhere((t) => t.id == teamId, orElse: () => null);
    if (apiTeam != null) return apiTeam.crestUrl;
    return '';
  }

  String getMatchDay(FootballDataModels.Match match) {
    try {
      if (match.stage == "REGULAR_SEASON") {
        return 'Matchweek ${match.matchDay}';
      }
    } catch (e) {
      print('getMatchDay: $e');
    }
    return '';
  }

  MatchStatus getMatchStatus(ApiFootballModels.Fixture fixture) {
    var status = MatchStatus.Unknown;
    switch (fixture.details.status.short) {
      case 'PST':
        status = MatchStatus.Postponed;
        break;
      case 'FT':
      case 'AET':
      case 'PEN':
        status = MatchStatus.Finished;
        break;
      case 'CANC':
        status = MatchStatus.Cancelled;
        break;
      case '1H':
      case 'HT':
      case '2H':
      case 'ET':
      case 'P':
        status = MatchStatus.In_Play;
        break;
      case 'NS':
        status = MatchStatus.Scheduled;
        break;
    }

// TBD : Time To Be Defined
// NS : Not Started
// 1H : First Half, Kick Off
// HT : Halftime
// 2H : Second Half, 2nd Half Started
// ET : Extra Time
// P : Penalty In Progress
// FT : Match Finished
// AET : Match Finished After Extra Time
// PEN : Match Finished After Penalty
// BT : Break Time (in Extra Time)
// SUSP : Match Suspended
// INT : Match Interrupted
// PST : Match Postponed
// CANC : Match Cancelled
// ABD : Match Abandoned
// AWD : Technical Loss
// WO : WalkOver

    return status;
  }
}
