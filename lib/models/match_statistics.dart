import 'package:FlutterFootball/models/models.dart';

class MatchStatisticDetail {
  final String category;
  final String name;
  String home;
  String away;

  MatchStatisticDetail({this.category, this.name, this.home, this.away});
}

class MatchStatistics {
  final String matchId;
  final Team homeTeam;
  final Team awayTeam;
  final List<MatchStatisticDetail> details;

  MatchStatistics({this.matchId, this.homeTeam, this.awayTeam, this.details});
}
