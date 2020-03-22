
import 'package:json_annotation/json_annotation.dart';
part 'team.g.dart';

@JsonSerializable(explicitToJson: true)
class Team {

  final int id;
  final String name;

  Team(this.id, this.name);

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}