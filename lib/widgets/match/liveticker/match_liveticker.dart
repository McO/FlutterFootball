import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:FlutterFootball/blocs/blocs.dart';

import 'package:FlutterFootball/models/models.dart' as Models;
import 'package:FlutterFootball/widgets/message.dart';

import 'match_liveticker_substitution.dart';
import 'match_liveticker_card.dart';
import 'match_liveticker_goal.dart';
import 'match_liveticker_item.dart';
import 'match_liveticker_missed_penalty.dart';

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

  Timer timer;

  @override
  void initState() {
    super.initState();

    matchBloc = BlocProvider.of<MatchEventsBloc>(context);

    refreshCompleter = Completer<void>();
    matchBloc.add(FetchMatchEvents(match: match));

    if (match.status == Models.MatchStatus.In_Play) {
      timer = Timer.periodic(Duration(seconds: 60), (timer) {
        setState(() {
          print('timer elapsed');
          matchBloc.add(FetchMatchEvents(match: match));
        });
      });
    }
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
        switch (event.type) {
          case Models.EventType.Card:
            return MatchLiveTickerCard(event);
            break;
          case Models.EventType.Substitution:
            return MatchLiveTickerSubstitution(event);
            break;
          case Models.EventType.Goal:
            return MatchLiveTickerGoal(event);
            break;
          case Models.EventType.MissedPenalty:
            return MatchLiveTickerMissedPenalty(event);
            break;
          case Models.EventType.Message:
            return MatchLiveTickerItem(event);
            break;
          default:
            return MatchLiveTickerItem(event);
        }
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
