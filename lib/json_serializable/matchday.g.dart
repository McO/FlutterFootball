// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchDay _$MatchDayFromJson(Map<String, dynamic> json) {
  return MatchDay(
    json['id'] as int,
    json['name'] as String,
    json['number'] as int,
    json['competition'] == null ? null : Competition.fromJson(json['competition'] as Map<String, dynamic>),
  )..groups =
      (json['groups'] as List)?.map((e) => e == null ? null : Group.fromJson(e as Map<String, dynamic>))?.toList();
}

Map<String, dynamic> _$MatchDayToJson(MatchDay instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'competition': instance.competition?.toJson(),
      'groups': instance.groups?.map((e) => e?.toJson())?.toList(),
    };
