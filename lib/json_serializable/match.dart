import 'team.dart';
import 'package:json_annotation/json_annotation.dart';
part 'match.g.dart';

@JsonSerializable(explicitToJson: true)
class Match {

  final int id;
  DateTime kickoff;
  @JsonKey(name: 'score_home')
  int scoreHome;
  @JsonKey(name: 'score_away')
  int scoreAway;
  @JsonKey(name: 'team_home')
  Team teamHome;
  @JsonKey(name: 'team_away')
  Team teamAway;

  Match(this.id);

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
  Map<String, dynamic> toJson() => _$MatchToJson(this);
}