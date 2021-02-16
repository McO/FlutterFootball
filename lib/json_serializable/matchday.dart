import 'competition.dart';
import 'group.dart';
import 'package:json_annotation/json_annotation.dart';
part 'matchday.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchDay {
  final int id;
  final String name;
  int number;
  Competition competition;
  List<Group> groups;

  MatchDay(this.id, this.name, this.number, this.competition);

  factory MatchDay.fromJson(Map<String, dynamic> json) => _$MatchDayFromJson(json);
  Map<String, dynamic> toJson() => _$MatchDayToJson(this);
}
