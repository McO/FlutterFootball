import 'package:flutter/material.dart';

import 'dart:async';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart' as Models;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../message.dart';
import 'package:FlutterFootball/widgets/matches/day_list.dart';

class CompetitionMatchDay extends StatefulWidget {
  final Models.Competition competition;

  const CompetitionMatchDay(this.competition);

  @override
  _CompetitionMatchDayState createState() => _CompetitionMatchDayState(competition);
}

class _CompetitionMatchDayState extends State<CompetitionMatchDay> with SingleTickerProviderStateMixin {
  final Models.Competition competition;

  _CompetitionMatchDayState(this.competition);

  Completer<void> refreshCompleter;
  CompetitionRoundBloc competitionRoundBloc;

  @override
  void initState() {
    super.initState();

    competitionRoundBloc = BlocProvider.of<CompetitionRoundBloc>(context);

    refreshCompleter = Completer<void>();
    competitionRoundBloc.add(FetchCompetitionRound(competition, null));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocConsumer<CompetitionRoundBloc, CompetitionRoundState>(
      listener: (context, state) {
        if (state is CompetitionRoundLoaded) {
          refreshCompleter?.complete();
          refreshCompleter = Completer();
        }
      },
      builder: (context, state) {
        if (state is CompetitionRoundUninitialized) {
          return Message(message: "Unintialised State");
        } else if (state is CompetitionRoundEmpty) {
          return Message(message: "No Matches available");
        } else if (state is CompetitionRoundError) {
          return Message(message: "Something went wrong");
        } else if (state is CompetitionRoundLoading) {
          return Container(child: Center(child: CircularProgressIndicator()));
        } else {
          final stateAsRoundLoaded = state as CompetitionRoundLoaded;
          return buildPositions(context, stateAsRoundLoaded.rounds, stateAsRoundLoaded.days);
        }
      },
    ));
  }

  Widget buildPositions(BuildContext context, List<Models.Round> rounds, List<Models.Day> days) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.arrow_left),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(rounds.firstWhere((r) => r.current).name),
            ),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
      Expanded(child: DayList(days: days, showCompetitionHead: false))
    ]);
  }
}