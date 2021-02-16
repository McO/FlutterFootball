// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) {
  return Match(
    json['id'] as int,
  )
    ..kickoff = json['kickoff'] == null ? null : DateTime.parse(json['kickoff'] as String)
    ..scoreHome = json['score_home'] as int
    ..scoreAway = json['score_away'] as int
    ..teamHome = json['team_home'] == null ? null : Team.fromJson(json['team_home'] as Map<String, dynamic>)
    ..teamAway = json['team_away'] == null ? null : Team.fromJson(json['team_away'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'kickoff': instance.kickoff?.toIso8601String(),
      'score_home': instance.scoreHome,
      'score_away': instance.scoreAway,
      'team_home': instance.teamHome?.toJson(),
      'team_away': instance.teamAway?.toJson(),
    };
