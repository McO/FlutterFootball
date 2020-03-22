import 'matchday.dart';
import 'package:json_annotation/json_annotation.dart';
part 'matchdays.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchDays {

  List<MatchDay> matchdays;

  MatchDays(this.matchdays);

  factory MatchDays.fromJson(Map<String, dynamic> json) => _$MatchDaysFromJson(json);
  Map<String, dynamic> toJson() => _$MatchDaysToJson(this);
}