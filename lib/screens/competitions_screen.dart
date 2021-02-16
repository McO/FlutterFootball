import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart' as Models;
import 'package:FlutterFootball/widgets/message.dart';
import 'package:FlutterFootball/widgets/logo_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompetitionsScreen extends StatefulWidget {
  @override
  State<CompetitionsScreen> createState() => CompetitionsScreenState();
}

class CompetitionsScreenState extends State<CompetitionsScreen> {
  Completer<void> refreshCompleter;
  CompetitionsBloc competitionsBloc;
  var favouriteCompetitions = List<String>.empty(growable: true);
  SharedPreferences sharedPreferences;
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    competitionsBloc = BlocProvider.of<CompetitionsBloc>(context);

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      favouriteCompetitions = sharedPreferences.getStringList('favouriteCompetitions');
      if (favouriteCompetitions == null) favouriteCompetitions = List<String>.empty(growable: true);

      setState(() {});
    });

    refreshCompleter = Completer<void>();
    competitionsBloc.add(FetchCompetitions());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textEditingController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(children: [
      buildSearchBar(),
      Expanded(
        child: RefreshIndicator(
            onRefresh: () {
              competitionsBloc.add(FetchCompetitions());
              return refreshCompleter.future;
            },
            child: BlocConsumer<CompetitionsBloc, CompetitionsState>(
              listener: (context, state) {
                if (state is CompetitionsLoaded) {
                  refreshCompleter?.complete();
                  refreshCompleter = Completer();
                }
              },
              builder: (context, state) {
                if (state is CompetitionsUninitialized) {
                  return Message(message: "Unintialised State");
                } else if (state is CompetitionsEmpty) {
                  return Message(message: "No Competitions found");
                } else if (state is CompetitionsError) {
                  return Message(message: "Something went wrong");
                } else if (state is CompetitionsLoading) {
                  return Container(child: Center(child: CircularProgressIndicator()));
                } else {
                  final stateAsCompetitionsLoaded = state as CompetitionsLoaded;
                  final competitions = stateAsCompetitionsLoaded.competitions;
                  return buildCompetitionList(competitions);
                }
              },
            )),
      )
    ]);
  }

  _toggleCompetition(int competitionId) async {
    print('toggle: $competitionId');
    if (favouriteCompetitions.contains(competitionId.toString()))
      favouriteCompetitions.remove(competitionId.toString());
    else
      favouriteCompetitions.add(competitionId.toString());
    await sharedPreferences.setStringList('favouriteCompetitions', favouriteCompetitions);
  }

  Widget buildCompetitionList(List<Models.Competition> competitions) {
    return ListView.separated(
      itemBuilder: (BuildContext context, index) {
        var competition = competitions[index];
        final bool alreadySaved = favouriteCompetitions.contains(competition.id.toString());
        return new GestureDetector(
          onTap: () {
            setState(() {
              _toggleCompetition(competition.id);
            });
          },
          child: Container(
            color: Colors.white30,
            child: ListTile(
              leading: LogoIcon(competition.logoUrl ?? '', 25, false),
              // CircleAvatar(
              //   child: LogoIcon(competition.logoUrl ?? '', 35, false),
              //   radius: 15.0,
              //   backgroundColor: Colors.blue[50],
              // ),
              title: Text(
                competition.name,
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          height: 8.0,
          color: Colors.transparent,
        );
      },
      itemCount: competitions.length,
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                hintText: 'Search Competitions',
                icon: Icon(Icons.search),
                border: InputBorder.none,
                // contentPadding: EdgeInsets.symmetric(vertical: -10)
                isDense: true),
            onChanged: (text) {
              competitionsBloc.add(SearchCompetitions(text));
            },
          ),
        ),
      ),
    );
  }
}
