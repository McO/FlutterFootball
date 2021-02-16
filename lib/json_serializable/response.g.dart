// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
    json['code'] as int,
    json['message'] as String,
    json['status'] as String,
  )..data = json['data'] == null ? null : MatchDays.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'status': instance.status,
      'data': instance.data?.toJson(),
    };
