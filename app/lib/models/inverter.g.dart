// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inverter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Inverter _$InverterFromJson(Map<String, dynamic> json) => _Inverter(
  id: json['id'] as String,
  serialNumber: json['serial_number'] as String,
  displayName: json['display_name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InverterToJson(_Inverter instance) => <String, dynamic>{
  'id': instance.id,
  'serial_number': instance.serialNumber,
  'display_name': instance.displayName,
  'created_at': instance.createdAt.toIso8601String(),
  'last_seen_at': instance.lastSeenAt.toIso8601String(),
  'location': instance.location,
};
