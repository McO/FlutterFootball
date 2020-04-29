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

  @override
  void initState() {
    super.initState();

    BlocProvider.of<MatchBloc>(context).add(FetchMatches());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<MatchBloc>(context),
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
    return DayList(days: days);
//    return RefreshIndicator(
//      onRefresh: () => _bloc.fetchMatches(),
//      child: StreamBuilder<Response<List<Day>>>(
//        stream: _bloc.footballDataStream,
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            switch (snapshot.data.status) {
//              case Status.LOADING:
//                return Loading(loadingMessage: snapshot.data.message);
//                break;
//              case Status.COMPLETED:
//                return DayList(days: snapshot.data.data);
//                break;
//              case Status.ERROR:
//                return Error(
//                  errorMessage: snapshot.data.message,
//                  onRetryPressed: () => _bloc.fetchMatches(),
//                );
//                break;
//            }
//          }
//          return Container();
//        },
//      ),
//    );
  }
}
