import 'package:json_annotation/json_annotation.dart';
part 'competition.g.dart';

@JsonSerializable()
class Competition {

  final int id;
  final String name;

  Competition({this.id, this.name});

  factory Competition.fromJson(Map<String, dynamic> json) => _$CompetitionFromJson(json);
  Map<String, dynamic> toJson() => _$CompetitionToJson(this);
}