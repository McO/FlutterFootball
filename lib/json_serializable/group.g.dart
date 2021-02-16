// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group()
    ..name = json['name'] as String
    ..matches =
        (json['matches'] as List)?.map((e) => e == null ? null : Match.fromJson(e as Map<String, dynamic>))?.toList();
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'name': instance.name,
      'matches': instance.matches?.map((e) => e?.toJson())?.toList(),
    };
