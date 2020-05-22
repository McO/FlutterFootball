import 'package:FlutterFootball/widgets/message.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import '../models/models.dart' as Models;

class MatchLiveTicker extends StatefulWidget {
  final Models.Match match;

  MatchLiveTicker(this.match);

  @override
  _MatchLiveTickerState createState() => _MatchLiveTickerState(match);
}

class _MatchLiveTickerState extends State<MatchLiveTicker> with SingleTickerProviderStateMixin {
  final Models.Match match;

  _MatchLiveTickerState(this.match);

  Completer<void> refreshCompleter;
  MatchEventsBloc matchBloc;

  @override
  void initState() {
    super.initState();

    matchBloc = BlocProvider.of<MatchEventsBloc>(context);

    refreshCompleter = Completer<void>();
    matchBloc.add(FetchMatchEvents(match: match));
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
              matchBloc.add(FetchMatchEvents(match: match));
              return refreshCompleter.future;
            },
            child: BlocConsumer<MatchEventsBloc, MatchEventsState>(
              listener: (context, state) {
                if (state is MatchEventsLoaded) {
                  refreshCompleter?.complete();
                  refreshCompleter = Completer();
                }
              },
              builder: (context, state) {
                if (state is MatchEventsUninitialized) {
                  return Message(message: "Unintialised State");
                } else if (state is MatchEventsEmpty) {
                  return Message(message: "No data available");
                } else if (state is MatchEventsError) {
                  return Message(message: "Something went wrong");
                } else if (state is MatchEventsLoading) {
                  return Container(child: Center(child: CircularProgressIndicator()));
                } else {
                  final stateAsMatchEventsLoaded = state as MatchEventsLoaded;
                  return buildEvents(stateAsMatchEventsLoaded.events);
                }
              },
            )),
      )
    ]);
  }

  Widget buildEvents(Models.MatchEvents events) {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        var event = events.events[index];
        return Row(children: [
          Text(event.minute.toString() ?? ''),
          Text(event.text ?? ''),
        ]);
      },
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          height: 8.0,
          color: Colors.transparent,
        );
      },
      itemCount: events.events.length,
    );
  }
}
