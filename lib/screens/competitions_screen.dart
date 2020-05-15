import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart';
import 'package:FlutterFootball/widgets/message.dart';
import 'package:FlutterFootball/widgets/logo_icon.dart';
import 'package:FlutterFootball/screens/competition_screen.dart';

class CompetitionsScreen extends StatefulWidget {
  @override
  State<CompetitionsScreen> createState() => CompetitionsScreenState();
}

class CompetitionsScreenState extends State<CompetitionsScreen> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer<void>();
    BlocProvider.of<CompetitionsBloc>(context).add(FetchCompetitions());
  }

  Widget build(BuildContext context) {
    return BlocConsumer<CompetitionsBloc, CompetitionsState>(
      listener: (context, state) {
        if (state is CompetitionsLoaded) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
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
    );
  }

  Widget buildCompetitionList(List<Competition> competitions) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<CompetitionsBloc>(context).add(FetchCompetitions());
        return _refreshCompleter.future;
      },
      child: Container(
        child: ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Competition competition = competitions[index];
            return new GestureDetector(
              //You need to make my child interactive
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompetitionDetail(competition)),
              ),
              child: Container(
                color: Colors.white30,
                child: ListTile(
                  leading: CircleAvatar(
                    child: LogoIcon(competition.logoUrl ?? '', 30, false),
                    radius: 30.0,
                    backgroundColor: Colors.blue[50],
                  ),
                  title: Text(
                    competition.name,
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
        ),
      ),
    );
  }
}
