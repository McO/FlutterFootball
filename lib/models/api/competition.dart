import 'package:FlutterFootball/models/models.dart';

class Competition extends CompetitionBase {


  const Competition({id, name, logoUrl})
      : super(id: id, name: name, logoUrl: logoUrl);

  static Competition fromJson(dynamic json) {
    return Competition(
        id: json['id'] as int,
        name: json['name'] as String,
        logoUrl: null);
  }
}

