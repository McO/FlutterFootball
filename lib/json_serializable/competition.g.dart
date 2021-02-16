// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Competition _$CompetitionFromJson(Map<String, dynamic> json) {
  return Competition(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$CompetitionToJson(Competition instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
