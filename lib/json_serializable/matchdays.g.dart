// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchdays.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchDays _$MatchDaysFromJson(Map<String, dynamic> json) {
  return MatchDays(
    (json['matchdays'] as List)
        ?.map((e) =>
            e == null ? null : MatchDay.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MatchDaysToJson(MatchDays instance) => <String, dynamic>{
      'matchdays': instance.matchdays?.map((e) => e?.toJson())?.toList(),
    };
