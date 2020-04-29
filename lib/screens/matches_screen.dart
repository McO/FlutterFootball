import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart';
import 'package:FlutterFootball/widgets/day_list.dart';
import 'package:FlutterFootball/widgets/message.dart';

class MatchesScreen extends StatefulWidget {
  @override
  MatchesScreenState createState() => MatchesScreenState();
}

class MatchesScreenState extends State<MatchesScreen> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer<void>();
    BlocProvider.of<MatchBloc>(context).add(FetchMatches());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchBloc, MatchesState>(
        listener: (context, state) {
          if (state is MatchesLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is MatchesUninitialized) {
            return Message(message: "Unintialised State");
          } else if (state is MatchesEmpty) {
            return Message(message: "No Matches found");
          } else if (state is MatchesError) {
            return Message(message: "Something went wrong");
          } else if (state is MatchesLoading) {
            return Container(child: Center(child: CircularProgressIndicator()));
          } else {
            final stateAsMatchesLoaded = state as MatchesLoaded;
            final days = stateAsMatchesLoaded.days;
            return buildMatchesList(days);
          }
        },
    );
  }

  Widget buildMatchesList(List<Day> days) {
    return RefreshIndicator(
        onRefresh: () {
          BlocProvider.of<MatchBloc>(context).add(FetchMatches());
          return _refreshCompleter.future;
        },
        child: DayList(days: days)
    );
  }
}
