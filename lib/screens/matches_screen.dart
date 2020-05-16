import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart';
import 'package:FlutterFootball/widgets/day_list.dart';
import 'package:FlutterFootball/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchesScreen extends StatefulWidget {
  @override
  MatchesScreenState createState() => MatchesScreenState();
}

class MatchesScreenState extends State<MatchesScreen> {
  Completer<void> _refreshCompleter;
  List<String> favouriteCompetitions = List<String>();
  SharedPreferences sharedPreferences;
  bool showFavourites = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      favouriteCompetitions = sharedPreferences.getStringList('favouriteCompetitions');
      if (favouriteCompetitions == null) favouriteCompetitions = List<String>();

      setState(() {});
    });

    _refreshCompleter = Completer<void>();
    if (showFavourites)
      BlocProvider.of<MatchesBloc>(context).add(FetchFavouriteMatches(favouriteCompetitions));
    else
      BlocProvider.of<MatchesBloc>(context).add(FetchMatches());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ButtonTheme(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        height: 25,
        minWidth: 0,
        textTheme: ButtonTextTheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Row(
            children: [
              RaisedButton(
                onPressed: () {
                  setState(() {
                    showFavourites = false;
                  });
                  BlocProvider.of<MatchesBloc>(context).add(FetchMatches());
                },
                child: Text(
                  'All',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                ),
                color: showFavourites ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              ),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      showFavourites = true;
                    });
                    BlocProvider.of<MatchesBloc>(context).add(FetchFavouriteMatches(favouriteCompetitions));
                  },
                  child: Text(
                    'Favourites',
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                  ),
                  color: showFavourites ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ],
          ),
        ),
      ),
      BlocConsumer<MatchesBloc, MatchesState>(
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
            return Expanded(child: buildMatchesList(days));
          }
        },
      )
    ]);
  }

  Widget buildMatchesList(List<Day> days) {
    return RefreshIndicator(
        onRefresh: () {
          if (showFavourites)
            BlocProvider.of<MatchesBloc>(context).add(FetchFavouriteMatches(favouriteCompetitions));
          else
            BlocProvider.of<MatchesBloc>(context).add(FetchMatches());
          return _refreshCompleter.future;
        },
        child: DayList(days: days));
  }
}
