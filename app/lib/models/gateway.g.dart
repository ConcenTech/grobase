// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Gateway _$GatewayFromJson(Map<String, dynamic> json) => _Gateway(
  id: json['id'] as String,
  hardwareId: json['hardware_id'] as String,
  inverterId: json['inverter_id'] as String,
  status: $enumDecode(_$GatewayStatusEnumMap, json['status']),
  provisionedBy: json['provisioned_by'] as String,
  lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
  firmwareVersion: json['firmware_version'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  retiredAt: DateTime.parse(json['retired_at'] as String),
);

Map<String, dynamic> _$GatewayToJson(_Gateway instance) => <String, dynamic>{
  'id': instance.id,
  'hardware_id': instance.hardwareId,
  'inverter_id': instance.inverterId,
  'status': _$GatewayStatusEnumMap[instance.status]!,
  'provisioned_by': instance.provisionedBy,
  'last_seen_at': instance.lastSeenAt.toIso8601String(),
  'firmware_version': instance.firmwareVersion,
  'created_at': instance.createdAt.toIso8601String(),
  'retired_at': instance.retiredAt.toIso8601String(),
};

const _$GatewayStatusEnumMap = {
  GatewayStatus.pending: 'pending',
  GatewayStatus.active: 'active',
  GatewayStatus.retired: 'retired',
};
