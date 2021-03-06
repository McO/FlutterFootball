import 'dart:async';

import 'package:flutter_football/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_football/blocs/blocs.dart';
import 'package:flutter_football/models/models.dart';
import 'package:flutter_football/widgets/matches/day_list.dart';
import 'package:flutter_football/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ShowMatches {
  all,
  favorites,
  live,
}

class MatchesScreen extends StatefulWidget {
  @override
  MatchesScreenState createState() => MatchesScreenState();
}

class MatchesScreenState extends State<MatchesScreen> {
  MatchesBloc matchesBloc;
  Completer<void> refreshCompleter;
  var favouriteCompetitions = List<String>.empty(growable: true);
  SharedPreferences sharedPreferences;
  var showMatches = ShowMatches.favorites;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      favouriteCompetitions = sharedPreferences.getStringList('favouriteCompetitions');
      if (favouriteCompetitions == null) favouriteCompetitions = List<String>.empty(growable: true);

      setState(() {});
      matchesBloc = BlocProvider.of<MatchesBloc>(context);
      fetchMatches();
    });

    refreshCompleter = Completer<void>();
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showMatches = ShowMatches.favorites;
                  });
                  fetchMatches();
                },
                child: Text(
                  'Favourites',
                ),
                style: ElevatedButton.styleFrom(
                    primary: showMatches == ShowMatches.favorites ? Colors.black : Colors.white,
                    onPrimary: showMatches == ShowMatches.favorites ? Colors.white : kTextColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showMatches = ShowMatches.live;
                  });
                  fetchMatches();
                },
                child: Text(
                  'Live',
                ),
                style: ElevatedButton.styleFrom(
                  primary: showMatches == ShowMatches.live ? Colors.black : Colors.white,
                  onPrimary: showMatches == ShowMatches.live ? Colors.white : kTextColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showMatches = ShowMatches.all;
                  });
                  fetchMatches();
                },
                child: Text(
                  'All',
                ),
                style: ElevatedButton.styleFrom(
                  primary: showMatches == ShowMatches.all ? Colors.black : Colors.white,
                  onPrimary: showMatches == ShowMatches.all ? Colors.white : kTextColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: BlocConsumer<MatchesBloc, MatchesState>(
          listener: (context, state) {
            if (state is MatchesLoaded) {
              refreshCompleter?.complete();
              refreshCompleter = Completer();
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
        ),
      )
    ]);
  }

  Widget buildMatchesList(List<Day> days) {
    return RefreshIndicator(
        onRefresh: () {
          fetchMatches();
          return refreshCompleter.future;
        },
        child: DayList(days: days));
  }

  void fetchMatches() {
    switch (showMatches) {
      case ShowMatches.favorites:
        matchesBloc.add(FetchFavouriteMatches(favouriteCompetitions));
        break;
      case ShowMatches.live:
        matchesBloc.add(FetchLiveMatches());
        break;
      default:
        matchesBloc.add(FetchMatches());
        break;
    }
  }
}
