import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/models/models.dart';
import 'package:FlutterFootball/widgets/message.dart';
import 'package:flutter_svg/svg.dart';

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
    BlocProvider.of<CompetitionBloc>(context).add(FetchCompetitions());
  }

  Widget build(BuildContext context) {
    return BlocConsumer<CompetitionBloc, CompetitionsState>(
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
          return Message(message: "No Players found");
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
        BlocProvider.of<CompetitionBloc>(context).add(FetchCompetitions());
        return _refreshCompleter.future;
      },
      child: Container(
        child: ListView.separated(
          itemBuilder: (BuildContext context, index) {
            Competition competition = competitions[index];
            return Container(
              color: Colors.white30,
              child: ListTile(
                leading: CircleAvatar(
//                child: Image.network(
//                  competition.logoUrl ?? '',
//                ),
                  child: SvgPicture.network(
                    competition.logoUrl ?? '',
                    height: 20,
                  ),
                  radius: 30.0,
                  backgroundColor: Colors.blue[50],
                ),
                title: Text(
                  competition.name,
//                style: TextStyle(fontSize: 22.0, color: Colors.black),
                ),
//              subtitle: Text(
//                "Age: " + competition.age.toString(),
//                style: TextStyle(fontSize: 16.0, color: Colors.black87),
//              ),
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
