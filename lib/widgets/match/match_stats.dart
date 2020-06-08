import 'package:FlutterFootball/widgets/message.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart' as Models;

class MatchStatistics extends StatefulWidget {
  final Models.Match match;

  MatchStatistics(this.match);

  @override
  _MatchStatisticsState createState() => _MatchStatisticsState(match);
}

class _MatchStatisticsState extends State<MatchStatistics> with SingleTickerProviderStateMixin {
  final Models.Match match;

  _MatchStatisticsState(this.match);

  Completer<void> refreshCompleter;
  MatchStatisticsBloc matchBloc;

  @override
  void initState() {
    super.initState();

    matchBloc = BlocProvider.of<MatchStatisticsBloc>(context);

    refreshCompleter = Completer<void>();
    matchBloc.add(FetchMatchStatistics(match: match));
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
              matchBloc.add(FetchMatchStatistics(match: match));
              return refreshCompleter.future;
            },
            child: BlocConsumer<MatchStatisticsBloc, MatchStatisticsState>(
              listener: (context, state) {
                if (state is MatchStatisticsLoaded) {
                  refreshCompleter?.complete();
                  refreshCompleter = Completer();
                }
              },
              builder: (context, state) {
                if (state is MatchStatisticsUninitialized) {
                  return Message(message: "Unintialised State");
                } else if (state is MatchStatisticsEmpty) {
                  return Message(message: "No Statistics found");
                } else if (state is MatchStatisticsError) {
                  return Message(message: "Something went wrong");
                } else if (state is MatchStatisticsLoading) {
                  return Container(child: Center(child: CircularProgressIndicator()));
                } else {
                  final stateAsMatchStatisticsLoaded = state as MatchStatisticsLoaded;
                  return buildStatistics(stateAsMatchStatisticsLoaded.statistics);
                }
              },
            )),
      )
    ]);
  }

  Widget buildStatistics(Models.MatchStatistics statistics) {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        var statisticDetail = statistics.details[index];
        return Column(children: [
          Center(
            child: Text(
              statisticDetail.name,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 38.0,
                  child: Card(
                      child: Stack(
                    alignment: FractionalOffset.centerRight,
                    children: [
                      if (statisticDetail.maxValue > 0)
                        FractionallySizedBox(
                          widthFactor: statisticDetail.home / statisticDetail.maxValue,
                          heightFactor: 1,
                          child: Container(color: Colors.lightGreen),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(statisticDetail.home.toString() ?? ''),
                      )
                    ],
                  )),
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 38.0,
                  child: Card(
                      child: Stack(
                    children: [
                      if (statisticDetail.maxValue > 0)
                        FractionallySizedBox(
                          alignment: FractionalOffset.centerLeft,
                          widthFactor: statisticDetail.away / statisticDetail.maxValue,
                          heightFactor: 1,
                          child: Container(color: Colors.blueGrey),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(statisticDetail.away.toString() ?? ''),
                      )
                    ],
                  )),
                ),
              ),
            ]),
          )
        ]);
      },
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          height: 8.0,
          color: Colors.transparent,
        );
      },
      itemCount: statistics.details.length,
    );
  }
}
