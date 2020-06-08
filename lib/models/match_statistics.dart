import 'dart:math';

import 'package:FlutterFootball/models/models.dart';

enum StatisticsCategory { General, Offense, Defense, Distribution, Discipline }

class MatchStatisticDetail {
  final StatisticsCategory category;
  final String name;
  int home;
  int away;
  bool isPercentage;

  MatchStatisticDetail({this.category, this.name, this.home, this.away, this.isPercentage});

  int get maxValue {
    if (isPercentage) return 100;
    return max(home, away);
  }
}

class MatchStatistics {
  final String matchId;
  final Team homeTeam;
  final Team awayTeam;
  List<MatchStatisticDetail> details;

  MatchStatistics({this.matchId, this.homeTeam, this.awayTeam, this.details});
}
