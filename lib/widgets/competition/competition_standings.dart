import 'package:FlutterFootball/widgets/logo_icon.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:FlutterFootball/theme/colors.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/models/models.dart';
import 'package:FlutterFootball/widgets/message.dart';

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
    var rows = List<TableRow>();
    rows.add(TableRow(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))), children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '#',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Team',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Pl',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'W-D-L',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '+/-',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'GD',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ),
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Pts',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.right,
          ),
        ),
      ),
    ]));
    for (int i = 0; i < standings.positions.length; ++i) {
      var position = standings.positions[i];
      rows.add(TableRow(
          decoration: BoxDecoration(
              color: (i.isOdd ? kAlternatingBackgroundColor : Colors.white),
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  position.rank.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            TableCell(
              child: Padding(padding: const EdgeInsets.all(8.0), child: LogoIcon(position.team.logoUrl, 16, false)),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  position.team.shortName,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  position.played.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${position.wins}-${position.draws}-${position.losses}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${position.goalsFor}:${position.goalsAgainst}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  position.goalsDifference.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  position.points.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ]));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
            3: IntrinsicColumnWidth(),
            4: IntrinsicColumnWidth(),
            5: IntrinsicColumnWidth(),
            6: IntrinsicColumnWidth(),
            7: IntrinsicColumnWidth(),
          },
          children: rows),
    );
  }
}
