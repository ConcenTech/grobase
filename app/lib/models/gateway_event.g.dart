// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GatewayEvent _$GatewayEventFromJson(Map<String, dynamic> json) =>
    _GatewayEvent(
      id: (json['id'] as num).toInt(),
      gatewayId: json['gateway_id'] as String,
      inverterId: json['inverter_id'] as String,
      level: $enumDecode(_$GatewayEventLevelEnumMap, json['level']),
      code: json['code'] as String,
      message: json['message'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      ingestedAt: DateTime.parse(json['ingested_at'] as String),
    );

Map<String, dynamic> _$GatewayEventToJson(_GatewayEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gateway_id': instance.gatewayId,
      'inverter_id': instance.inverterId,
      'level': _$GatewayEventLevelEnumMap[instance.level]!,
      'code': instance.code,
      'message': instance.message,
      'metadata': instance.metadata,
      'recorded_at': instance.recordedAt.toIso8601String(),
      'ingested_at': instance.ingestedAt.toIso8601String(),
    };

const _$GatewayEventLevelEnumMap = {
  GatewayEventLevel.info: 'info',
  GatewayEventLevel.warn: 'warn',
  GatewayEventLevel.error: 'error',
};
