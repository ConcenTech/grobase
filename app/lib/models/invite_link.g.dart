// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InviteLink _$InviteLinkFromJson(Map<String, dynamic> json) => _InviteLink(
  id: json['invite_id'] as String,
  token: json['token'] as String,
  url: json['invite_url'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$InviteLinkToJson(_InviteLink instance) =>
    <String, dynamic>{
      'invite_id': instance.id,
      'token': instance.token,
      'invite_url': instance.url,
      'expires_at': instance.expiresAt.toIso8601String(),
    };
