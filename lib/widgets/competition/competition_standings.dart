import 'package:FlutterFootball/widgets/message.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/models/models.dart';

class CompetitionStandings extends StatefulWidget {
  final Competition competition;

  const CompetitionStandings(this.competition);

  @override
  _CompetitionStandingsState createState() => _CompetitionStandingsState(competition);
}

class _CompetitionStandingsState extends State<CompetitionStandings> with SingleTickerProviderStateMixin {
  final Competition competition;

  _CompetitionStandingsState(this.competition);

  Completer<void> refreshCompleter;
  StandingsBloc standingsBloc;

  @override
  void initState() {
    super.initState();

    standingsBloc = BlocProvider.of<StandingsBloc>(context);

    refreshCompleter = Completer<void>();
    standingsBloc.add(FetchStandings(competition: competition));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocConsumer<StandingsBloc, StandingsState>(
      listener: (context, state) {
        if (state is StandingsLoaded) {
          refreshCompleter?.complete();
          refreshCompleter = Completer();
        }
      },
      builder: (context, state) {
        if (state is StandingsUninitialized) {
          return Message(message: "Unintialised State");
        } else if (state is StandingsEmpty) {
          return Message(message: "No Standings available");
        } else if (state is StandingsError) {
          return Message(message: "Something went wrong");
        } else if (state is StandingsLoading) {
          return Container(child: Center(child: CircularProgressIndicator()));
        } else {
          final stateAsStandingsLoaded = state as StandingsLoaded;
          return buildPositions(stateAsStandingsLoaded.standings);
        }
      },
    ));
  }

  Widget buildPositions(Standings standings) {
    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      Text(
        '#',
        style: Theme.of(context).textTheme.caption,
      ),
      Text(
        'Team',
        style: Theme.of(context).textTheme.caption,
      ),
      Text(
        'Pl',
        style: Theme.of(context).textTheme.caption,
      ),
      Text(
        'W-D-L',
        style: Theme.of(context).textTheme.caption,
      ),
      Text(
        '+/-',
        style: Theme.of(context).textTheme.caption,
      ),
      Text(
        'GD',
        style: Theme.of(context).textTheme.caption,
      ),
      Text(
        'Pts',
        style: Theme.of(context).textTheme.caption,
      ),
    ]));
    for (int i = 0; i < standings.positions.length; ++i) {
      var position = standings.positions[i];
      rows.add(TableRow(children: [
        Text(
          position.rank.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          position.team.name,
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          position.played.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          '${position.wins}-${position.draws}-${position.losses}',
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          '${position.goalsFor}:${position.goalsAgainst}',
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          position.goalsDifference.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          position.points.toString(),
          style: Theme.of(context).textTheme.caption,
        ),
      ]));
    }
    return Table(children: rows);
  }
}
