import 'package:FlutterFootball/models/api/competition.dart';

class CompetitionsResult {
  final List<Competition> competitions;

  const CompetitionsResult({this.competitions});

  static CompetitionsResult fromJson(Map<String, dynamic> json) {
    final items = (json['competitions'] as List<dynamic>)
        .map((dynamic item) =>
        Competition.fromJson(item as Map<String, dynamic>))
        .toList();
    return CompetitionsResult(competitions: items);
  }

}
