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

