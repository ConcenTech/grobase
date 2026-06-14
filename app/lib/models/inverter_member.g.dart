// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inverter_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InverterMember _$InverterMemberFromJson(Map<String, dynamic> json) =>
    _InverterMember(
      inverterId: json['inverter_id'] as String,
      userId: json['user_id'] as String,
      role: $enumDecode(_$InverterMemberRoleEnumMap, json['role']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$InverterMemberToJson(_InverterMember instance) =>
    <String, dynamic>{
      'inverter_id': instance.inverterId,
      'user_id': instance.userId,
      'role': _$InverterMemberRoleEnumMap[instance.role]!,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$InverterMemberRoleEnumMap = {
  InverterMemberRole.owner: 'owner',
  InverterMemberRole.viewer: 'viewer',
};
