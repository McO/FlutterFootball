import 'package:FlutterFootball/models/api/area.dart';
import 'package:FlutterFootball/models/models.dart';

class Competition extends CompetitionBase {
  final Area area;

  const Competition({id, name, logoUrl, this.area})
      : super(id: id, name: name, logoUrl: null);

  static Competition fromJson(dynamic json) {
    return Competition(
        id: json['id'] as int,
        name: json['name'] as String,
        area: Area.fromJson(json['area'])
    );
  }
}

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

