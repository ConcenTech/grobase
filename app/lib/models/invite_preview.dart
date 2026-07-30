// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'invite_status.dart';

part 'invite_preview.freezed.dart';
part 'invite_preview.g.dart';

@freezed
abstract class InvitePreview with _$InvitePreview {
  const factory InvitePreview({
    @JsonKey(name: 'status') required InviteStatus status,
    @JsonKey(name: 'invited_by_email') String? invitedByEmail,
    @JsonKey(name: 'inverter_display_name') String? inverterName,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _InvitePreview;

  factory InvitePreview.fromJson(Map<String, dynamic> json) =>
      _$InvitePreviewFromJson(json);
}
