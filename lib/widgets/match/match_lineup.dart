import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/widgets/message.dart';
import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart' as Models;

class MatchLineups extends StatefulWidget {
  final Models.Match match;

  const MatchLineups(this.match);

  @override
  _MatchLinupsState createState() => _MatchLinupsState();
}

class _MatchLinupsState extends State<MatchLineups> with SingleTickerProviderStateMixin {
  _MatchLinupsState();

  Completer<void> refreshCompleter;
  MatchLineupsBloc matchBloc;

  @override
  void initState() {
    super.initState();

    matchBloc = BlocProvider.of<MatchLineupsBloc>(context);

    refreshCompleter = Completer<void>();
    matchBloc.add(FetchMatchLineups(match: widget.match));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: RefreshIndicator(
            onRefresh: () {
              matchBloc.add(FetchMatchLineups(match: widget.match));
              return refreshCompleter.future;
            },
            child: BlocConsumer<MatchLineupsBloc, MatchLineupsState>(
              listener: (context, state) {
                if (state is MatchLineupsLoaded) {
                  refreshCompleter?.complete();
                  refreshCompleter = Completer();
                }
              },
              builder: (context, state) {
                if (state is MatchLineupsUninitialized) {
                  return Message(message: "Unintialised State");
                } else if (state is MatchLineupsEmpty) {
                  return Message(message: "No Lineups found");
                } else if (state is MatchLineupsError) {
                  return Message(message: "Something went wrong");
                } else if (state is MatchLineupsLoading) {
                  return Container(child: Center(child: CircularProgressIndicator()));
                } else {
                  final stateAsMatchLineupsLoaded = state as MatchLineupsLoaded;
                  return buildLineups(context, stateAsMatchLineupsLoaded.lineups);
                }
              },
            )),
      )
    ]);
  }

  Widget buildLineups(BuildContext context, Models.MatchLineups lineups) {
    return Column(children: [
      Row(children: [
        Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(child: Text(lineups.home.formation)),
            )),
        Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(child: Text(lineups.away.formation)),
            )),
      ]),
      Row(children: [
        Expanded(flex: 5, child: buildLineup(context, lineups.home.startingPlayers)),
        Expanded(flex: 5, child: buildLineup(context, lineups.away.startingPlayers)),
      ]),
      Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Bench',
            style: Theme.of(context).textTheme.caption,
          )),
      Container(
        child: Row(children: [
          Expanded(flex: 5, child: buildLineup(context, lineups.home.benchPlayers)),
          Expanded(flex: 5, child: buildLineup(context, lineups.away.benchPlayers)),
        ]),
      ),
    ]);
  }
}

Widget buildLineup(BuildContext context, List<Models.Player> players) {
  return ListView.separated(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, index) {
      var player = players[index];
      return Row(children: [
        SizedBox(
          width: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              player.number.toString(),
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Text(
          player.name,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.start,
        ),
      ]);
    },
    separatorBuilder: (BuildContext context, index) {
      return Divider(
        height: 8.0,
        // color: Colors.transparent,
      );
    },
    itemCount: players.length,
  );
}
