import 'dart:async';
import 'package:FlutterFootball/data/football_repository.dart';
import 'package:FlutterFootball/models/day.dart';
import 'package:FlutterFootball/network/response.dart';

class FootballBloc {
  FootballRepository _repository;
  StreamController _streamController;

  StreamSink<Response<List<Day>>> get footballDataSink =>
      _streamController.sink;

  Stream<Response<List<Day>>> get footballDataStream =>
      _streamController.stream;

  FootballBloc() {
    _streamController = StreamController<Response<List<Day>>>();
    _repository = FootballRepository();
    fetchMatches();
  }

  fetchMatches() async {
    footballDataSink.add(Response.loading('Getting match data ...'));
    try {
      List<Day> days = await _repository.fetchMatches();
      footballDataSink.add(Response.completed(days));
    } catch (e) {
      footballDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _streamController?.close();
  }
}