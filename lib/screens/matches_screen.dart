import 'package:FlutterFootball/bloc/bloc.dart';
import 'package:FlutterFootball/models/day.dart';
import 'package:FlutterFootball/network/response.dart';
import 'package:FlutterFootball/widgets/competition_matches_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchesScreen extends StatefulWidget {
  @override
  MatchesScreenState createState() {
    return new MatchesScreenState();
  }
}

class MatchesScreenState extends State<MatchesScreen> {
  FootballBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = FootballBloc();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _bloc.fetchMatches(),
      child: StreamBuilder<Response<List<Day>>>(
        stream: _bloc.footballDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return DayList(days: snapshot.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchMatches(),
                );
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}


class DayList extends StatelessWidget {
  final List<Day> days;

  const DayList({Key key, this.days}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: days.length,
      itemBuilder: (context, i) =>
      new Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                DateFormat('EEEE, MMMM d').format(days[i].date),
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
          ListView.builder(
            shrinkWrap: true,
            itemCount: days[i].dayCompetitionsMatches.length,
            itemBuilder: (context, j) => CompetitionMatchesCard(days[i].dayCompetitionsMatches[j]),
          ),
        ],
      ),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.white,
            child: Text('Retry', style: TextStyle(color: Colors.black)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}