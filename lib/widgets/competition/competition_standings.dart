import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_football/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_football/models/models.dart';
import 'package:flutter_football/widgets/message.dart';

import 'package:flutter_football/widgets/competition/table.dart';

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
          return buildCompetitionTable(stateAsStandingsLoaded.standings);
        }
      },
    ));
  }

  Widget buildCompetitionTable(List<Standings> standings) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: standings.length,
        itemBuilder: (BuildContext context, int index) {
          return CompetitionTable(standings[index], standings.length > 1);
        });
  }
}
