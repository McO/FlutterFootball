import 'package:FlutterFootball/models/models.dart';

class MatchEvent {
  final int minute;
  final String text;

  MatchEvent({this.text, this.minute});
}

class MatchEvents {
  final String matchId;
  final List<MatchEvent> events;

  MatchEvents({this.matchId, this.events});
}
