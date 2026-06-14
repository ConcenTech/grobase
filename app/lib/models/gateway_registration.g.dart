// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GatewayRegistrationResponse _$GatewayRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => _GatewayRegistrationResponse(
  gatewayId: json['gateway_id'] as String,
  inverterId: json['inverter_id'] as String,
  deviceSecret: json['device_secret'] as String,
  inverterSerialNumber: json['inverter_sn'] as String,
);

Map<String, dynamic> _$GatewayRegistrationResponseToJson(
  _GatewayRegistrationResponse instance,
) => <String, dynamic>{
  'gateway_id': instance.gatewayId,
  'inverter_id': instance.inverterId,
  'device_secret': instance.deviceSecret,
  'inverter_sn': instance.inverterSerialNumber,
};

_GatewayRegistrationRequest _$GatewayRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => _GatewayRegistrationRequest(
  mode: $enumDecode(_$GatewayRegistrationModeEnumMap, json['mode']),
  hardwareId: json['hardware_id'] as String,
  inverterSerialNumber: json['inverter_sn'] as String,
  profile: json['profile'] as String?,
  inverterId: json['inverter_id'] as String?,
);

Map<String, dynamic> _$GatewayRegistrationRequestToJson(
  _GatewayRegistrationRequest instance,
) => <String, dynamic>{
  'mode': _$GatewayRegistrationModeEnumMap[instance.mode]!,
  'hardware_id': instance.hardwareId,
  'inverter_sn': instance.inverterSerialNumber,
  'profile': instance.profile,
  'inverter_id': instance.inverterId,
};

const _$GatewayRegistrationModeEnumMap = {
  GatewayRegistrationMode.create: 'new',
  GatewayRegistrationMode.replace: 'replace',
};
