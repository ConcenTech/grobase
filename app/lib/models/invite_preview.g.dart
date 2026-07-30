// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvitePreview _$InvitePreviewFromJson(Map<String, dynamic> json) =>
    _InvitePreview(
      status: $enumDecode(_$InviteStatusEnumMap, json['status']),
      invitedByEmail: json['invited_by_email'] as String?,
      inverterName: json['inverter_display_name'] as String?,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$InvitePreviewToJson(_InvitePreview instance) =>
    <String, dynamic>{
      'status': _$InviteStatusEnumMap[instance.status]!,
      'invited_by_email': instance.invitedByEmail,
      'inverter_display_name': instance.inverterName,
      'expires_at': instance.expiresAt.toIso8601String(),
    };

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.expired: 'expired',
  InviteStatus.used: 'used',
  InviteStatus.revoked: 'revoked',
};
